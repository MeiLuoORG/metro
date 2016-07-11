//
//  MLPersonDetailViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonOrderDetailViewController.h"
#import "MLZTTableViewCell.h"
#import "MLTisTableViewCell.h"
#import "MLAddTableViewCell.h"
#import "MLRPayTableViewCell.h"
#import "MLZTextTableViewCell.h"
#import "HFSConstants.h"
#import "masonry.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLMoreTableViewCell.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLPersonOrderDetailFootView.h"
#import "MLPersonOrderDetail.h"
#import "HFSServiceClient.h"
#import "MJExtension.h"
#import "MLPersonOrderModel.h"
#import "MBProgressHUD+Add.h"
#import "MLOrderComViewController.h"
#import "MLReturnRequestViewController.h"
#import "MLHttpManager.h"
#import "MLLogisticsViewController.h"
#import "MLPayViewController.h"

@interface MLPersonOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLPersonOrderDetailFootView *footView;

@property (nonatomic,strong)MLPersonOrderDetail *orderDetail;




@end

@implementation MLPersonOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    _tableView = ({
        UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"MLZTTableViewCell" bundle:nil] forCellReuseIdentifier:kZTTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLAddTableViewCell" bundle:nil] forCellReuseIdentifier:kAddTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLTisTableViewCell" bundle:nil] forCellReuseIdentifier:kTisTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLRPayTableViewCell" bundle:nil] forCellReuseIdentifier:kRPayTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLZTextTableViewCell" bundle:nil] forCellReuseIdentifier:kZTextTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    
    _footView = ({
        MLPersonOrderDetailFootView *footView = [MLPersonOrderDetailFootView detailFooterView];
        
        __weak typeof(self) weakself = self;
        footView.orderDetailButtonActionBlock = ^(ButtonActionType actionType){
            switch (actionType) {
                case ButtonActionTypeShanchu://订单删除操作
                {
                    [weakself OrderActionWithButtonType:actionType];
                }
                    break;
                case ButtonActionTypeFukuan://付款  去付款操作
                {
                    MLPayViewController *vc = [[MLPayViewController alloc]init];
                    vc.order_id = self.order_id;
                    vc.order_sum = self.order_price;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case ButtonActionTypeQuxiao://订单取消
                {
                     [weakself OrderActionWithButtonType:actionType];
                }
                    break;
                case ButtonActionTypeZhuizong://订单追踪
                {
                    MLLogisticsViewController *vc = [[MLLogisticsViewController alloc]init];
                    vc.express_number = self.orderDetail.deliver_code;
                    vc.express_company = self.orderDetail.deliver_name;
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
                case ButtonActionTypeQuerenshouhuo://确认收货
                {
                     [weakself OrderActionWithButtonType:actionType];
                }
                    break;
                case ButtonActionTypePingJia://评价
                {
                    if (weakself.orderDetail.seller_comment == 0) { //判断是否评价
                        MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                        vc.order_id = weakself.orderDetail.order_id;
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:vc animated:YES];
                    }else{
                        [MBProgressHUD showMessag:@"订单已评价" toView:self.view];
                    }
                }
                    break;
                case ButtonActionTypeTuiHuo://退货
                {
                    MLReturnRequestViewController *vc = [[MLReturnRequestViewController alloc]init];
                    vc.order_id =weakself.order_id;
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
        };
        [self.view addSubview:footView];
        footView;
    });
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
 
    [self getOrderDetail];
}

- (void)getOrderDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=detail&order_id=%@",MATROJP_BASE_URL,self.order_id?:@""];
    [MLHttpManager get:url params:nil m:@"product" s:@"admin_buyorder" success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = [result objectForKey:@"data"];
            NSDictionary *detail = data[@"detail"];
            self.orderDetail = [MLPersonOrderDetail mj_objectWithKeyValues:detail];
            switch (self.orderDetail.status) {
                case OrderStatusYishanchu: //已删除
                {
                    self.footView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.view);
                    }];
                }
                    break;
                    
                case OrderStatusDaifukuan:  //启用倒计时  //待付款
                {
                    self.footView.footerType = FooterTypeDaifukuan;
                    NSDate *now = [NSDate new];
                    NSDate *since = [NSDate dateWithTimeIntervalSince1970:self.orderDetail.creat_time];
                    [self compareDate:since currentDate:now];
                }
                    break;
                case OrderStatusDaifahuo:  //待发货
                {
                    self.footView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.view);
                    }];
                }
                    break;
                case OrderStatusDaiqueren:  //待确认
                {
                    self.footView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.view);
                    }];
                }
                    break;
                case OrderStatusWancheng:  //已完成
                {
                    
                    self.footView.footerType = FooterTypeJiaoyichenggong;
                    if (self.orderDetail.buyer_comment == 0) {
                        [self.footView.payBtn setTitle:@"评价" forState:UIControlStateNormal];
                    }else{
                        [self.footView.payBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                    }
                }
                    break;
                case OrderStatusQuxiao:   //取消
                {
                    self.footView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.view);
                    }];
                    
                }
                    break;
                case OrderStatusTuihuozhong:
                {
                    self.footView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.view);
                    }];
                }
                    break;
                case OrderStatusTuihuochenggong:
                {
                    self.footView.hidden = YES;
                    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.view);
                    }];
                }
                    break;
                    
                default:
                    self.footView.footerType = FooterTypeQitazhuangtai;
                    break;
            }
            
            [self.tableView reloadData];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        

    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


/**
 *  订单操作，删除，取消，确认收货
 *
 *  @param actionType
 */
- (void)OrderActionWithButtonType:(ButtonActionType)actionType{
    
    NSString *action = nil;
    
    if (actionType == ButtonActionTypeShanchu) {
        action = @"delete";
        
    }else if (actionType == ButtonActionTypeQuxiao){
        action = @"cancel";
    }else if (actionType == ButtonActionTypeQuerenshouhuo)
    {
        action = @"confirm";
    }else{
        action = @"";
    }
    
    NSString *url= [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=%@&order_id=%@",MATROJP_BASE_URL,action,self.orderDetail.order_id];
    [MLHttpManager get:url params:nil m:@"product" s:@"admin_buyorder" success:^(id responseObject) {
         NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //操作成功
            [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
            
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
    
    
}




#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else if (section == 1 || section == 2){
        return 1;
    }
    else if (section == 3){
        return self.orderDetail.product.count+1;
    }
    else if (section == 4){
        return 2;
    }
    else if (section == 5){
        if (self.orderDetail.invoice == 0) {
            return 1;
        }
        return 3;
    }else if (section == 6){
        return 5;
    }else if (section == 7){
        return 1;
    }
    return 0;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { //ZTTableViewCell
        MLZTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZTTableViewCell forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"订单编号：";
            cell.ztLabel.text = self.orderDetail.order_id;
            
        }
        else{
            cell.titleLabel.text = @"订单状态：";
            cell.ztLabel.text = self.orderDetail.statu_text;
            
        }
        return cell;
        
    }
    else if (indexPath.section == 1){
        MLTisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTisTableViewCell forIndexPath:indexPath];
        cell.tisLabel.text = @"订单已通过审核，仓库配送中.....";
        if (self.orderDetail.deliver_time) {
            NSDate *time = [NSDate dateWithTimeIntervalSince1970:[self.orderDetail.deliver_time floatValue]];
            NSDateFormatter *fm = [[NSDateFormatter alloc]init];
            [fm setDateFormat:@"yyy-MM-dd HH:mm"];
            cell.timeLabel.text = [fm stringFromDate:time];
        }
        if (!(self.orderDetail.deliver_name && self.orderDetail.deliver_code)) {
            cell.hidden = YES;
        }
        return cell;
    }
    else if (indexPath.section == 2){
        MLAddTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:kAddTableViewCell forIndexPath:indexPath];
        cell.nameLabel.text = self.orderDetail.buyer_name;
        cell.phoneLabel.text = self.orderDetail.buyer_mobile;
        cell.addressLabel.text = self.orderDetail.buyer_addr;
        return cell;
    }else if (indexPath.section == 3){ //商品列表
        if (indexPath.row == 0) { //头部
            MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
            cell.shopName.text = self.orderDetail.sellerinfo.company;
            cell.statusLabel.hidden = YES;

            return cell;
        }
        else{
            MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            MLPersonOrderProduct *model = [self.orderDetail.product objectAtIndex:indexPath.row-1];
            cell.productOrder = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }

    }else if (indexPath.section == 4){
        MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"支付方式";
            cell.subLabel.text = @"在线支付";
        }
        else{
            cell.titleLabel.text = @"配送方式";
            cell.subLabel.text = self.orderDetail.logistics_type;
        }
        return cell;
    }else if (indexPath.section == 5){
        if (self.orderDetail.invoice == 0) {
            MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
            cell.titleLabel.text = @"发票信息";
            cell.subLabel.text = @"不开发票";
            return cell;
        }
        else{
            MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
              cell.subLabel.hidden = YES;
            if (indexPath.row == 0) { //
                cell.titleLabel.text = @"发票信息";
            }else if (indexPath.row == 1){
                cell.titleLabel.text = [NSString stringWithFormat:@"抬头：%@",self.orderDetail.invinfo.rise];
                cell.titleLabel.textColor = RGBA(153, 153,153, 1);

            }else{
                cell.titleLabel.text = [NSString stringWithFormat:@"内容：%@",self.orderDetail.invinfo.content];
                cell.titleLabel.textColor = RGBA(153, 153,153, 1);
                
            }

            return cell;
        }

    }
    else if (indexPath.section == 6){
        if (indexPath.row <4) {
            MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLabel.text = @"商品总额：";
                    cell.subLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderDetail.product_price];
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);

                }
                    break;
                case 1:
                {
                    cell.titleLabel.text = @"优    惠：";
                    cell.subLabel.text = [NSString stringWithFormat:@"-￥%.2f",_orderDetail.discount_price];
                    cell.subLabel.textColor = [UIColor blackColor];
                }
                    break;
                case 2:
                {
                    cell.titleLabel.text = @"税    费：";
                    cell.subLabel.text = [NSString stringWithFormat:@"+￥%.2f",_orderDetail.tax_price];
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);

                }
                    break;
                case 3:
                {
                    cell.titleLabel.text = @"运    费：";
                    cell.subLabel.text = [NSString stringWithFormat:@"+￥%.2f",_orderDetail.logistics_price];
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
        MLRPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRPayTableViewCell forIndexPath:indexPath];
        cell.rpayLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderDetail.order_price];
        cell.rpayLabel.textColor = RGBA(255, 78, 37, 1);
        return cell;
    }else if (indexPath.section == 7){
        MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
        cell.titleLabel.text = @"下单时间";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_orderDetail.creat_time];
        NSDateFormatter *fm = [[NSDateFormatter alloc]init];
        [fm setDateFormat:@"YYY-MM-dd hh:mm:ss"];
        
        cell.subLabel.text = [fm stringFromDate:date];
        return cell;
        
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 35;
    }else if (indexPath.section == 1){
        if (self.orderDetail.deliver_name && self.orderDetail.deliver_code) {
            return 60;
        }
        return 0;
    }else if (indexPath.section == 2){
        return 88;
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 44;
        }
        return 134;
    }
    else if (indexPath.section == 4){
        if (indexPath.row<2) {
            return 44;
        }
        return 25;
    }else if (indexPath.section == 5){
        if (self.orderDetail.invinfo == 0) {
            return 44;
        }
        return 30;
    }else if (indexPath.section == 6){
        if (indexPath.row < 4) {
            return 30;
        }
        return 50;
    }else if (indexPath.section == 7){
        return 44;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 && !(self.orderDetail.deliver_code && self.orderDetail.deliver_name)) {
        return 0;
    }
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        MLLogisticsViewController *vc = [[MLLogisticsViewController alloc]init];
        vc.express_number = self.orderDetail.deliver_code;
        vc.express_company = self.orderDetail.deliver_name;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)compareDate:(NSDate*)startdate currentDate:(NSDate*)endDate
{
    float restm =  [endDate timeIntervalSinceDate:startdate ];
    if (restm/60/60>2) { //小时   如果倒计时超过2小时 不显示倒计时
        self.footView.daojishiLb.hidden = YES;
        self.footView.shenyuLb.hidden = YES;
        self.footView.payBtn.backgroundColor = [UIColor grayColor];
        self.footView.payBtn.enabled = NO;
    }
    else{
        restm = 60*60*2-restm;
        [self startTime:restm];
    }
}


-(void)startTime:(float)resttime{
    __block int timeout=resttime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.footView.payBtn.enabled = NO;
                [self.footView.payBtn setBackgroundColor:[UIColor grayColor]];
            });
        }else{
            //format of hour
            NSString *str_hour = [NSString stringWithFormat:@"%02d",timeout/3600];
            //format of minute
            NSString *str_minute = [NSString stringWithFormat:@"%02d",(timeout%3600)/60];
            //format of second
            NSString *str_second = [NSString stringWithFormat:@"%02d",timeout%60];
            //format of time
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                self.footView.daojishiLb.text = format_time;
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}







@end

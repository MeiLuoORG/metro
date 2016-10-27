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
#import "Masonry.h"
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
#import "MLPersonAlertViewController.h"
#import "MLLogisticsModel.h"
#import "MLGoodsDetailsViewController.h"
#import "MLMoreTableViewCell.h"
#import "MLLoginViewController.h"



@interface MLPersonOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    MLLogisticsModel *logisticModel;
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLPersonOrderDetailFootView *footView;

@property (nonatomic,strong)MLPersonOrderDetail *orderDetail;

@property (nonatomic,strong)NSMutableArray *logisticsArray;

@end

@implementation MLPersonOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        
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
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定删除订单？" AndAlertDoneAction:^{
                       [weakself OrderActionWithButtonType:actionType];
                    }];
                    [weakself showTransparentController:vc];
                }
                    break;
                case ButtonActionTypeFukuan://付款  去付款操作
                {
                    MLPayViewController *vc = [[MLPayViewController alloc]init];
                    vc.order_id = self.order_id;
                    vc.order_sum = self.orderDetail.order_price;
                    vc.isGlobal = (self.orderDetail.way == 2);
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case ButtonActionTypeQuxiao://订单取消
                {
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定取消订单？" AndAlertDoneAction:^{
                      [weakself OrderActionWithButtonType:actionType];
                    }];
                    [weakself showTransparentController:vc];
                    
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
                    
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定确认收货？" AndAlertDoneAction:^{
                        [weakself OrderActionWithButtonType:actionType];
                    }];
                    [weakself showTransparentController:vc];
                   
                }
                    break;
                case ButtonActionTypePingJia://评价
                {
                    if (weakself.orderDetail.seller_comment == 0) { //判断是否评价
                        MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                        vc.order_id = weakself.orderDetail.order_id;
                        vc.pingjiachenggong = ^(){
                            [weakself getOrderDetail];
                        };
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
                case ButtonActionTypeTuiKuan://退款
                {
                    
                    if (self.orderDetail.way == 2) { //跨境购
                        [MBProgressHUD showMessag:@"跨境购商品不支持退款" toView:self.view];
                    }else{
                        MLReturnRequestViewController *vc = [[MLReturnRequestViewController alloc]init];
                        vc.order_id =weakself.order_id;
                        [weakself.navigationController pushViewController:vc animated:YES];
                    }
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
    self.titleLoadFinished = NO;
    
    
    //检测网络环境
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    [self checkNetworkState];
    
    //[self getOrderDetail];
}
//检测网络状态
- (void)networkStateChange{
    [self checkNetworkState];
    
}

- (void)checkNetworkState
{
    // 1.检测wifi状态
    //Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        //self.wangluoImageView.hidden = YES;
        //[conn currentReachabilityStatus]  == reachable
        if ([conn currentReachabilityStatus] == ReachableViaWiFi) {
            NSLog(@"使用WIFI网络进行上网");
        }
        if ([conn currentReachabilityStatus] == ReachableViaWWAN) {
            NSLog(@"使用手机自带网络进行上网");
        }
        
        if (self.titleLoadFinished == NO) {
            [self getOrderDetail];
            NSLog(@"执行了测试方法getRequestTitleARR");
        }
        
    }else { // 没有网络

        //self.wangluoImageView inser
        //[self.view insertSubview:self.wangluoImageView atIndex:0];
        /*
         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"网络不顺畅，请检查网络！" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
         [self.view addSubview:alert];
         [alert show];
         */
    }
    
    
}


// 用WIFI
// [wifi currentReachabilityStatus] != NotReachable
// [conn currentReachabilityStatus] != NotReachable

// 没有用WIFI, 只用了手机网络
// [wifi currentReachabilityStatus] == NotReachable
// [conn currentReachabilityStatus] != NotReachable

// 没有网络
// [wifi currentReachabilityStatus] == NotReachable
// [conn currentReachabilityStatus] == NotReachable

- (void)dealloc{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)getOrderDetail{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=detail&order_id=%@",MATROJP_BASE_URL,self.order_id?:@""];
    [MLHttpManager get:url params:nil m:@"product" s:@"admin_buyorder" success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self closeLoadingView];
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
//                    NSDate *now = [NSDate new];
//                    NSDate *since = [NSDate dateWithTimeIntervalSince1970:self.orderDetail.creat_time];
                    [self startCountdown];
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
                    self.footView.footerType = FooterTypeDaiQueren;  
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
                    self.footView.footerType = FooterTypeQuxiao;
                    
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
            
            if (self.orderDetail.deliver_code.length > 0 && self.orderDetail.deliver_name.length > 0) {
                [self downLoadLogTrackWithCompany:self.orderDetail.deliver_name AndNum:self.orderDetail.deliver_code];
            }
            self.titleLoadFinished = YES;
        }else if ([result[@"code"]isEqual:@1002]){
        
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self loginAction:nil];
        } else{
            self.titleLoadFinished = NO;
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
        }
        [self closeLoadingView];
    } failure:^(NSError *error) {
        self.titleLoadFinished = NO;
        [self closeLoadingView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        if ([result[@"code"] isEqual:@0]) { //操作成功  重新获取信息
            if (self.orderHandleBlock) {
                self.orderHandleBlock();
            }
            [self getOrderDetail];
        }else if ([result[@"code"]isEqual:@1002]){
            
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self loginAction:nil];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
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
        if (self.orderDetail.isMore && !self.orderDetail.isOpen) {
            return 4;
        }
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
        return 6;
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
        if (logisticModel) { //如果有第一条记录
            cell.tisLabel.text = logisticModel.context;
            cell.timeLabel.text = logisticModel.time;
            cell.contentView.hidden = !(self.orderDetail.deliver_name.length>0 && self.orderDetail.deliver_code.length > 0);
            
        }
        else{
            cell.tisLabel.text = @"订单已通过审核，仓库配送中.....";
            NSDate *time = [NSDate dateWithTimeIntervalSince1970:self.orderDetail.deliver_time];
            NSDateFormatter *fm = [[NSDateFormatter alloc]init];
            [fm setDateFormat:@"yyy-MM-dd HH:mm"];
            cell.timeLabel.text = [fm stringFromDate:time];
            cell.contentView.hidden = !(self.orderDetail.deliver_name.length>0 && self.orderDetail.deliver_code.length > 0);
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
        }else if(self.orderDetail.isMore && !self.orderDetail.isOpen && indexPath.row == 3) //有更多的情况
        {
            MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
            
            [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%lu件",self.orderDetail.product.count - 2] forState:UIControlStateNormal];
            cell.moreActionBlock = ^(){
                self.orderDetail.isOpen = YES;
                [self.tableView reloadData];
            };
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
            cell.subLabel.text = self.orderDetail.payment_name?:@"在线支付";
        }
        else{
            cell.titleLabel.text = @"配送方式";
            if (self.orderDetail.logistics_type.length > 2) {
                cell.subLabel.text = self.orderDetail.logistics_type;
            }
            else{
                cell.subLabel.text = @"快递配送";
            }
            
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
            cell.contentView.hidden = NO;
            return cell;
        }
    }
    else if (indexPath.section == 6){
        if (indexPath.row <5) {
            MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                {
                    cell.contentView.hidden = NO;
                    cell.titleLabel.text = @"商品总额：";
                    cell.subLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderDetail.product_price];
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);

                }
                    break;
                case 1:
                {
                    cell.titleLabel.text = @"优    惠：";
                    cell.subLabel.text = [NSString stringWithFormat:@"-￥%.2f",_orderDetail.b2cyhq];
                    cell.subLabel.textColor = [UIColor blackColor];
                    cell.contentView.hidden = (self.orderDetail.b2cyhq == 0) ;
                }
                    break;
                case 2:
                {
                    cell.titleLabel.text = @"满    减：";
                    cell.subLabel.text = [NSString stringWithFormat:@"-￥%.2f",_orderDetail.discount_price];
                    
                    cell.contentView.hidden = (self.orderDetail.discount_price == 0);
                    
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);

                    
                }
                    break;
                case 3:
                {
                    cell.titleLabel.text = @"税    费：";
                    cell.subLabel.text = [NSString stringWithFormat:@"+￥%.2f",_orderDetail.tax_price];
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);
                    cell.contentView.hidden = (self.orderDetail.way != 2);
                }
                    break;
                case 4:
                {
                    cell.titleLabel.text = @"运    费：";
                    cell.contentView.hidden = NO;
                    
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
        if (self.orderDetail.deliver_name.length > 0 && self.orderDetail.deliver_code.length > 0 ) {
            return 60;
        }
        return 0;
    }else if (indexPath.section == 2){
        return 88;
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 44;
        }else if (self.orderDetail.isMore && !self.orderDetail.isOpen && indexPath.row == 3){
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
        if (indexPath.row < 6) {
            if (indexPath.row == 1 && self.orderDetail.b2cyhq == 0) {
                return 0;
            }
            if (indexPath.row == 2 && self.orderDetail.discount_price == 0) {
                return 0;
                
            }
            if ((indexPath.row == 3 && self.orderDetail.way != 2)) {
                return 0;
            }
            
            return 30;
        }
        return 50;
    }else if (indexPath.section == 7){
        return 44;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 && !(self.orderDetail.deliver_code.length > 0 && self.orderDetail.deliver_name.length > 0)) {
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
    else if (indexPath.section == 3 && indexPath.row > 0){
        MLPersonOrderProduct *model = [self.orderDetail.product objectAtIndex:indexPath.row-1];
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
        NSDictionary *params = @{@"id":model.pid?:@"",@"userid":self.orderDetail.sellerinfo.userid?:@""};
        vc.paramDic = params;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



-(void)startCountdown{
    if (self.orderDetail.remainder/60/60 > 24 || self.orderDetail.remainder <= 0) { //小时   如果倒计时超过2小时 不显示倒计时
        self.footView.daojishiLb.hidden = YES;
        self.footView.shenyuLb.hidden = YES;
        [self.footView.payBtn setTitle:@"订单已超时" forState:UIControlStateNormal];
        self.footView.payBtn.backgroundColor = [UIColor grayColor];
        self.footView.payBtn.enabled = NO;
    }
    else{
        [self startTime:self.orderDetail.remainder];
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
                self.footView.daojishiLb.hidden = YES;
                self.footView.shenyuLb.hidden = YES;
                self.footView.payBtn.enabled = NO;
                [self.footView.payBtn setTitle:@"订单已超时" forState:UIControlStateNormal];
                
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



- (void)downLoadLogTrackWithCompany:(NSString *)company AndNum:(NSString *)num{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=getkd",MATROJP_BASE_URL];
    NSDictionary *params = @{@"express_company":company?:@"",@"express_number":num?:@""};
    [MLHttpManager post:url params:params m:@"member" s:@"getkd" success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //下载记录  如果有记录就显示第一条
            NSDictionary *data = result[@"data"];
            NSArray *time_line = data[@"timeline"];
            [self.logisticsArray addObjectsFromArray:[MLLogisticsModel mj_objectArrayWithKeyValuesArray:time_line]];
            if (self.logisticsArray.count > 0) {
                logisticModel = [self.logisticsArray firstObject];
                [self.tableView reloadData];
            }
        }else if ([result[@"code"]isEqual:@1002]){
            
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self loginAction:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self closeLoadingView];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}
- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (NSMutableArray *)logisticsArray{
    if (!_logisticsArray) {
        _logisticsArray = [NSMutableArray array];
    }
    return _logisticsArray;
}



@end

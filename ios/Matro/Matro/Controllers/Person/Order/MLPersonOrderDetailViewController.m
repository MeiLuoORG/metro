//
//  MLPersonDetailViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/17.
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
                    
                }
                    break;
                case ButtonActionTypeQuxiao://订单取消
                {
                     [weakself OrderActionWithButtonType:actionType];
                }
                    break;
                case ButtonActionTypeZhuizong://订单追踪
                {
                    
                }
                    break;
                case ButtonActionTypeQuerenshouhuo://确认收货
                {
                     [weakself OrderActionWithButtonType:actionType];
                }
                    break;
                case ButtonActionTypePingJia://评价
                {
                    MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                    weakself.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case ButtonActionTypeTuiHuo://退货
                {
                    
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
        make.height.mas_equalTo(40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
 
    [self getOrderDetail];
}

- (void)getOrderDetail{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=detail&order_id=201605231036169565",@"http://bbctest.matrojp.com"];
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = [result objectForKey:@"data"];
            NSDictionary *detail = data[@"detail"];
            self.orderDetail = [MLPersonOrderDetail mj_objectWithKeyValues:detail];
            
            switch (self.orderDetail.status) {
                case OrderStatusYishanchu:
                {
                    self.footView.footerType = FooterTypeJiaoyiguanbi;
                }
                    break;

                case OrderStatusDaifukuan:
                {
                    self.footView.footerType = FooterTypeDaifukuan;
                }
                    break;
                case OrderStatusDaifahuo:
                {
                    self.footView.footerType = FooterTypeDaifahuo;
                }
                    break;
//                case OrderStatusDaiqueren:
//                {
//                    
//                }
//                    break;
                case OrderStatusWancheng:
                {
                    self.footView.footerType = FooterTypeJiaoyichenggong;
                }
                    break;
//                case OrderStatusTuihuozhong:
//                {
//                    
//                }
//                    break;
//                case OrderStatusTuihuochenggong:
//                {
//                    
//                }
//                    break;
//                    
                    
                default:
                    self.footView.footerType = FooterTypeQitazhuangtai;
                    break;
            }
            _footView.footerType = FooterTypeJiaoyichenggong;
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
    
    NSString *url= [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=product&s=admin_buyorder&action=%@&order_id=%@",action,self.orderDetail.order_id];
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //操作成功
            [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
        return 3;
    }
    else if (section == 5){
        return 2;
    }else if (section == 6){
        return 5;
    }
    return 0;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
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

        cell.timeLabel.hidden = YES;
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
            cell.subLabel.text = self.orderDetail.payment_name;
        }
        else{
            cell.titleLabel.text = @"配送方式";
            cell.subLabel.text = self.orderDetail.logistics_type;
        }
        return cell;
    }else if (indexPath.section == 5){
        MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
        cell.titleLabel.text = @"发票信息";
        cell.subLabel.text = @"不开发票";
        return cell;
    }
    else if (indexPath.section == 6){
        if (indexPath.row <4) {
            MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLabel.text = @"商品总额：";
                    cell.subLabel.text = @"￥1233.00";
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
        cell.rpayLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderDetail.product_price];
        cell.rpayLabel.textColor = RGBA(255, 78, 37, 1);
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }else if (indexPath.section == 1){
        return 80;
    }else if (indexPath.section == 2){
        return 120;
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 40;
        }
        return 134;
    }
    else if (indexPath.section == 4){
        return 40;
    }else if (indexPath.section == 5){
        return 44;
    }
    else if (indexPath.section == 6){
        if (indexPath.row < 4) {
            return 30;
        }
        return 50;
    }
    return 0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}









@end

//
//  MLPersonOrderListViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonOrderListViewController.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLOrderInfoFooterTableViewCell.h"
#import "HFSConstants.h"
#import "MLMoreTableViewCell.h"
#import "masonry.h"
#import "UIView+BlankPage.h"
#import "MLPersonOrderModel.h"
#import "MJExtension.h"
#import "HFSServiceClient.h"
#import "MJRefresh.h"
#import "MLPersonOrderDetailViewController.h"
#import "MLPersonAlertViewController.h"
#import "MBProgressHUD+add.h"
#import "MLOrderComViewController.h"
#import "MLReturnRequestViewController.h"
#import "MLLogisticsViewController.h"
#import "HFSConstants.h"
#import "MLHttpManager.h"
#import "MLReturnRequestViewController.h"
#import "MLPayViewController.h"
#import "MLReturnsDetailViewController.h"
#import "MLLoginViewController.h"



typedef NS_ENUM(NSInteger,OrderActionType){
    OrderActionTypeDel,
    OrderActionTypeCancel,
    OrderActionTypeconfirm,
};

typedef NS_ENUM(NSInteger,ButtonActionType){
    ButtonActionTypeShanchu,
    ButtonActionTypeFukuan,
    ButtonActionTypeQuxiao,
    ButtonActionTypeZhuizong,
    ButtonActionTypeQuerenshouhuo,
    ButtonActionTypePingJia,
    ButtonActionTypeTuiHuo
};

@interface MLPersonOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger pageIndex;
}
@property (nonatomic,assign)OrderType type;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;


@end


@implementation MLPersonOrderListViewController


- (instancetype)initWithOrderType:(OrderType)orderType{
    if (self = [super init]) {
        self.type = orderType;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.title isEqualToString:@"全部"]) {
        self.type = OrderType_All;
    }else if ([self.title isEqualToString:@"待付款"]){
        self.type = OrderType_Fukuan;
    }else if ([self.title isEqualToString:@"待收货"]){
        self.type = OrderType_Shouhuo;
    }else if([self.title isEqualToString:@"待评价"]){
        self.type = OrderType_Pingjia;
    }
    switch (self.type) {
        case OrderType_All:
            self.title = @"全部订单";
            break;
        case OrderType_Fukuan:
            self.title = @"待付款订单";
            break;
        case OrderType_Shouhuo:
            self.title = @"待收货订单";
            break;
        case OrderType_Pingjia:
            self.title = @"待评价订单";
            break;
        default:
            break;
    }
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoFooterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoFooterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [self getOrderList];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getOrderList];
    }];
    
    pageIndex = 1;
    [self getOrderList];
    [self.view configBlankPage:EaseBlankPageTypeDingdan hasData:(self.orderList.count>0)];
    __weak typeof(self)weakself = self;
    self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
        [weakself.tabBarController setSelectedIndex:0];
        [weakself.navigationController popToRootViewControllerAnimated:NO];
        
    };
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MLPersonOrderModel *order = [self.orderList objectAtIndex:section];
    if (order.isMore && !order.isOpen) {//如果超过两个的情况
        return 5;
    }
    return order.product.count+2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLPersonOrderModel *order = [self.orderList objectAtIndex:indexPath.section];
    __weak typeof(self) weakself = self;
    if (indexPath.row == 0) {
        MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
        cell.orderList = order;
        return cell;
    }
    
    if (order.isMore && !order.isOpen && indexPath.row == 3) { // 有更多
        MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
        [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%lu件",order.product.count - 2] forState:UIControlStateNormal];
        cell.moreActionBlock = ^(){
            order.isOpen = YES;
            [weakself.tableView reloadData];
        };
        return cell;
    }
    
    if ((order.isMore && order.isOpen && indexPath.row == order.product.count+1 )||(order.isMore && indexPath.row == 4 && !order.isOpen) ||(!order.isMore && indexPath.row == order.product.count+1) ) {
        MLOrderInfoFooterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoFooterTableViewCell forIndexPath:indexPath];
        cell.orderList = order;
        cell.cancelAction = ^(){ //取消操作
            MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定取消此订单？" AndAlertDoneAction:^{
                [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.order_id];
            }];
            [weakself showTransparentController:vc];
        };
        
        cell.shanchuAction =^(){//删除订单操作
            MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定删除此订单？" AndAlertDoneAction:^{
                [weakself OrderActionWithButtonType:ButtonActionTypeShanchu AndOrder:order.order_id];
            }];
            [weakself showTransparentController:vc];
        };
        
        cell.shouHuoAction = ^(){//确认收货操作
            MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定确认收货？" AndAlertDoneAction:^{
                [weakself OrderActionWithButtonType:ButtonActionTypeQuerenshouhuo AndOrder:order.order_id];
            }];
            [weakself showTransparentController:vc];
        };
        cell.pingJiaAction = ^(){//评价  调到评价页面
            MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
            vc.order_id = order.order_id;
            vc.pingjiachenggong = ^(){
                [weakself.tableView.header beginRefreshing];
            };
            [weakself.navigationController pushViewController: vc animated:YES];
        };
        cell.kanPingJiaAction= ^(){//查看订单评价  跳到查看订单评价页面
            MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
            vc.order_id = order.order_id;
            [weakself.navigationController pushViewController: vc animated:YES];
        };
        cell.zhuiZongAction = ^(){//订单追踪  跳到订单追踪页面
            MLLogisticsViewController *vc = [[MLLogisticsViewController alloc]init];
            vc.express_number = order.deliver_code;
            vc.express_company = order.deliver_name;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        cell.tuiHuoAction = ^(){//退货操作
            MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定退货？" AndAlertDoneAction:^{
                MLReturnRequestViewController *vc = [[MLReturnRequestViewController alloc]init];
                vc.order_id = order.order_id;
                [weakself.navigationController pushViewController:vc animated:YES];
            }];
            [weakself showTransparentController:vc];
        };
        cell.fuKuanAction = ^(){//跳到付款 页面
            if (order.canPay) {
                MLPayViewController *vc = [[MLPayViewController alloc]init];
                vc.order_id = order.order_id;
                vc.order_sum = order.order_price;
                vc.isGlobal = (order.way == 2);
                [weakself.navigationController pushViewController:vc animated:YES];
            }else{
                [MBProgressHUD showMessag:@"订单已过期，请重新下单!" toView:self.view];
            }
           
        };
        cell.leftKanTuiHuo = ^(){
            MLReturnsDetailViewController *vc = [[MLReturnsDetailViewController alloc]init];
            vc.order_id = order.order_id;
            vc.cancelSuccess = ^(){
                [weakself.tableView.header beginRefreshing];
            };
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }
    
    MLOrderCenterTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
    MLPersonOrderProduct *product = [order.product objectAtIndex:indexPath.row-1];
    cell.productOrder = product;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLPersonOrderModel *order = [self.orderList objectAtIndex:indexPath.section];
    if ((order.isMore && !order.isOpen && indexPath.row == 3 )|| (indexPath.row == 0) || (order.isMore && order.isOpen && indexPath.row == order.product.count+1 )||(order.isMore && indexPath.row == 4 && !order.isOpen) ||(!order.isMore && indexPath.row == order.product.count+1)) { // 有更多
        return 40;
    }
    return 134;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MLPersonOrderModel *order = [self.orderList objectAtIndex:indexPath.section];
    MLPersonOrderDetailViewController *vc = [[MLPersonOrderDetailViewController alloc]init];
    vc.orderHandleBlock = ^(){
        pageIndex = 1;
        [self.tableView.header beginRefreshing];
    };
    vc.order_id = order.order_id;
    vc.order_price = order.order_price;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark 获取数据

- (void)getOrderList{

    NSString *url;
    switch (self.type) {
        case OrderType_All:
        {
            url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8",MATROJP_BASE_URL,[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        case OrderType_Fukuan:
        {
             url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8&status=1",MATROJP_BASE_URL,[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        case OrderType_Pingjia:
        {
             url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8&status=4&buyer_comment=0",MATROJP_BASE_URL,[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        case OrderType_Shouhuo:
        {
             url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8&status=3",MATROJP_BASE_URL,[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        default:
            break;
    }
    
    [MLHttpManager get:url params:nil m:@"product" s:@"admin_buyorder" success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSDictionary *order_list = data[@"order_list"];
            if (order_list &&[order_list isKindOfClass:[NSDictionary class]])
            {
                NSArray *list = order_list[@"list"];
                if (pageIndex == 1) {
                    [self.orderList removeAllObjects];
                }
                NSString *count = order_list[@"total"];
                if (list.count>0 && self.orderList.count < [count integerValue]) {
                    [self.orderList addObjectsFromArray:[MLPersonOrderModel mj_objectArrayWithKeyValuesArray:list]];
                    pageIndex ++;
                   
                }
                else{
                    [MBProgressHUD showMessag:@"暂无更多数据" toView:self.view];
                }
            }else{
                if (pageIndex == 1) {
                    [self.orderList removeAllObjects];
                }
            }
             [self.tableView reloadData];
        }else if ([result[@"code"]isEqual:@1002]){
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
        
        } else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
        
        [self.view configBlankPage:EaseBlankPageTypeDingdan hasData:(self.orderList.count>0)];
    } failure:^(NSError *error) {
          [self.tableView.footer endRefreshing];
         [self.tableView.header endRefreshing];
         [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}




- (NSMutableArray *)orderList{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}


/**
 *  订单操作，删除，取消，确认收货
 *
 *  @param actionType
 */
- (void)OrderActionWithButtonType:(ButtonActionType)actionType AndOrder:(NSString *)order_id{
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
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSString *url= [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=%@&order_id=%@",MATROJP_BASE_URL,action,order_id];
    [MLHttpManager get:url params:nil m:@"product" s:@"admin_buyorder" success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //操作成功
          [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
          [self.tableView.header beginRefreshing];
        }else if ([result[@"code"]isEqual:@1002]){
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
            
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
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



@end

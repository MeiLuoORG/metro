//
//  MLPersonOrderListViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
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

@interface MLPersonOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)OrderType type;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;


@end

static NSInteger pageIndex = 0;

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
        pageIndex = 0;
        [self getOrderList];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getOrderList];
    }];
    [self.tableView.header beginRefreshing];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MLPersonOrderModel *order = [self.orderList objectAtIndex:section];
    if (order.isMore) {//如果超过两个的情况
        return order.isOpen?order.product.count+3:5;
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
    
    if (order.isMore) {
        if (order.isOpen) {//展开的情况
            if (indexPath.row == order.product.count+1) { //倒数第二行
                MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
                return cell;
            }
            else if (indexPath.row == order.product.count+2){//最后一行
                MLOrderInfoFooterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoFooterTableViewCell forIndexPath:indexPath];
                cell.orderList = order;
                cell.cancelAction = ^(){ //取消操作
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定取消此订单吗？" AndAlertDoneAction:^{
                        [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.order_id];
                    }];
                    [weakself showTransparentController:vc];
                };
                cell.shouHuoAction = ^(){//确认收货操作
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定确认收货吗？" AndAlertDoneAction:^{
                        [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.order_id];
                    }];
                    [weakself showTransparentController:vc];
                };
                cell.pingJiaAction = ^(){//评价  调到评价页面
                    MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                    vc.order_id = order.order_id;
                    [weakself.navigationController pushViewController: vc animated:YES];
                    
                    
                };
                cell.kanPingJiaAction= ^(){//查看订单评价  跳到查看订单评价页面
                    MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                    vc.order_id = order.order_id;
                    [weakself.navigationController pushViewController: vc animated:YES];
                };
                cell.zhuiZongAction = ^(){//订单追踪  跳到订单追踪页面
                    
                };
                cell.tuiHuoAction = ^(){//退货操作
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定退货吗？" AndAlertDoneAction:^{
                        [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.order_id];
                    }];
                    [weakself showTransparentController:vc];
                };
                cell.fuKuanAction = ^(){//跳到付款 页面
                    
                };

                return cell;
            }
            else{
                MLOrderCenterTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
                MLPersonOrderProduct *product = [order.product objectAtIndex:indexPath.row-1];
                cell.productOrder = product;

                return cell;
            }
            
        }
        else //未展开
        {
            if (indexPath.row == 3) { //倒数第二行
                MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
                return cell;
            }else if (indexPath.row == 4){
                MLOrderInfoFooterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoFooterTableViewCell forIndexPath:indexPath];
                cell.orderList = order;
                cell.cancelAction = ^(){ //取消操作
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定取消此订单吗？" AndAlertDoneAction:^{
                        [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.ID];
                    }];
                    [weakself showTransparentController:vc];
                };
                cell.shouHuoAction = ^(){//确认收货操作
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定确认收货吗？" AndAlertDoneAction:^{
                        [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.ID];
                    }];
                    [weakself showTransparentController:vc];
                };
                cell.pingJiaAction = ^(){//评价  调到评价页面
                    MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                    vc.order_id = order.order_id;
                    [weakself.navigationController pushViewController:vc animated:YES];
                    
                };
                cell.kanPingJiaAction= ^(){//查看订单评价  跳到查看订单评价页面
                    MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                    vc.order_id = order.order_id;
                    [weakself.navigationController pushViewController:vc animated:YES];
                };
                cell.zhuiZongAction = ^(){//订单追踪  跳到订单追踪页面
                    
                };
                cell.tuiHuoAction = ^(){//退货操作
                    MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定退货吗？" AndAlertDoneAction:^{
                        [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.order_id];
                    }];
                    [weakself showTransparentController:vc];
                };
                cell.fuKuanAction = ^(){//跳到付款 页面
                    
                };
                
                return cell;
            }
            else{
                MLOrderCenterTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
                MLPersonOrderProduct *product = [order.product objectAtIndex:indexPath.row-1];
                cell.productOrder = product;
                return cell;
            }
            
        }
     
    }
    else{
        if (indexPath.row == order.product.count+1) { //倒数第二行
            MLOrderInfoFooterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoFooterTableViewCell forIndexPath:indexPath];
            cell.orderList = order;
            cell.cancelAction = ^(){ //取消操作
                MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定取消此订单吗？" AndAlertDoneAction:^{
                    [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.ID];
                }];
                [weakself showTransparentController:vc];
            };
            cell.shouHuoAction = ^(){//确认收货操作
                MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定确认收货吗？" AndAlertDoneAction:^{
                    [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.order_id];
                }];
                [weakself showTransparentController:vc];
            };
            cell.pingJiaAction = ^(){//评价  调到评价页面
                MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                vc.order_id = order.order_id;
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            cell.kanPingJiaAction= ^(){//查看订单评价  跳到查看订单评价页面
                MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
                vc.order_id = order.order_id;
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            cell.zhuiZongAction = ^(){//订单追踪  跳到订单追踪页面
                
            };
            cell.tuiHuoAction = ^(){//退货操作
                MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定退货吗？" AndAlertDoneAction:^{
                    [weakself OrderActionWithButtonType:ButtonActionTypeQuxiao AndOrder:order.order_id];
                }];
                [weakself showTransparentController:vc];
            };
            cell.fuKuanAction = ^(){//跳到付款 页面
                
            };
            return cell;
        }else{
            MLOrderCenterTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            MLPersonOrderProduct *product = [order.product objectAtIndex:indexPath.row-1];
            cell.productOrder = product;
            
            return cell;
        }
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLPersonOrderModel *order = [self.orderList objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        return 44;
    }
    if (order.isMore) {
        if (order.isOpen) {//展开的情况
            if (indexPath.row == order.product.count+1) { //倒数第二行
                return 44;
                
            }
            else if (indexPath.row == order.product.count+2){//最后一行
                return 44;
                
            }
            else{
                return 134;
                
            }
            
        }
        else //未展开
        {
            if (indexPath.row == 3) { //倒数第二行
              return 44;
            }else if (indexPath.row == 4){
             return 44;
            }
            else{
                return 134;
            }
        }
        
    }
    else{
        if (indexPath.row == order.product.count+1) { //倒数第二行
            return 44;
        }
        else{
            return 134;
        }
    }
    
    
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
    vc.order_id = order.order_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark 获取数据

- (void)getOrderList{

    NSString *url;
    switch (self.type) {
        case OrderType_All:
        {
            url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8&test_phone=13771961207",@"http://bbctest.matrojp.com",[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        case OrderType_Fukuan:
        {
             url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8&status=1&test_phone=13771961207",@"http://bbctest.matrojp.com",[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        case OrderType_Pingjia:
        {
             url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8&status=4&buyer_comment=0&test_phone=13771961207",@"http://bbctest.matrojp.com",[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        case OrderType_Shouhuo:
        {
             url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=index&cur_page=%@&page_size=8&status=3&test_phone=13771961207",@"http://bbctest.matrojp.com",[NSNumber numberWithInteger:pageIndex]];
        }
            break;
        default:
            break;
    }

    [[HFSServiceClient sharedJSONClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSDictionary *order_list = data[@"order_list"];
            
            if (order_list &&[order_list isKindOfClass:[NSDictionary class]])
            {
                NSArray *list = order_list[@"list"];
                if (pageIndex == 0) {
                    [self.orderList removeAllObjects];
                }
                if (list.count>0) {
                    [self.orderList addObjectsFromArray:[MLPersonOrderModel mj_objectArrayWithKeyValuesArray:list]];
                    pageIndex ++;
                }
                [self.tableView reloadData];
            }
            
        }
        
        [self.view configBlankPage:EaseBlankPageTypeDingdan hasData:(self.orderList.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"去逛逛吧");
        };
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self.tableView.header endRefreshing];
    }];
}


- (void)orderActionWithOrderId:(NSString *)orderId AndOerActiontype:(OrderActionType)actionType{
    NSString *action;
    switch (actionType) {
        case OrderActionTypeDel:
            action = @"delete";
            break;
        case OrderActionTypeCancel:
            action = @"cancel";
            break;
        case OrderActionTypeconfirm:
            action = @"confirm";
            break;
        default:
            break;
    }
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=%@&order_id=%@&test_phone=13771961207",@"http://localbbc.matrojp.com",action,orderId];
    [[HFSServiceClient sharedJSONClientNOT]POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //操作成功
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
    
    NSString *url= [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=product&s=admin_buyorder&action=%@&order_id=%@",action,order_id];
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //操作成功
            [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    
    
}





@end

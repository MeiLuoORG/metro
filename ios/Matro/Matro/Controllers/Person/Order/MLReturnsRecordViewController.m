//
//  MLReturnsRecordViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsRecordViewController.h"
#import "MLAfterSaleProductCell.h"
#import "MLRetrunsHeadCell.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "Masonry.h"
#import "MLReturnsHeader.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLTuiHuoModel.h"
#import "MJExtension.h"
#import "HFSServiceClient.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLReturnRequestViewController.h"
#import "MBProgressHUD+Add.h"
#import "HFSUtility.h"
#import <CommonCrypto/CommonDigest.h>
#import "MLMoreTableViewCell.h"
#import "MLAfterSaleHeadCell.h"
#import "MLReturnsDetailViewController.h"


@interface MLReturnsRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;

@end

static NSInteger pageIndex = 0;

@implementation MLReturnsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleHeadCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleProductCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleProductCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self.view);
    }];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 0 ;
        [self getOrderDataSource];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getOrderDataSource];
    }];
    
    //    [self.tableView.header beginRefreshing];
    
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MLTuiHuoModel *model = [self.orderList objectAtIndex:section];
    
    if (model.isMore && !model.isOpen) { //有更多 未展开
        return 5;
    }
    return model.products.count+2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLTuiHuoModel *model = [self.orderList objectAtIndex:indexPath.section];
    
    
    __weak typeof(self) weakself = self;
    if (indexPath.row == 0 ) {
        MLAfterSaleHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLAfterSaleHeadCell forIndexPath:indexPath];
        cell.tuiHuoModel = model;
        return cell;
    }else if (indexPath.row==1){
        MLOrderInfoHeaderTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.shopName.text = model.company;
        cell.statusLabel.hidden = YES;
        return cell;
    }
    if (model.isMore && !model.isOpen && indexPath.row == 4) {//有更多 未展开 最后一行
        MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
        cell.moreActionBlock = ^(){
            model.isOpen = YES;
            [weakself.tableView reloadData];
        };
        [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",model.products.count-2] forState:UIControlStateNormal];
        return cell;
    }
    MLOrderCenterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tuiHuoProduct = [model.products objectAtIndex:indexPath.row - 2];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 ) {
        MLTuiHuoModel *model = [self.orderList objectAtIndex:indexPath.section];
        MLReturnsDetailViewController *vc = [[MLReturnsDetailViewController alloc]init];
        vc.order_id = model.order_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLTuiHuoModel *model = [self.orderList objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return 110.f;
    }
    else if (indexPath.row == 1 ||(model.isMore && !model.isOpen && indexPath.row == 4) ){
        return 40;
    }
    return 134.f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
    
}



- (NSMutableArray *)orderList{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
        MLTuiHuoModel *testModel = [[MLTuiHuoModel alloc]init];
        testModel.order_id = @"201606211337";
        testModel.company = @"测试店铺";
        testModel.status = @"已完成";
        testModel.product_price = 25.31;
        testModel.create_time = @"2016 06-21 13:23";
        
        MLTuiHuoProductModel *test1 = [[MLTuiHuoProductModel alloc]init];
        test1.name = @"手表";
        test1.pic = @"http://img3.douban.com/view/commodity_story/medium/public/p21316.jpg";
        test1.num = @"2";
        test1.setmeal = @[@"颜色",@"标签"];
        test1.pid = @"132123";
        MLTuiHuoProductModel *test2 = [[MLTuiHuoProductModel alloc]init];
        test2.name = @"手机";
        test2.pic = @"http://www.sinokin.com/imgit/P4f279422856f8.gif";
        test2.num = @"2";
        test2.setmeal = @[@"颜色",@"标签"];
        test2.pid = @"132123";
        MLTuiHuoProductModel *test3 = [[MLTuiHuoProductModel alloc]init];
        test3.name = @"鞋子";
        test3.pic = @"http://www.wangjiasong.com/upload/productpic/917/Big/2014102210184148.jpg";
        test3.num = @"2";
        test3.setmeal = @[@"颜色",@"标签"];
        test3.pid = @"132123";
        MLTuiHuoProductModel *test4 = [[MLTuiHuoProductModel alloc]init];
        test4.name = @"洗衣液";
        test4.pic = @"http://www.sinokin.com/imgit/P4ea7d043baf02.gif";
        test4.num = @"1";
        test4.setmeal = @[@"颜色",@"标签"];
        test4.pid = @"132123";
        testModel.products = @[test1,test2,test3,test4];
        [_orderList addObject:testModel];
        
    }
    return _orderList;
}

- (void)getOrderDataSource{
    //    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    //    NSTimeInterval time = [[NSDate new] timeIntervalSince1970];
    //    NSString *sign = [token substringToIndex:12];
    //
    //    NSString *signStr = [NSString stringWithFormat:@"%@%@%.f%@",sign,@"return",time,@"order_list"];
    //
    //    NSString *md5 = [self md5:signStr];
    
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=return_list&cur_page=%li&page_size=3&test_phone=%@",@"http://bbctest.matrojp.com",pageIndex,@"13771961207"];
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            if (pageIndex == 0) {
                [self.orderList removeAllObjects];
            }
            [self.orderList addObjectsFromArray:[MLTuiHuoModel mj_objectArrayWithKeyValuesArray:data[@"return_list"]]];
            pageIndex ++;
            [self.tableView reloadData];
        }else{
            NSString *str = result[@"msg"];
            
            [MBProgressHUD showMessag:str toView:self.view];
        }
        [self.view configBlankPage:EaseBlankPageTypeTuihuo hasData:(self.orderList.count>0)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}





@end

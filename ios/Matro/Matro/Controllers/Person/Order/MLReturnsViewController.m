//
//  MLReturnsViewController.m
//  Matro
//
//  Created by MR.Huang on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsViewController.h"
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
#import "MLHttpManager.h"

#import "MLMoreTableViewCell.h"


@interface MLReturnsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;

@end

static NSInteger pageIndex = 1;


@implementation MLReturnsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLRetrunsHeadCell" bundle:nil] forCellReuseIdentifier:kMLRetrunsHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleProductCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleProductCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1 ;
        [self getOrderDataSource];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getOrderDataSource];
    }];
    
    [self.tableView.header beginRefreshing];
    
//    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
//    item.title = @"";
//    item.image = backButtonImage;
//    item.width = -20;
//    self.navigationItem.leftBarButtonItem = item;
    
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
        MLRetrunsHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLRetrunsHeadCell forIndexPath:indexPath];
        cell.tuihuoBlock = ^(){
            MLReturnRequestViewController *vc = [[MLReturnRequestViewController alloc]init];
            vc.order_id = model.order_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        cell.tuihuoModel = model;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLTuiHuoModel *model = [self.orderList objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return 80.f;
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
    }
    return _orderList;
}

- (void)getOrderDataSource{
    
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=order_list&cur_page=%li&page_size=10",MATROJP_BASE_URL,pageIndex];
    [MLHttpManager get:url params:nil m:@"return" s:@"order_list" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            if (pageIndex == 1) {
                [self.orderList removeAllObjects];
            }
            NSString *count = data[@"total"];
            if (self.orderList.count < [count integerValue]) {
                [self.orderList addObjectsFromArray:[MLTuiHuoModel mj_objectArrayWithKeyValuesArray:data[@"order_list"]]];
                pageIndex ++;
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showMessag:@"已没有更多记录" toView:self.view];
            }

        }else{
            NSString *str = result[@"msg"];
            [MBProgressHUD showMessag:str toView:self.view];
        }
        [self.view configBlankPage:EaseBlankPageTypeTuihuo hasData:(self.orderList.count>0)];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}


@end

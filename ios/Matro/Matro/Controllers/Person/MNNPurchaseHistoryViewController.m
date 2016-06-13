//
//  MNNPurchaseHistoryViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNPurchaseHistoryViewController.h"
#import "MNNPurchaseHistoryTableViewCell.h"
#import "HFSConstants.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"
#import "HFSUtility.h"
#import "CommonHeader.h"

@interface MNNPurchaseHistoryViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    UILabel *_usableLabel;
    UILabel *_accumulateLabel;
    NSMutableArray *_dataArray;
}

@end
static NSInteger currentPage = 1;
@implementation MNNPurchaseHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    self.title = @"我的会员卡消费记录";
    _dataArray = [NSMutableArray array];
    [self createViews];
    // Do any additional setup after loading the view.
}
- (void)createViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    _tableView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    UIView * blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, MAIN_SCREEN_WIDTH, 40)];
    blackView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:blackView];
    _usableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, MAIN_SCREEN_WIDTH/2, 20)];
    _usableLabel.text = @"21450";
    _usableLabel.font = [UIFont systemFontOfSize:12];
    _usableLabel.textAlignment = NSTextAlignmentCenter;
    _usableLabel.alpha = 0.6;
    [headerView addSubview:_usableLabel];
    _accumulateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2, 5, MAIN_SCREEN_WIDTH/2, 20)];
    _accumulateLabel.text = @"56840";
    _accumulateLabel.font = [UIFont systemFontOfSize:12];
    _accumulateLabel.textAlignment = NSTextAlignmentCenter;
    _accumulateLabel.alpha = 0.6;
    [headerView addSubview:_accumulateLabel];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_usableLabel.frame), MAIN_SCREEN_WIDTH/2, 20)];
    label1.text = @"可用积分";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2, CGRectGetMaxY(_accumulateLabel.frame), MAIN_SCREEN_WIDTH/2, 20)];
    label2.text = @"积累消费积分";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label2];
    _tableView.tableHeaderView = headerView;
    [_tableView registerClass:[MNNPurchaseHistoryTableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    //zhoulu  刷新控件
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"头部刷新控件");
        [_tableView.header endRefreshing];
    }];
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"尾部刷新控件");
        [_tableView.footer endRefreshing];
    }];
    [_tableView.header beginRefreshing];
    
    [self.view addSubview:_tableView];
    
}
#pragma mark - 
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MNNPurchaseHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[MNNPurchaseHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

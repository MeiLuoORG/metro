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
    NSString * _currentTimeString;
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
    //初始化弹出信息
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
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
        [self headerRefreshAction];
    }];
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"尾部刷新控件");
        currentPage++;
        [self footerRefreshActionWith:currentPage];
        
    }];
    [_tableView.header beginRefreshing];
    
    [self.view addSubview:_tableView];
    
}

- (void)headerRefreshAction{
    
    //获取时间
    NSDate * date = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  locationString = [dateformatter stringFromDate:date];
    NSLog(@"当前时间为：%@",locationString);
    _currentTimeString = locationString;
    [self getCardInfoWithpageIndex:@"1" withEndTime:locationString];

}

- (void)footerRefreshActionWith:(NSInteger )page{

    NSString * pageStr = [NSString stringWithFormat:@"%ld",page];
    
    [self getCardInfoWithpageIndex:pageStr withEndTime:_currentTimeString];
    
}

- (void)jieShuRefresh{

    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

#pragma mark - 
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
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

#pragma 请求消费记录
- (void)getCardInfoWithpageIndex:(NSString *)pageIndex withEndTime:(NSString *)endTime{
    
    /*
     zhoulu
     */
    NSLog(@"卡内码为：%@",self.cardID);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    //{"appId": "test0002","phone":"18020260894","sign":$sign,"accessToken":$accessToken}

    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"cardId":@"1502648",@"startTime":@"1990-01-01",@"endTime":endTime,@"pageCount":@"20",@"pageIndex":pageIndex}];
    NSLog(@"当前日期为：%@",endTime);
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                           @"cardId":@"1502648",
                            @"startTime":@"1990-01-01",
                            @"endTime":endTime,
                            @"pageCount":@"20",
                            @"pageIndex":pageIndex,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    NSLog(@"加密后的消费记录：%@",ret2);
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:VIPCARD_HISTORY_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary * userDataDic = result[@"data"];
        NSLog(@"获取消费记录信息%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            NSString * sumStr = [NSString stringWithFormat:@"%@",userDataDic[@"sum"]];
            if (![sumStr isEqualToString:@"0"]) {
                
                NSArray * historyARR = userDataDic[@"VipSaleItems"];
                for (NSDictionary * dicss in historyARR) {
                    
                    VIPCardHistoryModel * vipHistoryModel = [VIPCardHistoryModel new];
                    vipHistoryModel.saleTime = dicss[@"SaleTime"];
                    vipHistoryModel.saleMoney = dicss[@"SaleMoney"];
                    vipHistoryModel.billId = dicss[@"BillId"];
                    vipHistoryModel.storeName = dicss[@"StoreName"];
                    
                    [_dataArray addObject:vipHistoryModel];
                    //vipHistoryModel
                    
                }
                

                
                
                [_tableView reloadData];
            }
            

            
        }else{
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
            
            /*
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"账户已过期" message:nil delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
             [alert show];
             */
        }
        //结束刷新
        [self jieShuRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //结束刷新
        [self jieShuRefresh];
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
    
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

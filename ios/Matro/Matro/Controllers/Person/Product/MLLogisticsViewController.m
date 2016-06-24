//
//  MLLogisticsViewController.m
//  Matro
//
//  Created by NN on 16/4/11.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLLogisticsViewController.h"
#import "MLLogisticsTableViewCell.h"
#import "UIColor+HeinQi.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "SkyRadiusView.h"
#import "AppDelegate.h"
#import "UIView+BlankPage.h"
#import "MLLogisticsModel.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"

@interface MLLogisticsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *logisticsArray;
@end

@implementation MLLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"订单跟踪";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self downLoadLogTrack];
}


- (void)downLoadLogTrack {
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=getkd&test_phone=13771961207",@"http://bbctest.matrojp.com"];
    NSDictionary *params = @{@"express_company":self.express_company,@"express_number":self.express_number};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *time_line = data[@"timeline"];
            [self.logisticsArray addObjectsFromArray:time_line];
            [self.tableView reloadData];
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    
    
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=wlxx&jlbh=%@&userid=%@",SERVICE_GETBASE_URL,_jlbh,userId];
//    [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"订单跟踪 请求成功");
//        NSData *dic = (NSData *)responseObject;
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSArray *backArr = [result objectForKey:@"BackObject"];
//        if (result && backArr.count>0) {
//            _logisticsArray = backArr ;
//            [self.tableView reloadData];
//        }
//        
//        [self.view configBlankPage:EaseBlankPageTypeZhuiZong hasData:(_logisticsArray.count>0)];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
}

- (void)homeAction{
    [self getAppDelegate].tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return self.logisticsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *CellIdentifier = @"MLLogisticsTableViewCell" ;
    MLLogisticsTableViewCell *cell = (MLLogisticsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    if (self.logisticsArray.count == 1) {
        cell.topLine.hidden = YES;
        cell.bottomLine.hidden = YES;
        cell.point.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
        cell.infoLabel.textColor = [UIColor colorWithHexString:@"#AE8E5D"];

    }else{
        if (indexPath.row == 0) {
            cell.topLine.hidden = YES;
            cell.point.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
            cell.infoLabel.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
        }else if (indexPath.row == self.logisticsArray.count - 1){
            cell.bottomLine.hidden = YES;
            cell.point2.hidden = YES;
            cell.point.backgroundColor = [UIColor colorWithHexString:@"#dcdcdc"];
            cell.infoLabel.textColor = [UIColor colorWithHexString:@"#0e0e0e"];
        }else{
            cell.point2.hidden = YES;
        }
    }
    MLLogisticsModel *logistics = self.logisticsArray[indexPath.row];
    cell.infoLabel.text = logistics.context;
    cell.timeLabel.text = logistics.time;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//"time": "2016-06-05 13:25:37",
//
//"location": "",
//
//"context": "苏州市|签收|苏州市【园区三部】，小杨代 已签收"

- (NSMutableArray *)logisticsArray{
    if(!_logisticsArray){
        _logisticsArray = [NSMutableArray array];
        MLLogisticsModel *logistics = [[MLLogisticsModel alloc]init];
        logistics.context = @"苏州市|签收|苏州市【园区三部】，小杨代 已签收";
        logistics.time = @"2016-06-05 13:25:37";
        logistics.location= @"";
        [_logisticsArray addObject:logistics];
        
        MLLogisticsModel *logistics1 = [[MLLogisticsModel alloc]init];
        logistics1.context = @"苏州市|到件|到苏州市【园区三部】";
        logistics1.time = @"2016-06-05 08:51:19";
        logistics1.location= @"";
        [_logisticsArray addObject:logistics1];
        MLLogisticsModel *logistics2 = [[MLLogisticsModel alloc]init];
        logistics2.context = @"苏州市|派件|苏州市【园区三部】，【杨岗/13115106897】正在派件";
        logistics2.time = @"2016-06-05 05:08:33";
        logistics2.location= @"";
        [_logisticsArray addObject:logistics2];
        
    }
    return _logisticsArray;
}

@end

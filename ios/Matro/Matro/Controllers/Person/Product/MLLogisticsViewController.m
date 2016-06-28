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
#import "MLHttpManager.h"

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
    [self downLoadLogTrack];
}


- (void)downLoadLogTrack {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=getkd",MATROJP_BASE_URL];
    NSDictionary *params = @{@"express_company":self.express_company?:@"",@"express_number":self.express_number?:@""};
    
    [MLHttpManager post:url params:params m:@"member" s:@"getkd" success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *time_line = data[@"timeline"];
            [self.logisticsArray addObjectsFromArray:[MLLogisticsModel mj_objectArrayWithKeyValuesArray:time_line]];
            [self.tableView reloadData];
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
            [self performSelector:@selector(goback) withObject:nil afterDelay:1];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
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


- (NSMutableArray *)logisticsArray{
    if(!_logisticsArray){
        _logisticsArray = [NSMutableArray array];
    }
    return _logisticsArray;
}

@end

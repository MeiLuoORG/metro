//
//  MLMyPropertyViewController.m
//  Matro
//
//  Created by Matro on 16/5/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLMyPropertyViewController.h"
#import "MLPropertysubCell.h"
#import "MLPropertyCell.h"
#import "MLYHQViewController.h"
#import "MLLoginViewController.h"
#import "YMNavigationController.h"
#import "MJRefresh.h"

@interface MLMyPropertyViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSString *loginid;
}
@property (strong, nonatomic) IBOutlet UITableView *myPropertyTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnWithdrawCash;


@end

@implementation MLMyPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的资产";
    self.btnWithdrawCash.layer.cornerRadius = 4.0;
    self.btnWithdrawCash.layer.masksToBounds = YES;
    _myPropertyTableView = ({
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64-self.tabBarController.tabBar.bounds.size.height-200)];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = RGBA(245, 245, 245, 1);
        table.delegate = self;
        table.dataSource = self;
        table.showsVerticalScrollIndicator = NO;
        
        [table registerNib:[UINib nibWithNibName:@"MLPropertyCell" bundle:nil] forCellReuseIdentifier:kMLPropertyCell];
        [table registerNib:[UINib nibWithNibName:@"MLPropertysubCell" bundle:nil] forCellReuseIdentifier:kMLPropertysubCell];
        
        [self.view addSubview:table];
        table;
    });
    _myPropertyTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_myPropertyTableView.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MLPropertysubCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPropertysubCell forIndexPath:indexPath];
        cell.sorceBlcok = ^(){
            
            if (!loginid) {
                [self showError];
            }else{
                
                NSLog(@"线上积分");
            }
        };
        cell.chargeBlock = ^(){
            
            if (!loginid) {
                [self showError];
            }else{
                NSLog(@"优惠券");
                MLYHQViewController *vc = [[MLYHQViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.moneyBlock = ^(){
            if (!loginid) {
                [self showError];
            }else{
                
                NSLog(@"余额");
            }
            
        };
        return cell;

    }
    MLPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPropertyCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.labProperty.text = @"我的优惠券";
        cell.myImageView.hidden = YES;
    }else if (indexPath.row == 1){
    
        cell.labProperty.text = @"我的交易记录";
        cell.myImageView.hidden = YES;
    }
    else{
    
        cell.labProperty.text = @"我的积分记录";
        cell.myImageView.hidden = YES;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {

    if (indexPath.section ==1) {
        if (indexPath.row == 0) {
            NSLog(@"优惠券");
            MLYHQViewController *vc = [[MLYHQViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 1){
            NSLog(@"我的交易记录");
        }else{
        
            NSLog(@"我的积分记录");
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }
    return 44;
}


-(void)showError
{
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
    YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actWithdrawCash:(id)sender {
    
    NSLog(@"申请提现");
}
@end

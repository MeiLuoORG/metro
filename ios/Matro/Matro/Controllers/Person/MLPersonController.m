//
//  MLPersonController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonController.h"
#import "MLPersonHeadView.h"
#import "MLPersonAccountCell.h"
#import "MLCusServiceCell.h"
#import "MLPersonOrderCell.h"
#import "MNNManagementViewController.h"
#import "MyAddressManagerViewController.h"
#import "HFSOrderListViewController.h"

#import "MLLoginViewController.h"
#import "YMNavigationController.h"
#import "UIButton+WebCache.h"

#import "APPSettingViewController.h"
#import "MLFootprintViewController.h"
#import "MLCusServiceController.h"
#import "MNNMemberViewController.h"

#import "MLHYHTableViewController.h"
#import "MLWishlistViewController.h"


@interface MLPersonController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSArray *imgArray;
    NSString *loginid;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLPersonHeadView *headView;


@end

@implementation MLPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"个人中心";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_top_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonAction:)];
    // Do any additional setup after loading the view.
    _tableView = ({
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64-self.tabBarController.tabBar.bounds.size.height)];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = RGBA(245, 245, 245, 1);
        table.delegate = self;
        table.dataSource = self;
        table.showsVerticalScrollIndicator = NO;
        [table registerNib:[UINib nibWithNibName:@"MLPersonAccountCell" bundle:nil] forCellReuseIdentifier:kMLPersonAccountCell];
        [table registerNib:[UINib nibWithNibName:@"MLCusServiceCell" bundle:nil] forCellReuseIdentifier:kMLCusServiceCell];
        [table registerNib:[UINib nibWithNibName:@"MLPersonOrderCell" bundle:nil] forCellReuseIdentifier:kMLPersonOrderCell];
        
        [self.view addSubview:table];
        table;
    });
    
    _headView = ({
        MLPersonHeadView *headView =[MLPersonHeadView personHeadView];
        __weak typeof(self)weakself = self;
        headView.loginBlock = ^(){
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = YES;
            YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
            [weakself presentViewController:nvc animated:YES completion:nil];
        };
        headView.regBlock = ^(){
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = NO;
            YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
            [weakself presentViewController:nvc animated:YES completion:nil];
        };
        headView.imageBlock = ^(){
            if (!loginid) {
                [weakself showError];
            }
            else{
                MNNManagementViewController *managementVC = [[MNNManagementViewController alloc] init];
                managementVC.hidesBottomBarWhenPushed = YES;

                [weakself.navigationController pushViewController:managementVC animated:YES];
            }

        };
        
        headView;
    });
    
    self.tableView.tableHeaderView = self.headView;
    
}

- (void)messageButtonAction:(UIBarButtonItem *)sender{
    self.hidesBottomBarWhenPushed = YES;
    MessagesViewController * VC = [[MessagesViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    NSString *avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
    if (loginid && ![@"" isEqualToString:loginid]) {
        self.headView.loginBtn.hidden = YES;
        self.headView.regBtn.hidden = YES;
    }
    else{
        self.headView.loginBtn.hidden = NO;
        self.headView.regBtn.hidden = NO;
    }
    NSString *nickname = [userDefaults objectForKey:kUSERDEFAULT_USERNAME];
    if (nickname && ![@"" isEqualToString:nickname]) {
        self.headView.nickLabel.text = nickname;
        self.headView.nickLabel.hidden = NO;
    }
    else
    {
        self.headView.nickLabel.hidden = YES;
        
    }
    [self.headView.headBtn sd_setImageWithURL:[NSURL URLWithString:avatorurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!loginid) {
        [self showError];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) { //我的订单
        HFSOrderListViewController *vc = [[HFSOrderListViewController alloc]init];
        vc.typeInteger = 0;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:  //会员卡
            {
                MNNMemberViewController *memberVC = [MNNMemberViewController new];
                memberVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:memberVC animated:YES];
            }
                break;
            case 1:   //客服服务
            {
                MLCusServiceController *vc = [[MLCusServiceController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:  //浏览足迹
            {
                MLFootprintViewController *vc = [[MLFootprintViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:  //设置
            {
                APPSettingViewController *vc = [[APPSettingViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 4:  //意见反馈
            {
                MLHYHTableViewController *vc = [[MLHYHTableViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;

                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                
                
            default:
                break;
        }
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakself = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MLPersonAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPersonAccountCell forIndexPath:indexPath];
            cell.accountBlcok = ^(){
                
                if (!loginid) {
                    [weakself showError];
                }
                else{
                    weakself.hidesBottomBarWhenPushed = YES;
                    MNNManagementViewController *managementVC = [[MNNManagementViewController alloc] init];
                    [weakself.navigationController pushViewController:managementVC animated:YES];
                    weakself.hidesBottomBarWhenPushed = NO;
                }

            };
            cell.addressBlcok = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    MyAddressManagerViewController *vc = [[MyAddressManagerViewController alloc]init];
                    //    vc.delegate = nil;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
             
            };
            cell.storeBlcok = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    MLWishlistViewController *vc = [[MLWishlistViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }

            };
            return cell;
        }else if (indexPath.row == 1){
            MLCusServiceCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLCusServiceCell forIndexPath:indexPath];
            cell.myTitleLabel.text = @"我的订单";
            cell.myImageView.image = [UIImage imageNamed:@"wodedingdan"];
            cell.mySubLabel.text = @"查看全部订单";
            cell.mySubLabel.hidden = NO;
            return cell;
        }
        else if (indexPath.row == 2){
            MLPersonOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPersonOrderCell forIndexPath:indexPath];
            cell.daifahuoBlcok = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    HFSOrderListViewController *vc = [[HFSOrderListViewController alloc]init];
                    vc.typeInteger = 2;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
            cell.daifukuanBlock = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    HFSOrderListViewController *vc = [[HFSOrderListViewController alloc]init];
                    vc.typeInteger = 1;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
              
            };
            cell.daishouhuoBlock = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    HFSOrderListViewController *vc = [[HFSOrderListViewController alloc]init];
                    vc.typeInteger = 3;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
               
            };
            cell.tuihuoBlock = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    HFSOrderListViewController *vc = [[HFSOrderListViewController alloc]init];
                    vc.typeInteger = 4;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
               
            };
            return cell;
        }
    }
    MLCusServiceCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLCusServiceCell forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.myTitleLabel.text = @"会员卡";
            cell.myImageView.image = [UIImage imageNamed:@"Outlined_gray"];
            cell.mySubLabel.text = @"享受特权";
            cell.mySubLabel.hidden = NO;
            
        }
            break;
        case 1:
        {
            cell.myTitleLabel.text = @"客服服务";
            cell.myImageView.image = [UIImage imageNamed:@"kehufuwu"];
        }
            break;
        case 2:
        {
            cell.myTitleLabel.text = @"浏览足迹";
            cell.myImageView.image = [UIImage imageNamed:@"liulanzuji"];
        }
            break;
        case 3:
        {
            cell.myTitleLabel.text = @"设置";
            cell.myImageView.image = [UIImage imageNamed:@"Settings"];
            cell.mySubLabel.hidden = NO;
            cell.mySubLabel.text = @"应用设置";
            
        }
            break;
        case 4:
        {
            cell.myTitleLabel.text = @"意见反馈";
            cell.myImageView.image = [UIImage imageNamed:@"Highlighter"];
        }
            break;   
        default:
            break;
    }

    return cell;

}

-(void)showError
{
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
    YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return [[UIView alloc]init];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 1? 8:0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row == 2) {
        return 70;
    }
    return 44;
}


@end

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
#import "MLPropertyCell.h"
#import "MLPropertysubCell.h"
#import "MLYHQViewController.h"
#import "MLMyPropertyViewController.h"
#import "JSBadgeView.h"
#import "MJRefresh.h"

@interface MLPersonController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSArray *imgArray;
    NSString *loginid;
    JSBadgeView *badgeView;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLPersonHeadView *headView;


@end

@implementation MLPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"个人中心";
    
     UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"news"] style:UIBarButtonItemStylePlain target:self action:@selector(actMessage)];

    self.navigationItem.rightBarButtonItem = right;
    
    //right.badge.frame = CGRectMake(0, 0, 5, 5);
    right.badgeValue = @"●";
    right.badgeTextColor = [UIColor redColor];
    right.badgeBGColor = [UIColor clearColor];
    //right.badge.hidden = YES;
    //right.badgeMinSize = 0.5f;
    //right.badgeTextColor = [UIColor redColor];
    
    /*
    badgeView = [[JSBadgeView alloc] initWithParentView:right.customView alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeText = @"2";
     */
    
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
        [table registerNib:[UINib nibWithNibName:@"MLPropertyCell" bundle:nil] forCellReuseIdentifier:kMLPropertyCell];
        [table registerNib:[UINib nibWithNibName:@"MLPropertysubCell" bundle:nil] forCellReuseIdentifier:kMLPropertysubCell];
        
        [self.view addSubview:table];
        table;
    });
    
    
    
    _headView = ({
        MLPersonHeadView *headView =[MLPersonHeadView personHeadView];
        __weak typeof(self)weakself = self;
        headView.loginBlock = ^(){
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = YES;
            //YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
            
            [weakself presentViewController:vc animated:YES completion:nil];
            
        };
        headView.regBlock = ^(){
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = NO;
            //YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
            [weakself presentViewController:vc animated:YES completion:nil];
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
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableView.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
        badgeView.hidden = NO;
    }];
    
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
    NSLog(@"用户昵称为：%@",nickname);
    if (nickname && ![@"" isEqualToString:nickname]) {
        
        //会员类型 名称
        NSString * cardTypeid = [userDefaults objectForKey:KUSERDEFAULT_CARDTYPE_CURRENT];
        NSLog(@"会员卡类型：%@",cardTypeid);
        if (cardTypeid) {
            self.headView.cardTypeLabel.text = [NSString stringWithFormat:@"%@",cardTypeid];
            self.headView.cardTypeLabel.hidden = NO;
        }
        
        self.headView.nickLabel.text = nickname;
        self.headView.nickLabel.hidden = NO;
    }
    else
    {
        self.headView.nickLabel.hidden = YES;
        self.headView.cardTypeLabel.hidden = YES;
    }
    

    
    [self.headView.headBtn sd_setImageWithURL:[NSURL URLWithString:avatorurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }
    return 4;
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"我的资产");
        /*
        MLMyPropertyViewController *vc = [[MLMyPropertyViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
         */
    }
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:  //会员卡
            {
                MNNMemberViewController *memberVC = [MNNMemberViewController new];
                memberVC.hidesBottomBarWhenPushed = YES;
                //[memberVC loadData];
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
            cell.mySubLabel.text = @"查看订单";
            cell.mySubLabel.hidden = NO;
            return cell;
        }
        else if (indexPath.row == 2){
            MLPersonOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPersonOrderCell forIndexPath:indexPath];
            //badgeView = [[JSBadgeView alloc] initWithParentView:cell.imgDaifukuan alignment:JSBadgeViewAlignmentTopRight];
            //badgeView.badgeText = @"2";
            //zhoulu
            JSBadgeView * badge1 = [[JSBadgeView alloc]initWithParentView:cell.imgDaifahuo alignment:JSBadgeViewAlignmentTopRight];
            badge1.badgeText = @"0";
            JSBadgeView * badge2 = [[JSBadgeView alloc]initWithParentView:cell.imgDaifukuan alignment:JSBadgeViewAlignmentTopRight];
            badge2.badgeText = @"12";
            JSBadgeView * badge3 = [[JSBadgeView alloc]initWithParentView:cell.imgDaishouhuo alignment:JSBadgeViewAlignmentTopRight];
            badge3.badgeText = @"12";
            JSBadgeView * badge4 = [[JSBadgeView alloc]initWithParentView:cell.imgTuikuan alignment:JSBadgeViewAlignmentTopRight];
            badge4.badgeText = @"12";
            
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
                    badgeView.hidden = YES;
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
    else if (indexPath.section == 1){
    
        if (indexPath.row == 0) {
            MLPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPropertyCell forIndexPath:indexPath];
            cell.myImageView.image = [UIImage imageNamed:@"Outlined_gray"];
            cell.labProperty.text = @"我的资产";
            return cell;
        }
        else{
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
                
                    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                    NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2290103097&version=1&src_type=web"];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    //webView.delegate = self;
                    [webView loadRequest:request];
                    [self.view addSubview:webView];
                    NSLog(@"余额");
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
    //YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:vc animated:YES completion:nil];
    
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
    }if (indexPath.section == 1 && indexPath.row == 1) {
        return 60;
    }
    return 44;
}


-(void)actMessage{
    self.hidesBottomBarWhenPushed = YES;
    MessagesViewController * VC = [[MessagesViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

@end

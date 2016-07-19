//
//  APPSettingViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/5/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "APPSettingViewController.h"
#import "APPSettingCell.h"
#import "HFSUtility.h"
#import "MNNAboutUsViewController.h"
#import "SDImageCache.h"
#import "MLPushConfigViewController.h"
#import "UIViewController+MLMenu.h"

#import "AppDelegate.h"



@interface APPSettingViewController ()<UITableViewDataSource,UITableViewDelegate,PulldownMenuDelegate>{
    
    //BMKLocationService * _locService;
    //BMKGeoCodeSearch* _geoCode;
    BOOL _isLocationSuccess;
    PulldownMenu * _pulldownMenu;
    
    UIImageView * _gengDuoImageView;
    BOOL _isShowImage;
}



@end

@implementation APPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self startsLocation];
    _isShowImage = NO;
    self.title = @"设置";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:kUSERDEFAULT_USERID]) {
        self.logoutBtn.hidden = YES;
    }
    
    self.logoutBtn.layer.cornerRadius = 4.0f;
    self.logoutBtn.layer.masksToBounds = YES;
    self.logoutBtn.backgroundColor = [HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor];
    [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    

    [self addMenuButton];

}


- (void)buttonAction3:(UIButton *)sender{
    
    NSLog(@"点击了更多按钮");
    if (_isShowImage) {
        _isShowImage = NO;
        _gengDuoImageView.hidden = YES;
        
    }
    else{
        _isShowImage = YES;
        _gengDuoImageView.hidden = NO;
    }
   
    
}

//快捷入口

- (void)kuaiJieBtnAction:(UIButton *)sender{

    if (sender.tag == 101) {
        NSLog(@"点击了首页");
        //首页
        UITabBarController *rootViewController = (UITabBarController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
        [rootViewController setSelectedIndex:0];
        

    }
    if (sender.tag == 102) {
        //搜索
    }
    if (sender.tag == 103) {
        //消息
    }
    if (sender.tag == 104) {
        //收藏
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    _isShowImage = NO;
    _gengDuoImageView.hidden = YES;

}




- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout:(id)sender
{
    // 存储用户信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERCARDNO];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERAVATOR];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERID];
    
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERPHONE];
    
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERNAME];
    [userDefaults removeObjectForKey:KUSERDEFAULT_ISHAVE_DEFAULTCARD_BOOL];
    [userDefaults removeObjectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    [userDefaults removeObjectForKey:KUSERDEFAULT_CARDTYPE_CURRENT];
    [userDefaults removeObjectForKey:ZHAOHUIPASSWORD_CURRENT_PHONE];
    
    [userDefaults removeObjectForKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
    [userDefaults removeObjectForKey:KUSERDEFAULT_TIMEINTERVAR_LIJIA];
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self logoutAction];
}

#pragma mark 退出登录
- (void)logoutAction{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    //NSString * userId  = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    [[HFSServiceClient sharedClient] POST:Logout_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            
            _hud.labelText = @"退出成功";
            [_hud hide:YES afterDelay:2];
            // 存储用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:kUSERDEFAULT_USERCARDNO];
            [userDefaults removeObjectForKey:kUSERDEFAULT_USERAVATOR];
            [userDefaults removeObjectForKey:kUSERDEFAULT_USERID];
            
            [userDefaults removeObjectForKey:kUSERDEFAULT_USERPHONE];
            
            [userDefaults removeObjectForKey:kUSERDEFAULT_USERNAME];
            [userDefaults removeObjectForKey:KUSERDEFAULT_ISHAVE_DEFAULTCARD_BOOL];
            [userDefaults removeObjectForKey:kUSERDEFAULT_ACCCESSTOKEN];
            
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [del autoLogin];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            //[self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
    }];

}

#pragma end mark


#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2){//点击清除缓存
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"清除成功";
            [_hud hide:YES afterDelay:2];
            [self.settingTable reloadData];
        }];

        
    }
    else if (indexPath.row == 3){//关于我们
        MNNAboutUsViewController *vc = [[MNNAboutUsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        return 80;
    }
    else{
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"APPSettingCell" ;
    APPSettingCell *cell = (APPSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
        
    }
    switch (indexPath.row) {
        case 0:
            cell.lbname.text = @"版本";
            cell.valueLB.text = vCFBundleShortVersionStr;
            cell.descLB.hidden = YES;
            break;
        case 1:
            
            cell.lbname.text = @"接收通知";
            cell.valueLB.text = [NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == 0) {
                cell.valueLB.text = @"已关闭";
            }
            else{
                
                cell.valueLB.text = @"已开启";
            }
            cell.descLB.text = @"如需关闭或开启新消息通知，请在手机设置-通知功能中，找到“苏州美罗精品”进行更改";
            break;
        case 2:
            cell.lbname.text = @"清除缓存";
            cell.valueLB.text = [NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
            cell.valueLB.hidden = !([[SDImageCache sharedImageCache]getSize]>0);
            cell.descLB.hidden = YES;
            
            break;
        case 3:
            {
            cell.lbname.text = @"关于我们";
            cell.descLB.hidden = YES;
            cell.valueLB.hidden = YES;
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiayiye_arrow"]];
            imgView.frame = CGRectMake(MAIN_SCREEN_WIDTH-28,15, 7, 15);
            [cell addSubview:imgView];
            }
            break;
        default:
                break;
        
    }
    
    return cell;
}

@end

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

@interface APPSettingViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation APPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self startsLocation];
    self.title = @"应用设置";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:kUSERDEFAULT_USERID]) {
        self.logoutBtn.hidden = YES;
    }
    
    self.logoutBtn.layer.cornerRadius = 4.0f;
    self.logoutBtn.layer.masksToBounds = YES;
    self.logoutBtn.backgroundColor = [HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor];
    [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    
    
    // Do any additional setup after loading the view from its nib.
    
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
    //@"vip/AuthUserInfo"
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
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定清除缓存?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeIndeterminate;
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                [_hud hide:YES];
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"清除成功";
                [_hud hide:YES afterDelay:2];
                
                [self.settingTable reloadData];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:alertAction];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else if (indexPath.row == 1){
        MLPushConfigViewController *vc = [[MLPushConfigViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
            cell.valueLB.text = @"2.0.0";
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
            /*
             cell.valueLB.text = [NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
             cell.valueLB.hidden = !([[SDImageCache sharedImageCache]getSize]>0);
             */
            break;
        default:
                break;
        
    }
    
    return cell;
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

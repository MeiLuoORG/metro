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

<<<<<<< Updated upstream
@interface APPSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
=======
@interface APPSettingViewController ()<UITableViewDataSource,UITableViewDelegate,PulldownMenuDelegate>{
    
    BMKLocationService * _locService;
    BMKGeoCodeSearch* _geoCode;
    BOOL _isLocationSuccess;
    PulldownMenu * _pulldownMenu;
    
    UIImageView * _gengDuoImageView;
    BOOL _isShowImage;
}
>>>>>>> Stashed changes


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
    
<<<<<<< Updated upstream
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
=======
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [button setImage:[UIImage imageNamed:@"gengduozl"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(8, 9, 8, 9);
    [button addTarget:self action:@selector(buttonAction3:) forControlEvents:UIControlEventTouchUpInside];
    //[button setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [self createGengDuoImageView];
    
     
}
- (void)createGengDuoImageView{

    
    _gengDuoImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(SIZE_WIDTH-13-150, 0, 150, 144)];
    _gengDuoImageView.userInteractionEnabled = YES;
    _gengDuoImageView.backgroundColor = [UIColor whiteColor];
    _gengDuoImageView.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    _gengDuoImageView.layer.borderWidth = 1;
    _gengDuoImageView.layer.masksToBounds = YES;
    [self.view addSubview:_gengDuoImageView];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 10, 150, 33)];
    [btn1 setTitle:@"首页" forState:UIControlStateNormal];
    [btn1 setTitleColor:[HFSUtility hexStringToColor:Main_textNormalBackgroundColor] forState:UIControlStateNormal];
    btn1.tag = 101;
    [btn1 setImage:[UIImage imageNamed:@"home-2"] forState:UIControlStateNormal];
    btn1.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 11, 125);
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
    btn1.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    UIView * spView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 45, 130, 1)];
    spView1.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [_gengDuoImageView addSubview:spView1];
    [_gengDuoImageView addSubview:btn1];
    [btn1 addTarget:self action:@selector(kuaiJieBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(0, CGRectGetMaxY(spView1.frame), 150, 33)];
    [btn2 setTitle:@"搜索" forState:UIControlStateNormal];
    [btn2 setTitleColor:[HFSUtility hexStringToColor:Main_textNormalBackgroundColor] forState:UIControlStateNormal];
    btn2.tag = 102;
    [btn2 setImage:[UIImage imageNamed:@"home-2"] forState:UIControlStateNormal];
    btn2.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 11, 125);
    btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
    btn2.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    UIView * spView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 45+33, 130, 1)];
    spView2.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [_gengDuoImageView addSubview:spView2];
    [_gengDuoImageView addSubview:btn2];
    [btn2 addTarget:self action:@selector(kuaiJieBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake(0, CGRectGetMaxY(spView2.frame), 150, 33)];
    [btn3 setTitle:@"消息" forState:UIControlStateNormal];
    [btn3 setTitleColor:[HFSUtility hexStringToColor:Main_textNormalBackgroundColor] forState:UIControlStateNormal];
    btn3.tag = 103;
    [btn3 setImage:[UIImage imageNamed:@"home-2"] forState:UIControlStateNormal];
    btn3.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 11, 125);
    btn3.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
    btn3.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    UIView * spView3 = [[UIView alloc]initWithFrame:CGRectMake(10, 45+33+33, 130, 1)];
    spView3.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [_gengDuoImageView addSubview:spView3];
    [_gengDuoImageView addSubview:btn3];
    [btn3 addTarget:self action:@selector(kuaiJieBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setFrame:CGRectMake(0, CGRectGetMaxY(spView3.frame), 150, 33)];
    [btn4 setTitle:@"收藏" forState:UIControlStateNormal];
    [btn4 setTitleColor:[HFSUtility hexStringToColor:Main_textNormalBackgroundColor] forState:UIControlStateNormal];
    btn4.tag = 104;
    [btn4 setImage:[UIImage imageNamed:@"home-2"] forState:UIControlStateNormal];
    btn4.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 11, 125);
    btn4.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
    btn4.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    UIView * spView4 = [[UIView alloc]initWithFrame:CGRectMake(10, 45+33+33+33, 130, 1)];
    spView4.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    //[_gengDuoImageView addSubview:spView4];
    [_gengDuoImageView addSubview:btn4];
    [btn4 addTarget:self action:@selector(kuaiJieBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _gengDuoImageView.hidden = YES;
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



#pragma mark百度地图定位 开始
//开始定位
- (void)startsLocation{
    /*
     LocationGoldController * locat = [[LocationGoldController alloc]init];
     [locat startLocationUser];
     */
>>>>>>> Stashed changes
    
    
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

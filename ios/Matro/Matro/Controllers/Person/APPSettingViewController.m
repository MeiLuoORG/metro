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

@interface APPSettingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    BMKLocationService * _locService;
    BMKGeoCodeSearch* _geoCode;
    BOOL _isLocationSuccess;
}


@end

@implementation APPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startsLocation];
    self.title = @"应用设置";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:kUSERDEFAULT_USERID]) {
        self.logoutBtn.hidden = YES;
    }
    
    self.logoutBtn.backgroundColor = [HFSUtility hexStringToColor:@"AE8E5D"];
    [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark百度地图定位 开始
//开始定位
- (void)startsLocation{
    /*
     LocationGoldController * locat = [[LocationGoldController alloc]init];
     [locat startLocationUser];
     */
    
    //初始化BMKLocationService
    //NSLog(@"开始定位");
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //_locService.allowsBackgroundLocationUpdates = YES;
    //启动LocationService
    [_locService startUserLocationService];
    
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    NSLog(@"方向变化：");
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    NSLog(@"当前定位位置为:%@",userLocation.title);
    NSLog(@"当前位置信息：didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.longitude = userLocation.location.coordinate.longitude;
    self.latitude = userLocation.location.coordinate.latitude;
    
    [self outputAdd];
    // 当前位置信息：didUpdateUserLocation lat 23.001819,long 113.341650
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位错误：%@",error);
}

#pragma mark geoCode的Get方法，实现延时加载

- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode)
    {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

//#pragma mark 获取地理位置按钮事件
- (void)outputAdd
{
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:option];
}

#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        //        self.address.text = [NSString stringWithFormat:@"%@", result.address];
        if (![result.addressDetail.city isEqualToString:@""]) {
            _isLocationSuccess = YES;
            NSLog(@"位置结果是：%@ - %@", result.address, result.addressDetail.city);
            //        NSLog(@"经纬度为：%@ 的位置结果是：%@", locationString, result.address);
            //_currentCityName = result.addressDetail.city;
            NSRange range = NSMakeRange(0, result.addressDetail.city.length-1);
            NSString * cityStr = [result.addressDetail.city substringWithRange:range];
            //NSLog(@"定位的城市是：%@",cityStr);
            /*
             AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appdelegate.currentCityName = cityStr;
             */
            self.cityNameLabel.text = cityStr;
            self.currentCityNameStr = cityStr;
            self.locationCity = cityStr;
        }
        else{
            _isLocationSuccess = NO;
            self.currentCityNameStr = @"苏州";
            self.cityNameLabel.text = @"苏州";
            //self.locationCity = @"苏州";
        }
        
        [self.tableView reloadData];
        //[self.cityButton setTitle:self.currentCityString forState:UIControlStateNormal];
        // 定位一次成功后就关闭定位
        [_locService stopUserLocationService];
        
        //NSJSONSerialization
        
    }else{
        NSLog(@"%@", @"找不到相对应的位置");
    }
    //NSLog(@"%@", @"找不到相对应的位置");
}

#pragma mark 代理方法返回地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        NSString *locationString = [NSString stringWithFormat:@"经度为：%.2f   纬度为：%.2f", result.location.longitude, result.location.latitude];
        NSLog(@"经纬度为：%@ 的位置结果是：%@", locationString, result.address);
        //        NSLog(@"%@", result.address);
    }else{
        //        self.location.text = @"找不到相对应的位置";
        NSLog(@"%@", @"找不到相对应的位置");
    }
}


#pragma end mark 地图定位 结束


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
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

}

#pragma end mark


#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     if (indexPath.row==3) {
     MNNAboutUsViewController *VC = [MNNAboutUsViewController new];
     [self.navigationController pushViewController:VC animated:YES];
     }
     else
     */
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
    }
    else if (indexPath.row == 4){//关于我们
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
            cell.valueLB.text = @"1.0.0";
            cell.descLB.hidden = YES;
            break;
        case 1:
            //[[UIApplication sharedApplication] currentUserNotificationSettings].types
            //如需关闭或开启新消息通知，请在手机设置-通知功能中，找到“苏州美罗精品”进行更改
            cell.lbname.text = @"接收通知";
            cell.valueLB.text = [NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
            //cell.valueLB.hidden = !([[SDImageCache sharedImageCache]getSize]>0);
            //cell.descLB.hidden = YES;
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
            cell.lbname.text = @"地理位置";
            if (self.currentCityNameStr) {
                cell.valueLB.text = self.currentCityNameStr;
            }
            else{
                cell.valueLB.text = @"请打开定位";
            }
            
            /*
             cell.valueLB.text = [NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
             cell.valueLB.hidden = !([[SDImageCache sharedImageCache]getSize]>0);
             */
            cell.descLB.hidden = YES;
            
            break;
        case 4:
        {
            cell.lbname.text = @"关于我们";
            cell.descLB.hidden = YES;
            cell.valueLB.hidden = YES;
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiayiye_arrow"]];
            imgView.frame = CGRectMake(MAIN_SCREEN_WIDTH-28,15, 7, 15);
            
            [cell addSubview:imgView];
        }
            
            
            break;
            //        case 1:
            //            cell.lbname.text = @"接收通知";
            //            cell.valueLB.text = @"已开启";
            //            cell.valueLB.textColor = [HFSUtility hexStringToColor:@"AE8E5D"];
            //            cell.descLB.hidden = NO;
            
            //            break;
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

//
//  AppDelegate.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "AppDelegate.h"
#import "MLClassViewController.h"
#import "MLPersonViewController.h"
#import "MLPersonController.h"
#import "ZLHomezlViewController.h"

#import "HFSConstants.h"
#import "UIColor+HeinQi.h"
#import "ZipArchive.h"
#import "JPUSHService.h"

#import "WXApi.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MMMaterialDesignSpinner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HFSUtility.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#import "IQKeyboardManager.h"
#import "HFSUtility.h"
#import "NSString+URLZL.h"
#import "MLPushMessageModel.h"
#import "MJExtension.h"

#import "MLActiveWebViewController.h"
#import "OffLlineShopCart.h"
#import "CompanyInfo.h"
#import "MLShopBagViewController.h"

#import "UMMobClick/MobClick.h"
#import "CoreNewFeatureVC.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    UMConfigInstance.appKey = @"578c85b0e0f55a304d000028";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [self initializeHomePageData];
    MMMaterialDesignSpinner *_loadingSpinner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2, ([UIScreen mainScreen].bounds.size.height-80)/2, 80, 80)];
    _loadingSpinner.tintColor = [HFSUtility hexStringToColor:@"#ae8e5d"];
    _loadingSpinner.lineWidth = 5;
    
    [_loadingSpinner startAnimating];

    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = delegate.window;
    [mainWindow addSubview:_loadingSpinner];
    
    [UIView animateWithDuration:0.6f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _loadingSpinner.alpha = 0.0f;
        _loadingSpinner.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
    } completion:^(BOOL finished) {
        [_loadingSpinner removeFromSuperview];
    }];
    

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Model.sqlite"];

    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    

    
    
    
    [WXApi registerApp:@"wx5aced428a6ce270e"];
    
    
    [UMSocialData setAppKey:@"572b140d67e58e4b9e001422"];
    
    
    [UMSocialQQHandler setQQWithAppId:@"1105292896" appKey:@"PDZl84sGb8GzJSwo" url:@"http://www.matrojp.com/"];
    //设置微信AppId、appSecret，分享url
    
    [UMSocialWechatHandler setWXAppId:@"wx5aced428a6ce270e" appSecret:@"54e1071ad99428a88330eee8489fb37c" url:@"http://www.matrojp.com/"];
    [self buildTabBarController];
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]) {
        self.pushMessage = [MLPushMessageModel mj_objectWithKeyValues:[launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]];
        
    }
    
    //网络请求缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSecondVC:) name:SelectSecondVC_NOTIFICATION object:nil];
    
    
    //判断是否需要显示：（内部已经考虑版本及本地版本缓存）
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    
    //测试代码，正式版本应该删除
    //canShow = YES;
    
    if(canShow){
        
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"yindao01.jpg"]];
        
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"yindao02.jpg"]];
        
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"yindao03.jpg"]];
        
        NewFeatureModel *m4 = [NewFeatureModel model:[UIImage imageNamed:@"yindao04.jpg"]];
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3,m4] enterBlock:^{
            
            NSLog(@"进入主页面");
            
            self.window.rootViewController = _tabBarController;
            [self autoLogin];
            
        }];
    }else{
        
        
        MLAnimationViewController * vcs = [[MLAnimationViewController alloc]init];
        [vcs animationBlockAction:^(BOOL success) {
            
            self.window.rootViewController = _tabBarController;
            [self autoLogin];
        }];
        self.window.rootViewController = vcs;
        
    }

    [Bugly startWithAppId:@"fef22c2596"];
    
    return YES;
}

- (void)selectSecondVC:(id)sender{
    
    [self.tabBarController setSelectedIndex:1];
    
}


- (void)autoLogin{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID] &&[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN] ) {
        [self renZhengLiJiaWithPhone:[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID] withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN]];
    }
    else{
     [self renZhengLiJiaWithPhone:@"99999999999" withAccessToken:@"ChnUN7ynJnoJ6K2Z39LtOBtlXkT91r"];
        
    }
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    [JPUSHService registerDeviceToken:deviceToken];
}



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    
}

//调用 李佳重新认证接口
- (void)renZhengLiJiaWithPhone:(NSString *)phoneString withAccessToken:(NSString *) accessTokenStr{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    //获取设备ID
    NSString *identifierForVendor = [JPUSHService registrationID];
    if (!identifierForVendor || identifierForVendor == nil || [identifierForVendor isEqualToString:@""]) {
        identifierForVendor = @"123456789";
    }
    NSLog(@"设备ID为：%@",identifierForVendor);
    [[NSUserDefaults standardUserDefaults] setObject:identifierForVendor forKey:DEVICE_ID_JIGUANG_LU];
    NSString * accessTokenEncodeStr = [accessTokenStr URLEncodedString];
    NSString * urlPinJie = [NSString stringWithFormat:@"%@/api.php?m=member&s=check_token&phone=%@&accessToken=%@&device_id=%@&device_source=ios",ZHOULU_ML_BASE_URLString,phoneString,accessTokenEncodeStr,identifierForVendor];
    //NSString *urlStr = [urlPinJie stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * urlStr = urlPinJie;
    NSLog(@"李佳的认证接口：%@",urlStr);
    NSURL * URL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    //NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
    //[request setHTTPBody:data3];
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSString *resultString  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"李佳认证:%@,错误信息：%@",resultString,error);
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              
                                              if (result && [result isKindOfClass:[NSDictionary class]]) {
                                                  if ([result[@"code"] isEqual:@0]) {
                                                      NSDictionary *data = result[@"data"];
                                                      
                                                      NSString *bbc_token = [data objectForKey:@"bbc_token"];
                                                      NSString *timestamp = data[@"timestamp"];
                                                      
                                                      NSDatezlModel * model1 = [NSDatezlModel sharedInstance];
                                                      model1.timeInterval =[timestamp integerValue];
                                                      model1.firstDate = [NSDate date];
                                                      [[NSUserDefaults standardUserDefaults]setObject:bbc_token forKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
                                                      if ([[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID] &&[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN] ) {
                                                          
                                                          NSString * UID  = data[@"uid"];
                                                          [[NSUserDefaults standardUserDefaults]setObject:UID forKey:DIANPU_MAIJIA_UID];
                                                      }
                                                      
                                                      
                                                      //认证成功后发送通知
                                                      [[NSNotificationCenter defaultCenter]postNotificationName:RENZHENG_LIJIA_Notification object:nil];
                                                      [[NSNotificationCenter defaultCenter]postNotificationName:RENZHENG_LIJIA_HOME_Notification object:nil];
                                                  }
                                              }
                                              NSLog(@"%@",result);
                                              
                                              
                                              //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                              
                                              
                                          }
                                      }
                                      else{

                                          
                                      }
                                      
                                  }];
    
    [task resume];
    //});
    
    
    
}



-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"银联支付回调：%@",url.host);
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
   else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    else if ([url.host isEqualToString:@"pay"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"oauth"]) {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    else if([url.host isEqualToString:@"uppayresult"]){
        NSLog(@"银联支付返回URL：%@",url);
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //数据从NSDictionary转换为NSString
                
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //判断签名数据是否存在
                if(data == nil){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    return;
                }
                /*
                 //验签证书同后台验签证书
                 //此处的verify，商户需送去商户后台做验签
                 if([self verify:sign]) {
                 //支付成功且验签成功，展示支付成功提示
                 }
                 else {
                 //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                 }
                 */
                    [[NSNotificationCenter defaultCenter]postNotificationName:YinLianPay_NOTICIFICATION_SUCCESS object:nil userInfo:nil];
                
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                    [[NSNotificationCenter defaultCenter]postNotificationName:YinLianPay_NOTICIFICATION_FAIL object:nil userInfo:nil];
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                    [[NSNotificationCenter defaultCenter]postNotificationName:YinLianPay_NOTICIFICATION_CANCEL object:nil userInfo:nil];
            }
        }];
    
    }
    else {
        return [UMSocialSnsService handleOpenURL:url];
    }


    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
        /*zhoulu*/


    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"pay"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
    
}


//支付结果
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONWXPAY object:resp];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                
                break;
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
     //NSLog(@"执行了applicationWillEnterForeground方法");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
    [[NSNotificationCenter defaultCenter]postNotificationName:APPLICATION_BECOME_ACTIVE_NOTIFICATION object:nil];
    NSLog(@"执行了applicationDidBecomeActive方法");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}




- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];

    MLPushMessageModel *pushMessage = [MLPushMessageModel mj_objectWithKeyValues:userInfo];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:pushMessage];
}


- (void)application:(UIApplication *)application
  didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)initializeHomePageData
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeHtmlDirectory = [DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:ZIP_FILE_NAME];
    BOOL isDirectory = NO;
    BOOL directoryExists = [fileManager fileExistsAtPath:homeHtmlDirectory isDirectory:&isDirectory];
    
    if (directoryExists) {
        [fileManager removeItemAtPath:homeHtmlDirectory error:nil];
    }
    //                        if (!directoryExists) {
    NSString *zipFilePath = [[NSBundle mainBundle]pathForResource:ZIP_FILE_NAME ofType:@"zip"];
    
    ZipArchive *zipArchive = [[ZipArchive alloc]init];
    if ([zipArchive UnzipOpenFile:zipFilePath]) {
        [zipArchive UnzipFileTo:homeHtmlDirectory overWrite:YES];
        [zipArchive UnzipCloseFile];
    }
}


#pragma mark- 初始化TabBar

- (UITabBarController*)buildTabBarController
{

    ZLHomezlViewController *homeViewController = [[ZLHomezlViewController alloc]init];
    homeViewController.title = @"首页";
    MLNavigationController *homeNavigationController = [[MLNavigationController alloc]initWithRootViewController:homeViewController];
    homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"home3"];
    homeNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"home3s"];
    homeNavigationController.tabBarItem.title = @"首页";
    
    MLClassViewController *classViewController = [[MLClassViewController alloc]init];
    classViewController.title = @"分类";
    MLNavigationController *classNavigationController = [[MLNavigationController alloc]initWithRootViewController:classViewController];
    classNavigationController.tabBarItem.image = [UIImage imageNamed:@"list3"];
    classNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"list3s"];
    classNavigationController.tabBarItem.title = @"分类";
    
    MLShopBagViewController *bagViewController = [[MLShopBagViewController alloc]init];
    bagViewController.title = @"购物袋";
    MLNavigationController *bagNavigationController = [[MLNavigationController alloc]initWithRootViewController:bagViewController];
    bagNavigationController.tabBarItem.image = [UIImage imageNamed:@"shopcar3"];
    bagNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"shopcar-15-15"];
    bagNavigationController.tabBarItem.title = @"购物袋";
    
    MLPersonController *personViewController = [[MLPersonController alloc]init];
    personViewController.title = @"我";
    MLNavigationController *personalNavigationController = [[MLNavigationController alloc]initWithRootViewController:personViewController];
    personalNavigationController.tabBarItem.image = [UIImage imageNamed:@"me3"];
    personalNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"me3s"];
    personalNavigationController.tabBarItem.title = @"我";
    
    _tabBarController = [[UITabBarController alloc]init];
    [_tabBarController setViewControllers:@[homeNavigationController,classNavigationController, bagNavigationController, personalNavigationController]];
    
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"#625046"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBarController.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.tabBar insertSubview:bgView atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
    return self.tabBarController;
}


@end

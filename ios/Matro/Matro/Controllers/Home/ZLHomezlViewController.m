//
//  ZLHomezlViewController.m
//  Matro
//
//  Created by lang on 16/7/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ZLHomezlViewController.h"
#import "MLVersionViewController.h"

@interface ZLHomezlViewController ()
{

    NSString *version;
}

@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property (strong, nonatomic) ZLLabelCustom * currentLabel;

@end

@protocol HomeJSObjectDelegate <JSExport>



@end

@implementation ZLHomezlViewController{
    AVCaptureSession * session;//输入输出的中间桥梁
    MBProgressHUD * _hud;
    NSMutableArray * _titlesARR;
    NSMutableArray * _urlsARR;
    
    NSMutableArray * _labelARR;
    BOOL _isTopHiden;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self getVersion];
    [self loadVersion];
    
    _titlesARR = [[NSMutableArray alloc]init];
    _urlsARR = [[NSMutableArray alloc]init];
    _labelARR = [[NSMutableArray alloc]init];
    
    /*
    NSArray * arr = @[@"首页",@"全球购",@"美罗百货",@"婴天童地",@"搜狐",@"淘宝"];
    NSArray * urlrr = @[@"http://www.baidu.com",@"http://www.baidu.com",@"http://www.baidu.com",@"http://www.baidu.com",@"http://www.baidu.com",@"http://www.baidu.com"];
    [_titlesARR addObjectsFromArray:arr];
    [_urlsARR addObjectsFromArray:urlrr];
*/
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"首页";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    

    
    //请求数据
    [self getRequestTitleARR];
    [super viewDidLoad];
    //头部导航
    [self createNavTopView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessage:) name:@"PUSHMESSAGE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleSingleTap:) name:@"PushToSearchCenter" object:nil];
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (del.pushMessage) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:del.pushMessage userInfo:nil];
    }
    
    
    
    /*
    //注册通知  按钮切换
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(homeViewButtonIndexNotification:) name:HOMEVIEW_BUTTON_INDEX_NOTIFICATION object:nil];
     */
}

-(void)loadVersion{
    
    NSString *urlStr = @"http://bbctest.matrojp.com/api.php?m=upgrade&s=index&action=sel_upgrade";
    NSDictionary *params = @{@"appverison":version,@"apptype":@"ios"};
    
    
    [[HFSServiceClient sharedJSONClientNOT]POST:urlStr parameters:params constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *code = result[@"code"];
         if ([code isEqual:@0]) {


             if ([result[@"data"][@"sel_info"] isKindOfClass:[NSString class]]) {
                 return ;
             }else{
             
             NSLog(@"版本更新：%@",result);

             NSString *loadversion = result[@"data"][@"sel_info"][@"appverison"];
             NSString *downlink = result[@"data"][@"sel_info"][@"download_link"];
             NSLog(@"version===%@ loadversion===%@ downlink===%@",version, loadversion,downlink);
            
             if (version < loadversion) {
                 MLVersionViewController *vc = [[MLVersionViewController alloc]init];
                 vc.versionLabel = loadversion;
                 vc.downlink = downlink;
                 NSString *labstr = result[@"data"][@"sel_info"][@"version_desc"];
                 vc.versioninfoLabel = labstr;
                 
                 vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
                 if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                     
                     vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                     
                 }else{
                     
                     self.modalPresentationStyle=UIModalPresentationCurrentContext;
                     
                 }
                 [self presentViewController:vc  animated:YES completion:^(void)
                  {
                      vc.view.superview.backgroundColor = [UIColor clearColor];
                      
                    }];
                }
             }
         }
         NSLog(@"请求成功 result====%@",result);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败 error===%@",error);
         
     }];
    
}

- (NSString*)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version===%@",version);
    return version;
}


- (void)pushMessage:(NSNotification *)not{
    MLPushMessageModel *message = not.object;
    [self.tabBarController setSelectedIndex:0];
    switch (message.go) {
        case PushMessageGOCenter:
        {
            [self.tabBarController setSelectedIndex:3];
        }
            break;
        case PushMessageGOUrl:
        {
            MLActiveWebViewController *vc = [[MLActiveWebViewController alloc]init];
            vc.title = @"热门活动";
            vc.link = message.link;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PushMessageGOReturns:
        {
            MLReturnsDetailViewController *vc = [[MLReturnsDetailViewController alloc]init];
            vc.order_id = message.order_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PushMessageGOProductDetail:
        {
            MLGoodsDetailsViewController *vc =[[MLGoodsDetailsViewController alloc]init];
            vc.paramDic = @{@"id":message.pid?:@""};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

//消息按钮
- (void)newsButtonAction:(UIButton *)sender{
    NSLog(@"点击了消息按钮");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    if (loginid && ![@"" isEqualToString:loginid]) {

        [userDefaults setObject:@"0" forKey:Message_badge_num];
        self.messageBadgeView.hidden = YES;
        MLMessagesViewController *vc = [[MLMessagesViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        MLLoginViewController * loginVC = [[MLLoginViewController alloc]init];
        loginVC.isLogin = YES;
        [self presentViewController:loginVC animated:NO completion:nil];
        
    }


     
    /*
    PinPaiZLViewController * pinVC = [[PinPaiZLViewController alloc]init];
    pinVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pinVC animated:YES];
    */
    /*
    MLPayresultViewController * payResultVC = [[MLPayresultViewController alloc]init];
    payResultVC.hidesBottomBarWhenPushed = YES;
    payResultVC.isSuccess = YES;
    [self.navigationController pushViewController:payResultVC animated:YES];
     */
    /*
    MLPayShiBaiViewController * shiBaiVC = [[MLPayShiBaiViewController alloc]init];
    shiBaiVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:shiBaiVC animated:YES];
     */
    /*
    MLPayViewController *vc = [[MLPayViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.paramDic = @{@"totalFee":@"0.1",@"order_trade_no":@"1206500002698"};
    [self.navigationController pushViewController:vc animated:YES];
    */
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
    if (_isTopHiden) {
        [UIView animateWithDuration:0.0f animations:^{
            [self.view setFrame:CGRectMake(0, 0.0f, SIZE_WIDTH, SIZE_HEIGHT-49.0)];
            self.tabsView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
            self.firstTopView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
            self.currentLabel.textColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
            self.currentLabel.spView.backgroundColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
            
        } completion:^(BOOL finished) {
            _isTopHiden = NO;
            
        }];
    }

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
//二维码扫描 搜索  消息视图按钮
- (void)createNavTopView{
    self.firstTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 65)];
    self.firstTopView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [self.view addSubview:self.firstTopView];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(10, 30, 22, 19)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"shouyesaoyisao"] forState:UIControlStateNormal];
    //[leftBtn setImage:[UIImage imageNamed:@"shouyesaoyisao"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(scanning) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.firstTopView addSubview:leftBtn];
    
    /*
     UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shouyesaoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(scanning)];
     self.navigationItem.leftBarButtonItem = left;
     */
    
    //添加边框和提示
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(45, 25, MAIN_SCREEN_WIDTH-45-46, 28)] ;
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = RGBA(38, 14, 0, 0.5).CGColor;
    frameView.layer.cornerRadius = 4.f;
    frameView.layer.masksToBounds = YES;
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    NSLog(@"textW===%f",textW);
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
    
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(imgW+6, 4, textW, H)];
    searchText.enabled = NO;
    
    [frameView addSubview:searchText];
    [frameView addSubview:searchImg];
    searchImg.frame = CGRectMake(5 , 4, imgW, imgW);
    
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"寻找你想要的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    //self.navigationItem.titleView = frameView;
    [self.firstTopView addSubview:frameView];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [frameView addGestureRecognizer:singleTap];
    


    
    self.newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.newsButton setFrame:CGRectMake(SIZE_WIDTH-35, 30, 22, 19)];
    //[newsBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [self.newsButton setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [self.newsButton addTarget:self action:@selector(newsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.messageBadgeView = [[JSBadgeView alloc]initWithParentView:self.newsButton alignment:JSBadgeViewAlignmentTopRight];
    //self.messageBadgeView.badgeText = @"●";
    [self.messageBadgeView setBadgeTextColor:[HFSUtility hexStringToColor:Main_textRedBackgroundColor]];
    [self.messageBadgeView setBadgeBackgroundColor:[UIColor clearColor]];
    
    [self.firstTopView addSubview:self.newsButton];
    
    
}

//搜索器的UIView的点击事件
-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    
    MLSearchViewController *searchViewController = [[MLSearchViewController alloc]init];
    searchViewController.delegate = self;
    searchViewController.activeViewController = self;
    MLNavigationController *searchNavigationViewController = [[MLNavigationController alloc]initWithRootViewController:searchViewController];
    
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    [rootViewController addChildViewController:searchNavigationViewController];
    [rootViewController.view addSubview:searchNavigationViewController.view];
    
}
#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}

#pragma mark-SearchDelegate
-(void)SearchText:(NSString *)text{
    //    NSLog(@"%@",text);
    MLGoodsListViewController *vc =[[MLGoodsListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = text;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _titlesARR.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    ZLLabelCustom * label = [ZLLabelCustom new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    NSString * titleStr = [_titlesARR objectAtIndex:index];
    label.text = titleStr;
    //label.text = [NSString stringWithFormat:@"全球购%ld", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [HFSUtility hexStringToColor:Main_home_huise_backgroundColor];
    [label sizeToFit];
    
    [_labelARR addObject:label];
    
    label.spView  = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+21, label.frame.size.width, 1)];
    label.spView.backgroundColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
    label.spView.hidden = YES;
    [label addSubview:label.spView];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    ZLHomeSubViewController *cvc = [[ZLHomeSubViewController alloc]initWithURL:[_urlsARR objectAtIndex:index]];
    cvc.homeSubDelegate = self;
    //[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    
    //cvc.labelString = [NSString stringWithFormat:@"Content View #%ld", index];
    //[cvc createWebViewWith:@"http://www.baidu.com"];
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
  
            if (_isTopHiden) {
                color = [UIColor whiteColor];
            }
            else{
                color = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
            }

            return [UIColor clearColor];
            break;
        case ViewPagerContent:
            return [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
            break;
        case ViewPagerTabsView:
            return [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
            break;
        default:
            break;
    }
    
    return color;
}
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index{

    NSLog(@"选择了第几个：%ld",index);
    
    if (_isTopHiden) {
        for (ZLLabelCustom * lab in _labelARR) {
            lab.spView.hidden = YES;
            
            lab.textColor = [HFSUtility hexStringToColor:Main_home_huise_backgroundColor];
        }
    }
    else{
        for (ZLLabelCustom * lab in _labelARR) {
            lab.spView.hidden = YES;
            lab.textColor = [HFSUtility hexStringToColor:Main_home_huise_backgroundColor];
            
        }
    }

    
    
    ZLLabelCustom * label = (ZLLabelCustom *)[_labelARR objectAtIndex:index];
    self.currentLabel = label;
    label.spView.hidden = NO;
    NSLog(@"选择的当前的Label的frame值为：%g---%g--%g----%g",label.frame.origin.x,label.frame.origin.y,label.frame.size.width,label.frame.size.height);
    if (_isTopHiden) {
        label.textColor = [UIColor whiteColor];
        label.spView.backgroundColor = [UIColor whiteColor];
    }
    else{
        label.textColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
        label.spView.backgroundColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
    }
    
}

//请求 标题数据
- (void)getRequestTitleARR{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //NSString * urlStr = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=product&s=webframe&method=title"];
    [[HFSServiceClient sharedJSONClient] GET:HomeTitles_URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        
        NSDictionary * result = (NSDictionary *)responseObject;
        NSLog(@"请求首页标题数据：%@",result);
        NSDictionary * dataDic = result[@"data"];
        NSArray * titARR = dataDic[@"menu"];
        
        if (titARR.count > 0) {
            [_titlesARR removeAllObjects];
            [_urlsARR removeAllObjects];
            for (int i = 0; i<titARR.count; i++) {
                
                NSDictionary * titleDIC = [titARR objectAtIndex:i];
                
                NSString * name = titleDIC[@"title"];
                NSString * url = titleDIC[@"ggv"];
                [_titlesARR addObject:name];
                [_urlsARR addObject:url];
                
            }
            
            [self reloadData];
        }

        else{
            _hud  = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"没有品牌信息";
            [_hud hide:YES afterDelay:2];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _hud  = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
    }];

}

#pragma mark 二维码扫描


- (void)scanning{
    //开始捕获
    //扫描二维码
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        NSLog(@"%@",qrString);
        
        //扫除结果后处理字符串
        
        [aqrvc dismissViewControllerAnimated:NO completion:^{
            
            
            
            if (qrString.length >0) {
                NSString *idstr = [self jiexi:@"id" webaddress:qrString];
                if (idstr.length > 0 ) {
                    MLGoodsDetailsViewController *detailVc = [[MLGoodsDetailsViewController alloc]init];
                    detailVc.paramDic = @{@"id":idstr};
                    detailVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detailVc animated:YES];
                }
            }else{
                
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"加载失败";
                [_hud hide:YES afterDelay:2];
            }
            
        }];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){//扫描失败
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){//取消扫描
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
    
}


-(NSString *)jiexi:(NSString *)CS webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    // NSString *webaddress=@"http://www.baidu.com/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        //NSRange matchRange = [match range];
        //NSString *tagString = [webaddress substringWithRange:matchRange];  // 整个匹配串
        //        NSRange r1 = [match rangeAtIndex:1];
        //        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {    // 由时分组1可能没有找到相应的匹配，用这种办法来判断
        //            //NSString *tagName = [webaddress substringWithRange:r1];  // 分组1所对应的串
        //            return @"";
        //        }
        
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        //    NSLog(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return @"";
}
#pragma end 二维码扫描结束
#pragma mark JSCore  方法
/*
- (void)fourButtonAction:(NSString *)index{
    
    [self performSelectorOnMainThread:@selector(pushToGoodsDetail:) withObject:index waitUntilDone:YES];
    
}
*/
/*
- (void)pushToGoodsDetail:(NSString *)productId{
    MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *params = @{@"id":productId?:@""};
    vc.paramDic = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
*/

#pragma end mark JSCore 方法结束
#pragma mark ZLHomeSubVieDragProtocol代理方法


- (void)homeSubViewController:(ZLHomeSubViewController *)subVC JavaScriptActionFourButton:(NSString *)type withUi:(NSString *)sender{
    
    if ([type isEqualToString:@"1"]) {
        //商品
        NSDictionary *params = @{@"id":sender?:@""};
        MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
        vc.paramDic = params;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if ([type isEqualToString:@"2"]) {
        //品牌
        PinPaiSPListViewController *vc =[[PinPaiSPListViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        vc.searchString = sender;
        vc.title = @"品牌馆";
        [self.navigationController pushViewController:vc animated:NO];
        self.hidesBottomBarWhenPushed = NO;
        
    }
    if ([type isEqualToString:@"3"]) {
        //分类
        MLGoodsListViewController * vc = [[MLGoodsListViewController alloc]init];

        vc.filterParam = @{@"flid":sender};
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if ([type isEqualToString:@"4"]) {
        //链接
        //[self daKaQianDao];
        MLActiveWebViewController *vc = [[MLActiveWebViewController alloc]init];
        vc.title = @"热门活动";
        vc.link = sender;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
         
    }
    if ([type isEqualToString:@"5"]) {
        //店铺
        MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
        NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
        vc.store_link = [NSString stringWithFormat:@"%@/store?sid=%@&uid=%@",@"http://192.168.19.247:3000",sender,phone];
        NSLog(@"店铺：%@",vc.store_link);
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    if ([type isEqualToString:@"9"]) {
        //频道
        NSLog(@"点击了四个按钮：%@",sender);
        if ([sender isEqualToString:@"60"]) {
            //品牌馆
            PinPaiZLViewController * pinVC = [[PinPaiZLViewController alloc]init];
            pinVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pinVC animated:YES];
        }
        if ([sender isEqualToString:@"61"]) {
            //积分查询
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
            if (loginid && ![@"" isEqualToString:loginid]) {
                MNNMemberViewController * pinVC = [[MNNMemberViewController alloc]init];
                pinVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pinVC animated:YES];
            }
            else{
                MLLoginViewController * loginVC = [[MLLoginViewController alloc]init];
                loginVC.isLogin = YES;
                [self presentViewController:loginVC animated:NO completion:nil];
            
            }
        }
        if ([sender isEqualToString:@"62"]) {
            //打卡签到
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
            if (loginid && ![@"" isEqualToString:loginid]) {
                [self daKaQianDao];
            }
            else{
                //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(daKaQianDao) name:RENZHENG_LIJIA_Notification object:nil];
                MLLoginViewController * loginVC = [[MLLoginViewController alloc]init];
                loginVC.isLogin = YES;
                [self presentViewController:loginVC animated:NO completion:nil];
                
            }
        }
        if ([sender isEqualToString:@"63"]) {
            //城市服务
            MLActiveWebViewController *vc = [[MLActiveWebViewController alloc]init];
            vc.title = @"热门活动";
            vc.link = @"http://www.baidu.com";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    

}


- (void)homeSubViewController:(ZLHomeSubViewController *)subVC withBeginOffest:(float)haViewOffestY{
    self.historyOffestY = haViewOffestY;
    
}

- (void)homeSubViewController:(ZLHomeSubViewController *)subVC withContentOffest:(float)haViewOffestY{
    if (haViewOffestY < self.historyOffestY) {
        
        if (self.historyOffestY > haViewOffestY + 25) {
            
            if (_isTopHiden) {
                NSLog(@"down向下 动画执行");
                [UIView animateWithDuration:0.3f animations:^{
                    [self.view setFrame:CGRectMake(0, 0.0f, SIZE_WIDTH, SIZE_HEIGHT-49.0)];
                    self.tabsView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
                    self.firstTopView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
                    self.currentLabel.textColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
                    self.currentLabel.spView.backgroundColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];

                } completion:^(BOOL finished) {
                    _isTopHiden = NO;
                    
                }];
            }

            
        }
        
        
        
    } else if (haViewOffestY > self.historyOffestY) {
        
        if (haViewOffestY > self.historyOffestY + 25) {
           
            if (!_isTopHiden) {
                 NSLog(@"up向上  动画执行");
                [UIView animateWithDuration:0.3f animations:^{
                    [self.view setFrame:CGRectMake(0, -54.0f, SIZE_WIDTH, SIZE_HEIGHT-49.0+54.0)];
                    self.tabsView.backgroundColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
                    self.firstTopView.backgroundColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
                    self.currentLabel.textColor = [UIColor whiteColor];
                    self.currentLabel.spView.backgroundColor = [UIColor whiteColor];
                } completion:^(BOOL finished) {
                    _isTopHiden = YES;
                    
                }];
            }

        }
        
    }

}

#pragma mark ZLHomeSubVieDragProtocol方法结束

- (void)daKaQianDao{

    //积分查询
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    if (loginid && ![@"" isEqualToString:loginid]) {
        
        [self getQianDaoInfo];
//        MNNMemberViewController * pinVC = [[MNNMemberViewController alloc]init];
//        pinVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:pinVC animated:YES];
    }
    
}


- (void)getQianDaoInfo{

    NSDictionary * ret = @{@"sum":@"3"};
    [MLHttpManager post:QianDao_URLString params:ret m:@"member" s:@"admin_member" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"打卡签到：%@",result);
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary * dataDic = result[@"data"];
            NSString * qd_info = dataDic[@"qd_info"];
            
            if ([qd_info isEqualToString:@"1"]) {
                 [MBProgressHUD showMessag:@"今日已打卡" toView:self.view];
            }
            else{
            
                self.dakaImageView = [[UIImageView alloc]init];
                self.dakaImageView.userInteractionEnabled = YES;
                self.dakaImageView.hidden = NO;
                self.dakaImageView.image = [UIImage imageNamed:@"Sun"];
                
                [self.view addSubview:self.dakaImageView];
                
                [self.dakaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.view);
                    make.centerY.mas_equalTo(self.view).offset(-30);
                    make.size.mas_equalTo(CGSizeMake(213, 38));
                }];
                [self performSelector:@selector(hideDakaImageView) withObject:self afterDelay:1.0f];
            }
        }
        else{
            [MBProgressHUD showMessag:@"今日已打卡" toView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"打卡签到错误：%@",error);
        [MBProgressHUD showMessag:REQUEST_ERROR_ZL toView:self.view];
    }];
        

}
- (void)hideDakaImageView{

    self.dakaImageView.hidden = YES;
}

- (void)getMessageDataSource{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=message_center",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"push" s:@"message_center" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *list = data[@"list"];
            if (list.count > 0) {
                self.messageBadgeView.badgeText = @"●";
                
                NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:@"1" forKey:Message_badge_num];
                
            }
            else{
                self.messageBadgeView.hidden = YES;
                NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:@"0" forKey:Message_badge_num];
            }
        }else{
            NSString *msg = result[@"msg"];
            self.messageBadgeView.hidden = YES;
            NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:@"0" forKey:Message_badge_num];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
       
    } failure:^(NSError *error) {
        self.messageBadgeView.hidden = YES;
        NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:@"0" forKey:Message_badge_num];
        [MBProgressHUD showSuccess:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
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

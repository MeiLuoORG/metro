//
//  ZLHomezlViewController.m
//  Matro
//
//  Created by lang on 16/7/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ZLHomezlViewController.h"

@interface ZLHomezlViewController ()

@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property (strong, nonatomic) ZLLabelCustom * currentLabel;

@end

@protocol HomeJSObjectDelegate <JSExport>

- (void)fourButtonAction:(NSString *)index;

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
    /*
    PinPaiZLViewController * pinVC = [[PinPaiZLViewController alloc]init];
    pinVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pinVC animated:YES];
    */
    
    MLPayresultViewController * payResultVC = [[MLPayresultViewController alloc]init];
    payResultVC.hidesBottomBarWhenPushed = YES;
    payResultVC.isSuccess = YES;
    [self.navigationController pushViewController:payResultVC animated:YES];
     
    /*
    MLPayShiBaiViewController * shiBaiVC = [[MLPayShiBaiViewController alloc]init];
    shiBaiVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:shiBaiVC animated:YES];
*/
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (_isTopHiden) {
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
    
    UIButton * newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsBtn setFrame:CGRectMake(SIZE_WIDTH-35, 30, 22, 19)];
    //[newsBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [newsBtn setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [newsBtn addTarget:self action:@selector(newsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstTopView addSubview:newsBtn];
    
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
            
            /*
             if (qrString.length>0) {
             NSString *JMSP_ID = [self jiexi:@"JMSP_ID" webaddress:qrString];
             NSString *ZCSP = nil;
             if([qrString rangeOfString:@"products_hwg"].location !=NSNotFound)//_roaldSearchText
             {
             ZCSP = @"5";
             }
             else
             {
             ZCSP = @"0";
             }
             
             if (JMSP_ID.length>0&&ZCSP) {
             MLGoodsDetailsViewController *detailVc = [[MLGoodsDetailsViewController alloc]init];
             detailVc.paramDic = @{@"JMSP_ID":JMSP_ID?:@"",@"ZCSP":ZCSP};
             detailVc.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:detailVc animated:YES];
             }
             
             
             }
             */
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
- (void)homeSubViewController:(ZLHomeSubViewController *)subVC JavaScriptActionFourButton:(NSString *)index{
    NSLog(@"点击了四个按钮：%@",index);
    if ([index isEqualToString:@"60"]) {
        PinPaiZLViewController * pinVC = [[PinPaiZLViewController alloc]init];
        pinVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pinVC animated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

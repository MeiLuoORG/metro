//
//  MLHomeViewController.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLLoginViewController.h"
#import "MLSearchViewController.h"
#import "MLGoodsListViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MMMaterialDesignSpinner.h"
#import "MyJSInterface.h"
#import "EasyJSWebView.h"
#import "HFSUtility.h"
#import "MLGoodsDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YMNavigationController.h"
#import "SYQRCodeViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLPushMessageModel.h"
#import "MJExtension.h"
#import "MLActiveWebViewController.h"
#import "MLReturnsDetailViewController.h"
#import "MLGoodsDetailsViewController.h"


#import "HACursor.h"
#import "UIView+Extension.h"
#import "HATestView.h"



#define kDefaultTabHeight 44.0 // Default tab height
#define kDefaultTabOffset 56.0 // Offset of the second and further tabs' from left
#define kDefaultTabWidth 128.0

#define kDefaultTabLocation 1.0 // 1.0: Top, 0.0: Bottom

#define kDefaultStartFromSecondTab 0.0 // 1.0: YES, 0.0: NO

#define kDefaultCenterCurrentTab 0.0 // 1.0: YES, 0.0: NO

#define kPageViewTag 34

#define kDefaultIndicatorColor [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
#define kDefaultTabsViewBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:0.75]
#define kDefaultContentViewBackgroundColor [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:0.75]

// TabView for tabs, that provides un/selected state indicators
@class TabView;

@interface TabView : UIView
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) UIColor *indicatorColor;
@end

@implementation TabView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    // Update view as state changed
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    
    // Draw top line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, 0.0)];
    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    // Draw bottom line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.0, rect.size.height)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    // Draw an indicator line if tab is selected
    if (self.selected) {
        
        bezierPath = [UIBezierPath bezierPath];
        
        // Draw the indicator
        [bezierPath moveToPoint:CGPointMake(0.0, rect.size.height - 1.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height - 1.0)];
        [bezierPath setLineWidth:5.0];
        [self.indicatorColor setStroke];
        [bezierPath stroke];
    }
}
@end


@protocol HomeJSObjectDelegate <JSExport>

- (void)fourButtonAction:(NSString *)index;

@end
//JSInterfaceDelegate
@interface MLHomeViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate,SearchDelegate,UIWebViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,HomeJSObjectDelegate,HATopDragProtocol,ViewPagerDataSource, ViewPagerDelegate,UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIScrollViewDelegate>//用于处理采集信息的代理
{
    AVCaptureSession * session;//输入输出的中间桥梁
    NSString *version;
    NSString *loadversion;
    NSString *downlink;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
//@property (strong, nonatomic) UIWebView * webView;
@property(nonatomic,strong)JSContext *contextjs;
//搜索
@property (strong, nonatomic) UISearchBar *searchBar;

@property(nonatomic,strong)UIView *searchView;

@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *loadingSpinner;
@property (weak, nonatomic) IBOutlet UIView *loadingBGView;
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionlab;
@property (weak, nonatomic) IBOutlet UILabel *gengxinlab;

@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic,strong)MyJSInterface *interface;

@property (strong, nonatomic) UIView * firstTopView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *pageViews;

@property (strong, nonatomic) HACursor * cursor;

@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;

@property UIScrollView *tabsView;
@property UIView *contentView;

@property NSMutableArray *tabs;
@property NSMutableArray *contents;

@property NSUInteger tabCount;
//@property (getter = isAnimatingToTab, assign) BOOL animatingToTab;
@property (assign, nonatomic) BOOL animatingToTab;
@property (nonatomic) NSUInteger activeTabIndex;

@end

@implementation MLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    //[self getVersion];
    //[self loadVersion];
    self.versionView.hidden = YES;
    self.versionView.layer.cornerRadius = 4.f;
    self.versionView.layer.masksToBounds = YES;
    self.downBtn.layer.cornerRadius = 4.f;
    self.downBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 4.f;
    self.cancelBtn.layer.masksToBounds = YES;
    

    

    

    
    _loadingSpinner.tintColor = [HFSUtility hexStringToColor:@"#ae8e5d"];
    _loadingSpinner.lineWidth = 5;


    
    [_loadingBGView removeFromSuperview];
    

    /*
    NSString *path = [[DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:ZIP_FILE_NAME] stringByAppendingPathComponent:@"home_html/index.html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    */
    //HomeHTML_URLString
    /*
    NSURL * url2 = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3000];
    self.webView.frame = CGRectMake(0, 109, SIZE_WIDTH, SIZE_HEIGHT-109-49);
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.webView loadRequest:request];
    */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessage:) name:@"PUSHMESSAGE" object:nil];
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (del.pushMessage) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:del.pushMessage userInfo:nil];
    }
    //加载搜索 头部
    //[self createNavTopView];
    //[self createTitleNavTopView];

    //注册通知  按钮切换
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(homeViewButtonIndexNotification:) name:HOMEVIEW_BUTTON_INDEX_NOTIFICATION object:nil];
    self.currentOffestY = 0.0f;//当前位移
    

    
}
- (void)createNavTopView{
    self.firstTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 104)];
    self.firstTopView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [self.view addSubview:self.firstTopView];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(10, 30, 22, 19)];
    //[leftBtn setImage:[UIImage imageNamed:@"shouyesaoyisao"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"shouyesaoyisao"] forState:UIControlStateNormal];
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
    [newsBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [newsBtn addTarget:self action:@selector(newsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstTopView addSubview:newsBtn];
    
}

//消息按钮
- (void)newsButtonAction:(UIButton *)sender{
    NSLog(@"点击了消息按钮");

}

#pragma mark加载网页
- (void)createWebView{

    

}

#pragma mark 头部 导航条




- (void)createTitleNavTopView{

    //不允许有重复的标题
    self.titles = @[@"首页",@"全球购",@"美罗百货",@"婴天童地",@"搜狐",@"淘宝",@"京东",@"百度",@"有道",@"小米",@"华为",@"三星"];
    
    self.cursor = [[HACursor alloc]init];
    self.cursor.frame = CGRectMake(0, 64, SIZE_WIDTH, 40);
    self.cursor.titles = self.titles;
    self.cursor.pageViews = [self createPageViews];
    //设置根滚动视图的高度
    self.cursor.rootScrollViewHeight = SIZE_HEIGHT - 104 - 49;
    //默认值是白色197 159 142
    self.cursor.titleNormalColor = [UIColor colorWithRed:197.0f/255.0f green:159.0f/255.0f blue:142.0f/255.0f alpha:1.0];
    self.cursor.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    //默认值是白色
    self.cursor.titleSelectedColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    self.cursor.showSortbutton = YES;
    //默认的最小值是5，小于默认值的话按默认值设置
    self.cursor.minFontSize = 15;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    self.cursor.maxFontSize = 15;
    self.cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    //cursor.isGraduallyChangColor = NO;
    [self.cursor setShowSortbutton:NO];

    [self.view addSubview:self.cursor];
    
    //UIView * secondView = [UIView alloc]initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);

}

- (NSMutableArray *)createPageViews{
    self.pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        HATestView *textView = [[HATestView alloc]initWithFrame:CGRectMake(0, 104, SIZE_WIDTH, SIZE_HEIGHT)];
        textView.offestYDelegate = self;
        //textView.label.text = self.titles[i];
        //[textView createWebViewWith:@"http://www.baidu.com"];
        [self.pageViews addObject:textView];
    }

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleSingleTap:) name:@"PushToSearchCenter" object:nil];
    return self.pageViews;
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
#pragma end mark 头部导航条 结束

#pragma mark 接收按钮 切换按钮通知
- (void)homeViewButtonIndexNotification:(NSNotification *)sender{

    NSString * tagString = sender.userInfo[@"tag"];
    int tag = [tagString intValue];
    NSLog(@"首页点击了第几个按钮：%d",tag);
    HATestView * textView = (HATestView *)[self.pageViews objectAtIndex:tag];
    //http://www.baidu.com
    [textView createWebViewWith:@"http://61.155.212.146:3000/index/"];
}


/*
#pragma mark UIScrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll方法");
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{

    NSLog(@"scrollViewDidZoom");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScrollToTop");
}
*/

#pragma end UIScrollView代理方法结束

#pragma mark HATestViewDelegate代理方法

- (void)hatestView:(HATestView *)haView withBeginOffest:(float)haViewOffestY{
    self.currentOffestY = haViewOffestY;

}

- (void)hatestView:(HATestView *)haView withContentOffest:(float)haViewOffestY{
    
/*
    if (haViewOffestY < 54.0f && haViewOffestY > 0) {
        self.currentOffestY = haViewOffestY;
        NSLog(@"打印haViewOffestY值为：%g",haViewOffestY);
        //[self.firstTopView setFrame:CGRectMake(0, 0.0-haViewOffestY, SIZE_WIDTH, 64.0f)];
        //[self.cursor setFrame:CGRectMake(0, 64.0-haViewOffestY, SIZE_WIDTH, 40.0f)];
        //CGPoint points = CGPointMake(0, 0.0-haViewOffestY);
        self.view.frame = CGRectMake(0, 0.0-haViewOffestY, SIZE_WIDTH, SIZE_HEIGHT+haViewOffestY);
    }
    else if (haViewOffestY < 0){
        if (self.currentOffestY < 54.0 && self.currentOffestY  > 0) {
            self.currentOffestY = self.currentOffestY+haViewOffestY;
            self.view.frame = CGRectMake(0, self.currentOffestY+haViewOffestY, SIZE_WIDTH, SIZE_HEIGHT+haViewOffestY);
            
        }
    
    
    }*/
    
     //historyY = scrollView.contentOffset.y;
     
     if (haViewOffestY < self.currentOffestY) {
    
         if (self.currentOffestY > haViewOffestY + 25) {
           NSLog(@"down向下 动画执行");
             [UIView animateWithDuration:0.3f animations:^{
                 self.view.frame = CGRectMake(0, 0.0f, SIZE_WIDTH, SIZE_HEIGHT);
                 haView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT);
                 haView.webView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT);
                 self.cursor.rootScrollViewHeight = self.cursor.rootScrollViewHeight-54.0f;
             } completion:^(BOOL finished) {
                 
             }];
             
         }
         
         
     
     } else if (haViewOffestY > self.currentOffestY) {
    
         if (haViewOffestY > self.currentOffestY + 25) {
              NSLog(@"up向上  动画执行");
             [UIView animateWithDuration:0.3f animations:^{
                 self.view.frame = CGRectMake(0, -54.0f, SIZE_WIDTH, SIZE_HEIGHT+54.0f);
                 haView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT+54.0f);
                 haView.webView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT+54.0f);
                 self.cursor.rootScrollViewHeight = self.cursor.rootScrollViewHeight+54.0f;
             } completion:^(BOOL finished) {
                 
             }];
         }
     
     }

}

#pragma end mark

#pragma mark 第二次 创建头部

#pragma mark 头部导航 第二次 代理方法




#pragma end mark



- (IBAction)actCancel:(id)sender {
    self.versionView.hidden = YES;
}

- (IBAction)actDown:(id)sender {
    NSLog(@"去下载downlink===%@",downlink);
    self.versionView.hidden = YES;
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/su-zhou-mei-luo-jing-pin/id1112037018?mt=8"];
    [[UIApplication sharedApplication]openURL:url];
    
    
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
                     loadversion = result[@"data"][@"sel_info"][@"appverison"];
                     downlink = result[@"data"][@"sel_info"][@"download_link"];
                     NSLog(@"version===%@ loadversion===%@ downlink===%@",version, loadversion,downlink);
                     
                     if (version < loadversion) {
                         
                         self.versionView.hidden = NO;
                         NSString *labstr = result[@"data"][@"sel_info"][@"version_desc"];
                         self.gengxinlab.text = [NSString stringWithFormat:@"1.%@\n\n2.%@\n\n3.%@\n\n4.%@\n\n5.%@",labstr,labstr,labstr,labstr,labstr];
                         self.versionlab.text = [NSString stringWithFormat:@"美罗全球精品购V%@",loadversion];
                     }
                     
                 }
                 NSLog(@"请求成功 result====%@",result);
        
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"请求失败 error===%@",error);
                 
             }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
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

#pragma js点击回调

#pragma mark WebView的代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"网页开始加载");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.contextjs = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.contextjs[@"_native"] = self;
    self.contextjs.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"JavaScript异常信息：%@", exceptionValue);
    };
    [_loadingSpinner stopAnimating];
    self.loadingBGView.hidden = YES;
    [_hud hide:YES];
}


- (void)storeCollectClick:(BOOL)type{
    NSLog(@"是否执行了 %@",type?@"执行":@"未执行");
}


- (void)fourButtonAction:(NSString *)index{
    
     [self performSelectorOnMainThread:@selector(pushToGoodsDetail:) withObject:index waitUntilDone:YES];
    
}

- (void)pushToGoodsDetail:(NSString *)index{

    NSLog(@"点击了品牌馆:%@",index);
    if ([index isEqualToString:@"60"]) {
        PinPaiZLViewController * pinVC = [[PinPaiZLViewController alloc]init];
        pinVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pinVC animated:YES];
    }


}


/*
- (void)homeAction:(NSDictionary*)paramdic
{
    MLGoodsDetailsViewController *vc = [MLGoodsDetailsViewController new];
     vc.hidesBottomBarWhenPushed = YES;
    vc.paramDic = paramdic;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)homeChannerClick:(NSDictionary *)paramdic{

    NSLog(@"点击了");
}

- (void)navFloorAction:(NSString *)params{
    MLGoodsListViewController *vc = [[MLGoodsListViewController alloc]init];
    vc.searchString = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction{
    YMNavigationController *nvc =[[YMNavigationController alloc]initWithRootViewController:[[MLLoginViewController alloc]init]];
        [self presentViewController:nvc animated:YES completion:^{
    
        }];


}



#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
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

#pragma mark-SearchDelegate
-(void)SearchText:(NSString *)text{
//    NSLog(@"%@",text);
    MLGoodsListViewController *vc =[[MLGoodsListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = text;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

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




#pragma mark- UIWebViewDelegate

/*
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
 
}
*/

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadingBGView.hidden = YES;
    [_loadingSpinner stopAnimating];
    NSLog(@"didFailLoadWithError:%@", error);
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"加载失败";
    [_hud hide:YES afterDelay:2];
}


//查看是否有更新
#pragma mark - 应用市场

- (NSString*)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version===%@",version);
    return version;
}

- (void)appStore_openApp
{
    
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",
                     @"1023257602"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end

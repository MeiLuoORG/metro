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

@protocol HomeJSObjectDelegate <JSExport>

- (void)fourButtonAction:(NSString *)index;

@end
//JSInterfaceDelegate
@interface MLHomeViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate,SearchDelegate,UIWebViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,HomeJSObjectDelegate,UIScrollViewDelegate>//用于处理采集信息的代理
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


@end

@implementation MLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getVersion];
    [self loadVersion];
    self.versionView.hidden = YES;
    self.versionView.layer.cornerRadius = 4.f;
    self.versionView.layer.masksToBounds = YES;
    self.downBtn.layer.cornerRadius = 4.f;
    self.downBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 4.f;
    self.cancelBtn.layer.masksToBounds = YES;
    
    
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shouyesaoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(scanning)];

    self.navigationItem.leftBarButtonItem = left;

    //添加边框和提示
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)] ;
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = RGBA(38, 14, 0, 0.5).CGColor;
    frameView.layer.cornerRadius = 4.f;
    frameView.layer.masksToBounds = YES;
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    NSLog(@"textW===%f",textW);
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
    
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(6, 4, textW, H)];
    searchText.enabled = NO;
    
    [frameView addSubview:searchText];
    [frameView addSubview:searchImg];
    searchImg.frame = CGRectMake(textW - 58 , 4, imgW, imgW);
    
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"寻找你想要的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    self.navigationItem.titleView = frameView;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [frameView addGestureRecognizer:singleTap];
    
    _loadingSpinner.tintColor = [HFSUtility hexStringToColor:@"#ae8e5d"];
    _loadingSpinner.lineWidth = 5;


    
    [_loadingBGView removeFromSuperview];
    
    /*
    _interface = [MyJSInterface new];
    
    _interface.delegate = self;
    */
    //[self.webView addJavascriptInterfaces:_interface WithName:@"_native"];
    //self.webView.delegate = self;
    NSString *path = [[DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:ZIP_FILE_NAME] stringByAppendingPathComponent:@"home_html/index.html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURL * url2 = [NSURL URLWithString:HomeHTML_URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3000];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.webView loadRequest:request];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessage:) name:@"PUSHMESSAGE" object:nil];
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    if (del.pushMessage) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:del.pushMessage userInfo:nil];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleSingleTap:) name:@"PushToSearchCenter" object:nil];
    
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

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


#pragma end UIScrollView代理方法结束


- (IBAction)actCancel:(id)sender {
    self.versionView.hidden = YES;
}

- (IBAction)actDown:(id)sender {
    NSLog(@"去下载");
    
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
                     NSLog(@"version===%@ loadversion===%@",version, loadversion);
                     
                     if (version < loadversion) {
                         
                         self.versionView.hidden = NO;
                         NSString *labstr = result[@"data"][@"sel_info"][@"version_desc"];
                         self.gengxinlab.text = [NSString stringWithFormat:@"1.%@\n\n2.%@",labstr,labstr];
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

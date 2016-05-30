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

@interface MLHomeViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate,SearchDelegate,UIWebViewDelegate,JSInterfaceDelegate,AVCaptureMetadataOutputObjectsDelegate>//用于处理采集信息的代理
{
    AVCaptureSession * session;//输入输出的中间桥梁
}

@property (strong, nonatomic) IBOutlet EasyJSWebView *webView;
//搜索
@property (strong, nonatomic) UISearchBar *searchBar;

@property(nonatomic,strong)UIView *searchView;

@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *loadingSpinner;
@property (weak, nonatomic) IBOutlet UIView *loadingBGView;

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


    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shouyesaoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(scanning)];
    
    
    
    self.navigationItem.leftBarButtonItem = left;
    
    

    //添加边框和提示
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)] ;
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;

    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Magnifying-Class"]];
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(imgW + 4, 2, textW, H)];
    searchText.enabled = NO;
    [frameView addSubview:searchImg];
    [frameView addSubview:searchText];
    searchImg.frame = CGRectMake(4 , 4, imgW, imgW);
    searchText.frame = CGRectMake(imgW + 6, 4, textW, H);
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"寻找你想要的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    self.navigationItem.titleView = frameView;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [frameView addGestureRecognizer:singleTap];
    
    _loadingSpinner.tintColor = [HFSUtility hexStringToColor:@"#ae8e5d"];
    _loadingSpinner.lineWidth = 5;


    
    [_loadingBGView removeFromSuperview];
    
    _interface = [MyJSInterface new];
    
    _interface.delegate = self;
    [self.webView addJavascriptInterfaces:_interface WithName:@"_native"];
    NSString *path = [[DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:ZIP_FILE_NAME] stringByAppendingPathComponent:@"home_html/index.html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3000];
    [self.webView loadRequest:request];
    

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}


#pragma js点击回调
- (void)homeAction:(NSDictionary*)paramdic
{
    MLGoodsDetailsViewController *vc = [MLGoodsDetailsViewController new];
     vc.hidesBottomBarWhenPushed = YES;
    vc.paramDic = paramdic;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)navFloorAction:(NSString *)params{
    MLGoodsListViewController *vc = [[MLGoodsListViewController alloc]init];
    vc.searchString = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




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
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadingSpinner stopAnimating];
    self.loadingBGView.hidden = YES;
    
    
    [_hud hide:YES];
}
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
@end

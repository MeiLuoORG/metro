//
//  MLHelpCenterDetailController.m
//  Matro
//
//  Created by MR.Huang on 16/5/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLHelpCenterDetailController.h"
#import "HFSServiceClient.h"
#import "Masonry.h"
#import "CommonHeader.h"
#import "MLHttpManager.h"
@interface MLHelpCenterDetailController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation MLHelpCenterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });

    NSLog(@"currentthread==%@",[NSThread currentThread]);
    [self getWebContent];
    
    
}

- (void)getWebContent{

    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=help&s=index&id=%@&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,_webCode?:@"",vCFBundleShortVersionStr];
    
    NSLog(@"%@",urlStr);
    
    [MLHttpManager get:urlStr params:nil m:@"help" s:@"index" success:^(id responseObject){
        NSLog(@"responseObject==%@",responseObject);
        
        NSDictionary *result = [responseObject objectForKey:@"data"];
        NSNumber *resultCode = [responseObject objectForKey:@"code"];
        
        if ([resultCode isEqual:@0]) {
            NSDictionary *dic = [result objectForKey:@"help_info"];
            NSString *title = [dic objectForKey:@"con_title"];
            NSString *htmlCode = [dic objectForKey:@"con_desc"];
            self.navigationItem.title = title;
            [_webView loadHTMLString:htmlCode baseURL:nil];
        }
        else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"暂无数据";
            [_hud hide:YES afterDelay:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        
        NSDictionary *result = [responseObject objectForKey:@"data"];
        NSNumber *resultCode = [responseObject objectForKey:@"code"];
        
        if ([resultCode isEqual:@0]) {
            NSDictionary *dic = [result objectForKey:@"help_info"];
            NSString *title = [dic objectForKey:@"con_title"];
            NSString *htmlCode = [dic objectForKey:@"con_desc"];
            self.navigationItem.title = title;
            [_webView loadHTMLString:htmlCode baseURL:nil];
        }
        else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"暂无数据";
            [_hud hide:YES afterDelay:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    */
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myimg,oldwidth;"
                                                     "var maxwidth=%f;" //缩放系数
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myimg = document.images[i];"
                                                     "if(myimg.width > maxwidth){"
                                                     "oldwidth = myimg.width;"
                                                     "myimg.width = maxwidth;"
                                                     "myimg.height = myimg.height * (maxwidth/oldwidth);"
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);",MAIN_SCREEN_WIDTH]
     ];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
}


@end

//
//  MLHelpCenterDetailController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLHelpCenterDetailController.h"
#import "HFSServiceClient.h"
#import "Masonry.h"

@interface MLHelpCenterDetailController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation MLHelpCenterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });

    
    
    [self getWebContent];
    
    
}

- (void)getWebContent{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://61.155.212.164/SPGL/Page_Base/NRGL/WebFrameEdit/INFO/DefineInfoitem_h.ashx?op=infoitem&page=1&webframecode=%@&rows=10",_webCode?:@""];
    
    NSLog(@"%@",urlStr);
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *result = [responseObject objectForKey:@"rows"];
        NSNumber *resultCode = [responseObject objectForKey:@"total"];
        
        if (resultCode.integerValue>0) {
            NSDictionary *dic = [result objectAtIndex:0];
            NSString *title = [dic objectForKey:@"TITLE"];
            NSString *htmlCode = [dic objectForKey:@"CONTENT"];
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

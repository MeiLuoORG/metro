//
//  MLActiveWebViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLActiveWebViewController.h"
#import "CommonHeader.h"
@interface MLActiveWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation MLActiveWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-64)];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.link]];
    [self.webView loadRequest:request];
}
- (void)skip:(NSString *)index Ui:(NSString *)sender{
    NSLog(@"JS传入index:%@++++sender:%@",index,sender);
    /*
     dispatch_sync(dispatch_get_main_queue(), ^{
     [self pushToGoodsDetail:index withUi:sender];
     });
     */
    
    if (index != nil && sender != nil && ![index isEqualToString:@""] && ![sender isEqualToString:@""]) {
        NSArray * arr = @[index,sender];
        [self performSelectorOnMainThread:@selector(pushTest:) withObject:arr waitUntilDone:YES];
    }
    
}
- (void)pushTest:(NSArray *)senderARR{
    
    NSString * index = senderARR[0];
    NSString * sender = senderARR[1];
    NSLog(@"数组中index:%@,sender:%@",index,sender);
//    if (self.homeSubDelegate && [self.homeSubDelegate respondsToSelector:@selector(homeSubViewController:JavaScriptActionFourButton:withUi:)]) {
//        [self.homeSubDelegate homeSubViewController:self JavaScriptActionFourButton:index withUi:sender];
//    }
    if ([index isEqualToString:@"1"]) {
        //商品
        NSDictionary *params = @{@"id":sender?:@""};
        MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
        vc.paramDic = params;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.contextjs = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.contextjs[@"_native"] = self;
    self.contextjs.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"JavaScript异常信息：%@", exceptionValue);
    };
    [self closeLoadingView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}


@end

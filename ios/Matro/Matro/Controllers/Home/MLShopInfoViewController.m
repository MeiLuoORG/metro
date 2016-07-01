//
//  MLShopInfoViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopInfoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HFSConstants.h"
#import "MLGoodsDetailsViewController.h"

@protocol JSObjectDelegate <JSExport>
- (void)navigationStoreProduct:(NSString *)productId;

@end

@interface MLShopInfoViewController ()<UIWebViewDelegate,JSObjectDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)JSContext *context;

@end

@implementation MLShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"店铺详情";
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    NSString *url = [NSString stringWithFormat:@"%@/h5/store.index.html",MATROJP_BASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"_native"] = self;
//    self.context[@"storeProductClick"] = ^(NSString *productid,NSString *type){
//        NSLog(@"%@   %@",productid,type);
//    };
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}



- (void)navigationStoreProduct:(NSString *)productId{
    [self performSelectorOnMainThread:@selector(pushToGoodsDetail:) withObject:productId waitUntilDone:YES];
}

- (void)storeProductClick:(NSString *)productId{
    NSLog(@"%@",productId);
}



- (void)pushToGoodsDetail:(NSString *)productId{
    MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *params = @{@"id":productId?:@""};
    vc.paramDic = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

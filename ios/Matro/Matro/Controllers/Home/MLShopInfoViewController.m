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
#import "Masonry.h"

@protocol JSObjectDelegate <JSExport>
- (void)navigationProduct:(NSString *)productId;
- (void)skipPage:(NSString *)url;
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
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    NSString *url = [NSString stringWithFormat:@"http://61.155.212.146:3000/store/index?sid=20505&uid=1111"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"_native"] = self;
    __weak typeof(self) weakself = self;
    self.context[@"skipUi"] = ^(NSString *productid){
        NSLog(@"%@",productid);
//            [weakself performSelectorOnMainThread:@selector(collectClick:) withObject:productid waitUntilDone:YES];
    };
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}



- (void)navigationProduct:(NSString *)productId{
    
    [self performSelectorOnMainThread:@selector(pushToGoodsDetail:) withObject:productId waitUntilDone:YES];
}


- (void)collectClick:(NSString *)collectId{
    NSLog(@"%@",collectId);
}

- (void)storeProductClick:(NSString *)productId{
    NSLog(@"%@",productId);
}


- (void)skipPage:(NSString *)url{
    NSLog(@"%@",url);
}


- (void)pushToGoodsDetail:(NSString *)productId{
    MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *params = @{@"id":productId?:@""};
    vc.paramDic = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  MLShopDetailViewController.m
//  Matro
//
//  Created by Matro on 16/7/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopDetailViewController.h"
#import "Masonry.h"
@interface MLShopDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation MLShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

   // NSString *url = [NSString stringWithFormat:@"%@/store/detailed?sid=%@",HomeHTML_URLString,_storeid];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlstr]];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

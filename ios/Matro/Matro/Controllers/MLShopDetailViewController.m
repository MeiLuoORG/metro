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
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];


   // NSString *url = [NSString stringWithFormat:@"%@/store/detailed?sid=%@",HomeHTML_URLString,_storeid];
    
//    [self performSelector:@selector(getWebView) withObject:self afterDelay:1.0f];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlstr]];
    [self.webView loadRequest:request];
}

-(void)getWebView{
    
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

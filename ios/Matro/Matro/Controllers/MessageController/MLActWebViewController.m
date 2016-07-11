//
//  MLActWebViewController.m
//  Matro
//
//  Created by MR.Huang on 16/7/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLActWebViewController.h"

@interface MLActWebViewController ()
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation MLActWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        webView;
    });
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.link]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

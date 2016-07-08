//
//  ZLHomeSubViewController.m
//  Matro
//
//  Created by lang on 16/7/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ZLHomeSubViewController.h"


@interface ZLHomeSubViewController ()

@end




@implementation ZLHomeSubViewController


- (instancetype)initWithURL:(NSString * )urlStr{

    self = [super init];
    if (self) {
        self.urlstr = urlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT);
    // Do any additional setup after loading the view from its nib.
    [self loadWebView];
}

- (void)loadWebView{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-49.0-40.0)];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    [self createWebViewWith:self.urlstr];

}
//创建 webView
- (void)createWebViewWith:(NSString *)urlString{
    
    
    
    NSURL * url2 = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3000];
    [self.webView loadRequest:request];
}

#pragma mark WebView代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"HATestView.h网页开始加载");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
  
    
    
    NSLog(@"HATestView.h网页完成加载");
    self.contextjs = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.contextjs[@"_native"] = self;
    self.contextjs.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"JavaScript异常信息：%@", exceptionValue);
    };
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"HATestView.h网页加载错误：%@",error);
    
}

#pragma end mark

#pragma mark UIScrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidScroll方法:%g",scrollView.contentOffset.y);
    if (self.homeSubDelegate && [self.homeSubDelegate respondsToSelector:@selector(homeSubViewController:withContentOffest:)]) {
        [self.homeSubDelegate homeSubViewController:self withContentOffest:scrollView.contentOffset.y];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    if (self.homeSubDelegate && [self.homeSubDelegate respondsToSelector:@selector(homeSubViewController:withBeginOffest:)]) {
        [self.homeSubDelegate homeSubViewController:self withBeginOffest:scrollView.contentOffset.y];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"结束拖拽");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark JS回调方法

- (void)skip:(NSString *)index Ui:(NSString *)sender{
    
    NSLog(@"点击了网页：%@++++++%@",index,sender);
    //[self performSelectorOnMainThread:@selector(pushToGoodsDetail:withUi:) withObject:index waitUntilDone:YES];
    dispatch_sync(dispatch_get_main_queue(), ^{
       
        [self pushToGoodsDetail:index withUi:sender];
        
    });
}

- (void)pushToGoodsDetail:(NSString *)index withUi:(NSString *)sender{
    
    if (self.homeSubDelegate && [self.homeSubDelegate respondsToSelector:@selector(homeSubViewController:JavaScriptActionFourButton:withUi:)]) {
        [self.homeSubDelegate homeSubViewController:self JavaScriptActionFourButton:index withUi:sender];
    }
    
    
}

#pragma end mark JS回调方法结束
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

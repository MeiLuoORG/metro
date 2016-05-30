//
//  MLTermViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/5/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTermViewController.h"

@interface MLTermViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *termWebview;

@end

@implementation MLTermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSURL *url = [[NSURL alloc]initWithString:@"http://www.matrojp.com/Bzzx/BzzxPage.aspx?code=0103010901"];
//    
//    [_termWebview loadRequest:[NSURLRequest requestWithURL:url]];
    self.title = @"用户协议";
    NSString* path = [[NSBundle mainBundle] pathForResource:@"declare" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [self.termWebview loadRequest:request];


//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"term" ofType:@"html"];
//    self.title = @"美罗全球购注册协议";
//    NSString *body = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [_termWebview loadHTMLString:body baseURL:nil];
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

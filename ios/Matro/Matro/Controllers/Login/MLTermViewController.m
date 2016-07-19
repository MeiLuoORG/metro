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
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadTopView];
    self.title = @"用户协议";
    //NSString* path = [[NSBundle mainBundle] pathForResource:@"declare" ofType:@"html"];
    //NSURL* url = [NSURL fileURLWithPath:path];
    //NSURL * urlStr = [NSURL URLWithString:ZHUCEXIEYI_URLString];
    //NSURLRequest* request = [NSURLRequest requestWithURL:urlStr] ;
    //[self.termWebview loadRequest:request];


//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"term" ofType:@"html"];
//    self.title = @"美罗全球购注册协议";
//    NSString *body = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [_termWebview loadHTMLString:body baseURL:nil];
    //m=setinfo&s=setinfo
    [MLHttpManager get:ZHUCEXIEYI_URLString params:nil m:@"setinfo" s:@"setinfo" success:^(id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        
        NSDictionary *result = [responseObject objectForKey:@"data"];
        NSNumber *resultCode = [responseObject objectForKey:@"code"];
        
        if ([resultCode isEqual:@0]) {
            NSString *dic = [result objectForKey:@"ret"];
            [self.termWebview loadHTMLString:dic baseURL:nil];
        }
        else{
            
        }
    } failure:^(NSError *error) {
        
    }];


}
- (void)loadTopView{
    NavTopCommonImage * navTop = [[NavTopCommonImage alloc]initWithTitle:@"用户协议"];
    [navTop loadLeftBackButtonwith:0];
    [navTop backButtonAction:^(BOOL succes) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:navTop];

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

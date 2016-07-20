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
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-49.0-60.0)];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self createWebViewWith:self.urlstr];
    UIImage * image1 = [UIImage imageNamed:@"0001"];
    UIImage * image2 = [UIImage imageNamed:@"0002"];
    UIImage * image3 = [UIImage imageNamed:@"0003"];
    UIImage * image4 = [UIImage imageNamed:@"0004"];
    UIImage * image5 = [UIImage imageNamed:@"0005"];
    UIImage * image6 = [UIImage imageNamed:@"0006"];
    NSArray * arr = @[image1,image2,image3,image4,image5,image6];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置普通状态的动画图片 (idleImages 是图片)
    [header setImages:arr forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:arr forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:arr forState:MJRefreshStateRefreshing];
    // 设置header
    //self.webView.scrollView.header = header;

}
- (void)loadNewData{
    [self.webView reload];
}

//创建 webView
- (void)createWebViewWith:(NSString *)urlString{
    
    
    NSLog(@"加载的URL为：%@",urlString);
    NSURL * url2 = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3000];
    [self.webView loadRequest:request];
}

#pragma mark WebView代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"HATestView.h网页开始加载");
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
  
    
    //[webView.scrollView.header endRefreshing];
    NSLog(@"HATestView.h网页完成加载");
    self.contextjs = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.contextjs[@"_native"] = self;
    self.contextjs.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"JavaScript异常信息：%@", exceptionValue);
    };
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    /*
    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
    [self.contextjs evaluateScript:alertJS];//通过oc方法调用js的alert
    */
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"HATestView.h网页加载错误：%@",error);
    
}

#pragma end mark

#pragma mark UIScrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidScroll方法:%g",scrollView.contentOffset.y);
    /*
    float g = scrollView.contentOffset.y;
    NSLog(@"拖拽：%g",g);
    NSString * gStr = [NSString stringWithFormat:@"%g",g];
    NSString *alertJS=@"indexScroll()"; //准备执行的js代码
    
    JSValue *jsFunction = self.contextjs[@"indexScroll"];
    JSValue *value1 = [jsFunction callWithArguments:@[gStr]];
    */
    //[self.contextjs evaluateScript:alertJS];//通过oc方法调用js的alert
    
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

- (void)pushToGoodsDetail:(NSString *)index withUi:(NSString *)sender{
    
    if (self.homeSubDelegate && [self.homeSubDelegate respondsToSelector:@selector(homeSubViewController:JavaScriptActionFourButton:withUi:)]) {
        [self.homeSubDelegate homeSubViewController:self JavaScriptActionFourButton:index withUi:sender];
    }
    
    
}

- (void)pushTest:(NSArray *)senderARR{
    
    NSString * index = senderARR[0];
    NSString * sender = senderARR[1];
    NSLog(@"数组中index:%@,sender:%@",index,sender);
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

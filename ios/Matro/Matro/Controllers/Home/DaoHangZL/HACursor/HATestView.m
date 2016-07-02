//
//  HATestView.m
//  HAScrollNavBar
//
//  Created by haha on 15/7/19.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "HATestView.h"
#import "UIView+Extension.h"
#import "CommonHeader.h"
@implementation HATestView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:65];
        
        label.textAlignment = NSTextAlignmentCenter;
        self.label = label;
        [self addSubview:label];
        
        self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        */
        self.backgroundColor = [UIColor whiteColor];
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-64)];
        self.webView.delegate = self;
        self.webView.scrollView.delegate = self;
        [self addSubview:self.webView];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.width = self.width;
    self.label.height = self.height;
    self.label.x = 0;
    self.label.y = 0;
}

//创建 webView
- (void)createWebViewWith:(NSString *)urlString{
    

    
    NSURL * url2 = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3000];
    [self.webView loadRequest:request];
}

#pragma mark WebView代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"HATestView.h网页开始加载");

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"HATestView.h网页完成加载");
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"HATestView.h网页加载错误：%@",error);

}

#pragma end mark

#pragma mark UIScrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@"scrollViewDidScroll方法:%g",scrollView.contentOffset.y);
    if (self.offestYDelegate && [self.offestYDelegate respondsToSelector:@selector(hatestView:withContentOffest:)]) {
        
        [self.offestYDelegate hatestView:self withContentOffest:scrollView.contentOffset.y];
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    NSLog(@"开始拖拽");
    if (self.offestYDelegate && [self.offestYDelegate respondsToSelector:@selector(hatestView:withBeginOffest:)]) {
        [self.offestYDelegate hatestView:self withBeginOffest:scrollView.contentOffset.y];
        
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSLog(@"结束拖拽");
}


#pragma  end mark


@end

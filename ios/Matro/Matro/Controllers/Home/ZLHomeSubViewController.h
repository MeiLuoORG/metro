//
//  ZLHomeSubViewController.h
//  Matro
//
//  Created by lang on 16/7/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PinPaiZLViewController.h"


#import "CommonHeader.h"
@class ZLHomeSubViewController;
@protocol ZLHomeSubVieDragProtocol <NSObject>

- (void)homeSubViewController:(ZLHomeSubViewController *)subVC withContentOffest:(float ) haViewOffestY;
- (void)homeSubViewController:(ZLHomeSubViewController *)subVC withBeginOffest:(float)haViewOffestY;
- (void)homeSubViewController:(ZLHomeSubViewController *)subVC JavaScriptActionFourButton:(NSString *)index;

@end

@protocol HomeSubJSObjectDelegate <JSExport>

- (void)fourButtonAction:(NSString *)index;

@end

@interface ZLHomeSubViewController : MLBaseViewController<UIScrollViewDelegate,UIWebViewDelegate,HomeSubJSObjectDelegate>

@property (weak, nonatomic) id<ZLHomeSubVieDragProtocol> homeSubDelegate;
@property(nonatomic,strong)JSContext *contextjs;
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) NSString * urlstr;

- (void)createWebViewWith:(NSString *)urlString;
- (instancetype)initWithURL:(NSString * )urlStr;
@end

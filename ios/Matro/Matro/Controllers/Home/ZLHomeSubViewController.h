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
#import "MLHttpManager.h"

#import "MJRefresh.h"
#import "CommonHeader.h"
#import "MBProgressHUD+Add.h"
@class ZLHomeSubViewController;
@protocol ZLHomeSubVieDragProtocol <NSObject>

- (void)homeSubViewController:(ZLHomeSubViewController *)subVC withContentOffest:(float ) haViewOffestY;
- (void)homeSubViewController:(ZLHomeSubViewController *)subVC withBeginOffest:(float)haViewOffestY;
- (void)homeSubViewController:(ZLHomeSubViewController *)subVC JavaScriptActionFourButton:(NSString *)type withUi:(NSString *)sender;

@end

@protocol HomeSubJSObjectDelegate <JSExport>

- (void)skip:(NSString *)index Ui:(NSString *)sender;

@end

@interface ZLHomeSubViewController : MLBaseViewController<UIScrollViewDelegate,UIWebViewDelegate,HomeSubJSObjectDelegate>

@property (weak, nonatomic) id<ZLHomeSubVieDragProtocol> homeSubDelegate;
@property(nonatomic,strong)JSContext *contextjs;
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) NSString * urlstr;

@property (strong, nonatomic) UIImageView * dakaImageView;


- (void)createWebViewWith:(NSString *)urlString;
- (instancetype)initWithURL:(NSString * )urlStr;
@end

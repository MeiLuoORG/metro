//
//  HATestView.h
//  HAScrollNavBar
//
//  Created by haha on 15/7/19.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HATestView;
@protocol HATopDragProtocol <NSObject>

- (void)hatestView:(HATestView *)haView withContentOffest:(float ) haViewOffestY;
- (void)hatestView:(HATestView *)haView withBeginOffest:(float)haViewOffestY;

@end


@interface HATestView : UIView<UIWebViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) id<HATopDragProtocol> offestYDelegate;
@property (nonatomic, weak) UILabel *label;
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) NSString * urlString;

- (void)createWebViewWith:(NSString *)urlString;

@end

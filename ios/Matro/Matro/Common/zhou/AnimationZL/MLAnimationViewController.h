//
//  MLAnimationViewController.h
//  Matro
//
//  Created by lang on 16/7/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "YYAnimationIndicator.h"
#import "CommonHeader.h"

typedef void(^AnimationMLBlock)(BOOL success);
typedef void(^ReworkBlock)();


@interface MLAnimationViewController : MLBaseViewController


@property (copy, nonatomic) AnimationMLBlock block;
@property (copy,nonatomic)ReworkBlock reblock;
@property (retain,nonatomic)UIView *reView;

- (void)animationBlockAction:(AnimationMLBlock)block;

@end

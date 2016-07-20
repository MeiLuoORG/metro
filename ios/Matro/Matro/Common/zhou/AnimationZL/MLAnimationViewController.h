//
//  MLAnimationViewController.h
//  Matro
//
//  Created by lang on 16/7/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "YYAnimationIndicator.h"

typedef void(^AnimationMLBlock)(BOOL success);


@interface MLAnimationViewController : MLBaseViewController


@property (copy, nonatomic) AnimationMLBlock block;


- (void)animationBlockAction:(AnimationMLBlock)block;

@end

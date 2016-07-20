//
//  AppDelegate.h
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MLPushMessageModel.h"
#import "UPPaymentControl.h"

#import "MLAnimationViewController.h"


static NSString *appKey = @"beddefb33f6e5abc8d411c2b";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)MLPushMessageModel *pushMessage;


@property (strong, nonatomic) UITabBarController *tabBarController;

- (void)autoLogin;


@end


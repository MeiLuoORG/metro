//
//  SecondsViewController.h
//  Matro
//
//  Created by lang on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "CommonHeader.h"
#import "ZLLabelCustom.h"
#import "UILabel+HeinQi.h"
#import "JSBadgeView.h"
#import "MBProgressHUD+Add.h"
#import "MLPayViewController.h"
#import "CityFuWuViewController.h"
#import "Reachability.h"
#import "MLHttpManager.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CityFuWuViewController.h"
#import "ZLPageControl.h"

@class SecondsViewController;

@protocol SecondsViewControllerDelegate <NSObject>

- (void)secondViewController:(SecondsViewController *)subVC withContentOffest:(float ) haViewOffestY;
- (void)secondViewController:(SecondsViewController *)subVC withBeginOffest:(float)haViewOffestY;
- (void)secondViewController:(SecondsViewController *)subVC JavaScriptActionFourButton:(NSString *)type withUi:(NSString *)sender;


@end

@interface SecondsViewController : MLBaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (assign, nonatomic) int indexType;
@property (strong, nonatomic) UITableView * tableview;
@property (weak, nonatomic) id<SecondsViewControllerDelegate> secondDelegate;

@end

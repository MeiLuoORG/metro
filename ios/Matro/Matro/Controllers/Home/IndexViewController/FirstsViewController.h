//
//  FirstsViewController.h
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
#import <SDWebImage/UIImageView+WebCache.h>
#import "FourButtonsView.h"
#import "MLSecondCollectionViewCell.h"
#import "Index3TableViewCell.h"

@class FirstsViewController;
@protocol FirsrtViewControllerDelegate <NSObject>

- (void)firstViewController:(FirstsViewController *)subVC withContentOffest:(float ) haViewOffestY;
- (void)firstViewController:(FirstsViewController *)subVC withBeginOffest:(float)haViewOffestY;
- (void)firstViewController:(FirstsViewController *)subVC JavaScriptActionFourButton:(NSString *)type withUi:(NSString *)sender;


@end


@interface FirstsViewController : MLBaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UITableView * tableview;
@property (weak, nonatomic) id<FirsrtViewControllerDelegate> firstDelegate;
@property (strong, nonatomic) NSMutableArray * lunXianImageARR;
@property (strong, nonatomic) UIView * lunXianView;
@property (strong, nonatomic) UIScrollView * lunXianScrollView;
@property (strong, nonatomic) UIPageControl * lunXianPageControl;

@property (strong, nonatomic) FourButtonsView * fourButtonView;

@property (strong, nonatomic) UICollectionView * index_2_CollectionView;
@property (strong, nonatomic) NSMutableArray * index_2_GoodARR;
@property (strong, nonatomic) UILabel * index_2_titleLabel;
@property (strong, nonatomic) UIImageView * index_2_titleImageView;

@property (strong, nonatomic) UIImageView * index_4_imageview;

@end

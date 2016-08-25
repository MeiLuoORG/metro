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
#import <SDWebImage/UIButton+WebCache.h>
#import "FourButtonsView.h"
#import "MLSecondCollectionViewCell.h"
#import "Index3TableViewCell.h"
#import "Index_5_View.h"
#import "MLSecondTableViewCell.h"
#import "MLThirdTableViewCell.h"
#import "MLYourlikeTableViewCell.h"
#import "MLYourlikeCollectionViewCell.h"

#import "MJRefresh.h"
#import "ZLPageControl.h"
#define SecondCCELL_IDENTIFIER @"MLSecondCollectionViewCell"
#define YourlikeCCELL_IDENTIFIER @"MLYourlikeCollectionViewCell"
#define CollectionViewCellMargin 5.0f//间隔5
@class FirstsViewController;
@protocol FirsrtViewControllerDelegate <NSObject>

- (void)firstViewController:(FirstsViewController *)subVC withContentOffest:(float ) haViewOffestY;
- (void)firstViewController:(FirstsViewController *)subVC withBeginOffest:(float)haViewOffestY;
- (void)firstViewController:(FirstsViewController *)subVC JavaScriptActionFourButton:(NSString *)type withUi:(NSString *)sender withTitle:(NSString *)title;


@end


@interface FirstsViewController : MLBaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UITableView * tableview;
@property (weak, nonatomic) id<FirsrtViewControllerDelegate> firstDelegate;
@property (strong, nonatomic) NSMutableArray * lunXianImageARR;
@property (strong, nonatomic) UIView * lunXianView;
@property (strong, nonatomic) UIScrollView * lunXianScrollView;
@property (strong, nonatomic) UIPageControl * lunXianPageControl;
@property (strong, nonatomic) ZLPageControl * pageControl;

@property (strong, nonatomic) FourButtonsView * fourButtonView;

@property (strong, nonatomic) UICollectionView * index_2_CollectionView;
@property (strong, nonatomic) NSMutableArray * index_2_GoodARR;
@property (strong, nonatomic) UILabel * index_2_titleLabel;
@property (strong, nonatomic) UIImageView * index_2_titleImageView;

@property (strong, nonatomic) UIImageView * index_4_imageview;

@property (strong, nonatomic) Index_5_View * index_5_View;
@property (strong, nonatomic) UICollectionView * index_5_CollectionView;
@property (strong, nonatomic) UILabel * index_5_titleLabel;
@property (strong, nonatomic) UIImageView * index_5_titleImageView;

@property (strong, nonatomic) UICollectionView * index_8_CollectionView;
@property (strong, nonatomic) NSMutableArray * index_8_goodARR;

@property (strong, nonatomic) UIButton * backTopButton;
@property (assign, nonatomic) float historyOffestY;

@property (assign, nonatomic) int likePage;

@property (strong, nonatomic) NSString * firstImageURLStr;
@property (strong, nonatomic) NSString * secondImageURLStr;
@property (strong, nonatomic) NSString * threeImageURLStr;
@property (strong, nonatomic) NSString * fourImageURLStr;

@end

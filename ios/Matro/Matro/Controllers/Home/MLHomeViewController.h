//
//  MLHomeViewController.h
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PinPaiZLViewController.h"
#import "CommonHeader.h"

#import "HomeSubViewViewController.h"



#import <UIKit/UIKit.h>


@protocol ViewPagerDataSource;
@protocol ViewPagerDelegate;



@interface MLHomeViewController : MLBaseViewController


@property (assign, nonatomic) float currentOffestY;

@property id<ViewPagerDataSource> dataSource;
@property id<ViewPagerDelegate> delegate;

#pragma mark ViewPagerOptions
// Tab bar's height, defaults to 49.0
@property CGFloat tabHeight;
// Tab bar's offset from left, defaults to 56.0
@property CGFloat tabOffset;
// Any tab item's width, defaults to 128.0. To-do: make this dynamic
@property CGFloat tabWidth;

// 1.0: Top, 0.0: Bottom, changes tab bar's location in the screen
// Defaults to Top
@property CGFloat tabLocation;

// 1.0: YES, 0.0: NO, defines if view should appear with the second or the first tab
// Defaults to NO
@property CGFloat startFromSecondTab;

// 1.0: YES, 0.0: NO, defines if tabs should be centered, with the given tabWidth
// Defaults to NO
@property CGFloat centerCurrentTab;

#pragma mark Colors
// Colors for several parts
@property UIColor *indicatorColor;
@property UIColor *tabsViewBackgroundColor;
@property UIColor *contentViewBackgroundColor;

#pragma mark Methods
// Reload all tabs and contents
- (void)reloadData;

@end

#pragma mark dataSource
@protocol ViewPagerDataSource <NSObject>

// Asks dataSource how many tabs will be
- (NSUInteger)numberOfTabsForViewPager:(MLHomeViewController *)viewPager;
// Asks dataSource to give a view to display as a tab item
// It is suggested to return a view with a clearColor background
// So that un/selected states can be clearly seen
- (UIView *)viewPager:(MLHomeViewController *)viewPager viewForTabAtIndex:(NSUInteger)index;

@optional
// The content for any tab. Return a view controller and ViewPager will use its view to show as content
- (UIViewController *)viewPager:(MLHomeViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
- (UIView *)viewPager:(MLHomeViewController *)viewPager contentViewForTabAtIndex:(NSUInteger)index;

@end

#pragma mark delegate
@protocol ViewPagerDelegate <NSObject>

@optional

/*
 * Use this method to customize the look and feel.
 * viewPager will ask its delegate for colors for its components.
 * And if they are provided, it will use them, otherwise it will use default colors.
 * Also not that, colors for tab and content views will change the tabView's and contentView's background
 * (you should provide these views with a clearColor to see the colors),
 * and indicator will change its own color.
 */


@end

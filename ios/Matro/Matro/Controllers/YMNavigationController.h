//
//  YMNavigationController.h
//  YMShare
//
//  Created by MR.Huang on 16/1/4.
//  Copyright © 2016年 YMKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMNavigationController : UINavigationController
{
    BOOL _changing;
}
@property(nonatomic, retain)UIView *alphaView;
-(void)setAlph;
- (void)showNavBar;
- (void)hiddenNavBar;

@end

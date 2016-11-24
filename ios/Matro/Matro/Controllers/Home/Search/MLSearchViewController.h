//
//  MLSearchViewController.h
//  Matro
//
//  Created by hyk on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

//#import "MLBaseViewController.h"
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>


@protocol SearchDelegate <NSObject>
- (void)SearchText:(NSString *)text;
@end

@interface MLSearchViewController :UIViewController{
    MBProgressHUD *_hud;
}

@property (nonatomic, weak) UIViewController *activeViewController;

@property (assign,nonatomic,readwrite)id <SearchDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UILabel *labsearch;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (copy,nonatomic)NSDictionary *searchDic;
@end

//
//  MLAllOrdersViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAllOrdersViewController.h"
#import "HFSConstants.h"
#import "MLPersonOrderListViewController.h"

@interface MLAllOrdersViewController ()

@end

@implementation MLAllOrdersViewController


- (instancetype)init
{
    if (self = [super init])
    {
        self.menuViewStyle                   = WMMenuViewStyleLine;
        self.titleColorSelected              = RGBA(174, 142, 93, 1);
        self.titleColorNormal                = RGBA(14, 14, 14, 1);
        self.progressColor                   = RGBA(174, 142, 93, 1);
        self.titleSizeSelected               = 14;
        self.pageAnimatable                  = NO;
        self.titleSizeNormal                 = 14;
        self.menuHeight                      = 44;
        self.menuItemWidth                   = (MAIN_SCREEN_WIDTH - 5*15)/4;
        self.postNotification                = YES;
        self.itemMargin                      = 15.f;
        self.bounces                         = NO;
        self.menuBGColor                     = [UIColor whiteColor];
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            Class vcClass;
            NSString *title;
            switch (i) {
                case 0:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"全部";
                    break;
                case 1:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"待付款";
                    break;
                case 2:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"待收货";
                    break;
                case 3:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"待评价";
                    break;
                default:
                    break;
            }
            [viewControllers addObject:vcClass];
            [titles addObject:title];
        }
        self.viewControllerClasses = viewControllers;
        self.titles = titles;
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.scrollEnabled = NO;
    self.viewFrame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64);
}


@end

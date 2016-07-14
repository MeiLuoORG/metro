//
//  MLpingjiaViewController.m
//  Matro
//
//  Created by Matro on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLpingjiaViewController.h"
#import "HFSConstants.h"
#import "MLPingjiaListViewController.h"

@interface MLpingjiaViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MLpingjiaViewController


- (instancetype)init
{
    if (self = [super init])
    {
        self.menuViewStyle                   = WMMenuViewStyleLine;
        self.titleColorSelected              = RGBA(174, 142, 93, 1);
        self.titleColorNormal                = RGBA(14, 14, 14, 1);
        self.progressColor                   = RGBA(174, 142, 93, 1);
        self.titleSizeSelected               = 16;
        self.pageAnimatable                  = NO;
        self.titleSizeNormal                 = 16;
        self.menuHeight                      = 44;
        self.menuItemWidth                   = (MAIN_SCREEN_WIDTH - 6*20)/5;
        self.postNotification                = YES;
        self.itemMargin                      = 15.f;
        self.bounces                         = NO;
        self.menuBGColor                     = [UIColor whiteColor];
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 5; i++) {
            Class vcClass;
            NSString *title;
            
            switch (i) {
                case 0:
                    vcClass = [MLPingjiaListViewController class];
                    title = @"全部";

                    break;
                case 1:
                    vcClass = [MLPingjiaListViewController class];
                    title = @"好评";
                    
                    break;
                case 2:
                    vcClass = [MLPingjiaListViewController class];
                    title = @"中评";
                    
                    break;
                case 3:
                    vcClass = [MLPingjiaListViewController class];
                    title = @"差评";
                    break;
                case 4:
                    vcClass = [MLPingjiaListViewController class];
                    title = @"晒图";
                    
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
    
    self.navigationItem.title = @"用户评价";
    self.scrollView.scrollEnabled = NO;
    self.viewFrame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64);
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    item.title = @"";
    item.image = backButtonImage;
    item.width = -20;
    

    self.navigationItem.leftBarButtonItem = item;
}

- (void)backBtnAction{

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

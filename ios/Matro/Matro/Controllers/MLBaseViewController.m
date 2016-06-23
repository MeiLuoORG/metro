//
//  MLBaseViewController.m
//  Matro
//
//  Created by NN on 16/2/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "AppDelegate.h"
#import "UIColor+HeinQi.h"

@interface MLBaseViewController ()

@end

@implementation MLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    
    //
    
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    item.title = @"";
    item.image = backButtonImage;
    item.width = -20;
    self.navigationItem.leftBarButtonItem = item;
    //[[UIBarButtonItem alloc] initWithCustomView:button];
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    /*
    //UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 22, 22)];
    imageView.image = backButtonImage;

    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:imageView];
    [self.navigationItem setBackBarButtonItem:item];
    */

    /*
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(20, 0) forBarMetrics:UIBarMetricsDefault];
    */
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
     
     self.title=[NSString stringWithFormat:@"第%lu页",(unsigned long)self.navigationController.viewControllers.count];
     
     //自定义返回按钮
     UIImage *backButtonImage = [[UIImage imageNamed:@"fanhui.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
     [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     //将返回按钮的文字position设置不在屏幕上显示
     [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
     
     
     */
    
    //self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];

    
}

- (void)backBtnAction{

    [self.navigationController popViewControllerAnimated:YES];
}



- (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)alert:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

@end

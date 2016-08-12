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
#import "UMMobClick/MobClick.h"
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
    self.view.backgroundColor = [UIColor whiteColor];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];  
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
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

- (void)showTransparentController:(UIViewController *)controller{
    controller.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:controller animated:NO completion:^(void){
        controller.view.superview.backgroundColor = [UIColor clearColor];
    }];
}

@end

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
@interface MLBaseViewController (){
    
    YYAnimationIndicator *indicator;
}

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
    
    indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(SCREENWIDTH/2.0-50, SCREENHEIGHT/2.0-100, 100, 25)];
    indicator.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"Loading页的frame：%g+++++%g",indicator.frame.size.width/2.0-50,indicator.frame.size.height/2.0-15);
    
    //[indicator setLoadText:@"努力加载中..."];
    
    [self.view addSubview:indicator];
    
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

#pragma mark - 窗体加载进度条
- (void)showLoadingView
{
    /*
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.mode = MBProgressHUDModeCustomView;
    [self.view addSubview:_hud];
    _hud.color=[UIColor clearColor];
    [_hud show:true];
    */

    
    [self.view bringSubviewToFront:indicator];
    
    [indicator startAnimation];
    
}

- (void)closeLoadingView
{
    if (_hud) {
        [_hud hide:true];
    }
    [indicator stopAnimationWithLoadText:@"" withType:YES];//加载成功
    //[indicator removeFromSuperview];
}

- (void)viewDidUnload
{
    _hud  = nil;
    indicator=nil;
    
    [super viewDidUnload];
}

@end

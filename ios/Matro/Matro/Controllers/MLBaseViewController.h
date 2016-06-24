//
//  MLBaseViewController.m
//  Matro
//
//  Created by NN on 16/2/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define MS_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@class AppDelegate;

#import "MLNavigationController.h"
#import "HFSConstants.h"
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}
@interface MLBaseViewController : UIViewController {
    MBProgressHUD *_hud;
}

- (AppDelegate *)getAppDelegate;

- (void)alert:(NSString *)title msg:(NSString *)msg;

- (void)showTransparentController:(UIViewController *)controller;


@end

//
//  ShiMingViewController.h
//  Matro
//
//  Created by lang on 16/6/24.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "CommonHeader.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "NavTopCommonImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface ShiMingViewController : MLBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString * userPhone;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * userShenFenCardID;
@property (assign, nonatomic) BOOL isRenZheng;

@end

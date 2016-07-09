//
//  ShiMingViewController.h
//  Matro
//
//  Created by lang on 16/6/24.
//  Copyright © 2016年 HeinQi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"
#import "CommonHeader.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "NavTopCommonImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "MLHttpManager.h"
#import "NSDatezlModel.h"

#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"



@interface ShiMingViewController : MLBaseViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSString * pay_id;
@property (strong, nonatomic) NSString * userPhone;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * userShenFenCardID;
@property (strong, nonatomic) NSString * shenFenImageURLStr;
@property (assign, nonatomic) BOOL isRenZheng;

@end

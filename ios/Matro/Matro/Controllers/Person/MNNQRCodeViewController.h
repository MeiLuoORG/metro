//
//  MNNQRCodeViewController.h
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "CommonHeader.h"
#import "HFSServiceClient.h"
#import "VipCardModel.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MNNQRCodeViewController : MLBaseViewController

@property (strong, nonatomic) NSString * cardNo;
@property (strong, nonatomic) UIImageView * qrcodeView;

@end

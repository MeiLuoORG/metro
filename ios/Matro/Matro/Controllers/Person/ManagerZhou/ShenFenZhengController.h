//
//  ShenFenZhengController.h
//  Matro
//
//  Created by lang on 16/6/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "CommonHeader.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"

typedef void(^ShenFenZhengBlock)(BOOL success);

@interface ShenFenZhengController : MLBaseViewController

@property (strong, nonatomic) NSString * shenFenStr;
@property (copy, nonatomic) ShenFenZhengBlock block;

- (void)shenFenZhengBlockAction:(ShenFenZhengBlock)block;

@end

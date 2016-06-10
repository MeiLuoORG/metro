//
//  MNNNextStepViewController.h
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "CommonHeader.h"
#import "NavTopCommonImage.h"


typedef void(^BackDismissBlock)(BOOL success);

@interface MNNNextStepViewController : MLBaseViewController


@property (copy, nonatomic) BackDismissBlock backBlock;
@property (nonatomic,copy) NSString *vcode;
@property (nonatomic,copy)NSString *phoneNum;

- (void)backDismissBlockAction:(BackDismissBlock )block;
@end

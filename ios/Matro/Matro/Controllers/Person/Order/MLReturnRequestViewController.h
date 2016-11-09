//
//  MLReturnRequestViewController.h
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLTuiHuoModel.h"
#import "YYAnimationIndicator.h"
@interface MLReturnRequestViewController : UIViewController

@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *pro_id;
@property BOOL isAll;

//窗体加载进度
- (void)showLoadingView;
- (void)closeLoadingView;
@end

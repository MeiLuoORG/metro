//
//  MLShouJiZhiViewController.h
//  Matro
//
//  Created by lang on 16/7/19.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLOrderListModel.h"
#import "MLPayShiBaiViewController.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
@interface MLShouJiZhiViewController : MLBaseViewController

@property (strong, nonatomic) NSString * orderNum;
@property (assign, nonatomic) float  jinE;
@property (assign, nonatomic) int  type;

- (void)zhifuwith:(int)index;


@end

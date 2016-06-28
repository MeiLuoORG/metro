//
//  MLReturnsDetailViewController.h
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"



typedef void(^CancelSuccess)();

@interface MLReturnsDetailViewController : MLBaseViewController
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)CancelSuccess cancelSuccess;

@end

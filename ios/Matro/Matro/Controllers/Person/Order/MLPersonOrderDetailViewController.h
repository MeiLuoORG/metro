//
//  MLPersonDetailViewController.h
//  Matro
//
//  Created by MR.Huang on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"

@interface MLPersonOrderDetailViewController : MLBaseViewController
@property (nonatomic,copy)NSString *order_id;
@property (assign, nonatomic) float order_price;

@end

//
//  MLPersonOrderListViewController.h
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"

typedef NS_ENUM(NSInteger,OrderType){
    OrderType_All,
    OrderType_Fukuan,
    OrderType_Shouhuo,
    OrderType_Pingjia,
};

@interface MLPersonOrderListViewController : MLBaseViewController
- (instancetype)initWithOrderType:(OrderType)orderType;

@end

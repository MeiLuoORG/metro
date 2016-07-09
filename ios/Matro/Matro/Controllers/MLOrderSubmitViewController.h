//
//  MLOrderSubmitViewController.h
//  Matro
//
//  Created by 黄裕华 on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLCommitOrderListModel.h"

@interface MLOrderSubmitViewController : MLBaseViewController
@property (nonatomic,strong)MLCommitOrderListModel *order_info;
@property (nonatomic,strong)NSDictionary *params;

@end

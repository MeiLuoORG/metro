//
//  MLPayViewController.h
//  Matro
//
//  Created by NN on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLOrderListModel.h"
#import "MLPayShiBaiViewController.h"
#import "MLHttpManager.h"

@interface MLPayViewController : MLBaseViewController
@property(nonatomic,retain) NSDictionary *paramDic;
@property (nonatomic,retain)MLOrderListModel *orderDetail;
@property (nonatomic,assign)BOOL isGlobal;

@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,assign)float order_sum;



@end

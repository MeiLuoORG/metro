//
//  MLShopInfoViewController.h
//  Matro
//
//  Created by 黄裕华 on 16/6/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLShopInfoViewController : MLBaseViewController

@property (nonatomic,copy)NSString *store_link;
@property (nonatomic,copy)NSString *uid;
@property(nonatomic,retain) NSDictionary *shopparamDic;

@end

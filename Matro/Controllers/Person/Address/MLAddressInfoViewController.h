//
//  MLAddressInfoViewController.h
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

typedef void(^AddAddressSuccess)();
@interface MLAddressInfoViewController : MLBaseViewController

@property (nonatomic) BOOL isNewAddress;
@property (nonatomic,retain) NSDictionary *paramdic;
@property (nonatomic,copy)AddAddressSuccess addressSuccess;
@end

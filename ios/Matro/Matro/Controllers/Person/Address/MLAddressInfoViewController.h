//
//  MLAddressInfoViewController.h
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLAddressListModel.h"

typedef void(^AddAddressSuccess)();
@interface MLAddressInfoViewController : MLBaseViewController

@property (nonatomic) BOOL isNewAddress;
@property (nonatomic,copy)AddAddressSuccess addressSuccess;

@property (nonatomic,strong)MLAddressListModel *addressDetail;


@end

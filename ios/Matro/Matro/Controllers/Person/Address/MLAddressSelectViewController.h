//
//  MLAddressSelectViewController.h
//  Matro
//
//  Created by MR.Huang on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"

@class MLAddressListModel;

typedef void(^AddressSelectBlock)(MLAddressListModel*);
@interface MLAddressSelectViewController : MLBaseViewController
@property (nonatomic,copy)AddressSelectBlock addressSelectBlock;


@end

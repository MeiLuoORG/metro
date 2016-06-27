//
//  MLAddressSelectViewController.h
//  Matro
//
//  Created by MR.Huang on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLAddressListModel;

typedef void(^AddressSelectBlock)(MLAddressListModel*);
@interface MLAddressSelectViewController : UIViewController
@property (nonatomic,copy)AddressSelectBlock addressSelectBlock;


@end

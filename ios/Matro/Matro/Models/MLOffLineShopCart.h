//
//  MLOffLineShopCart.h
//  Matro
//
//  Created by 黄裕华 on 16/7/4.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OffLlineShopCart.h"
#import "CompanyInfo.h"

@interface MLOffLineShopCart : NSObject
@property (nonatomic,strong)CompanyInfo *cpInfo;
@property (nonatomic,strong)NSMutableArray *goodsArray;
@property (nonatomic,assign)BOOL checkAll;

@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;

@end

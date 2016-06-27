//
//  MLTuiHuoModel.m
//  Matro
//
//  Created by MR.Huang on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuiHuoModel.h"
@class MLTuiHuoProductModel;

@implementation MLTuiHuoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"products":[MLTuiHuoProductModel class]};
}

- (void)setProducts:(NSArray *)products{
    _products = products;
    self.isMore = _products.count>2;
}

@end


@implementation MLTuiHuoProductModel



@end
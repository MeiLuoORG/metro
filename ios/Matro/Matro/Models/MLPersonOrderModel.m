
//
//  MLPersonOrderModel.m
//  Matro
//
//  Created by 黄裕华 on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonOrderModel.h"
@class MLPersonOrderProduct;
@class MLInvinfo;
@implementation MLPersonOrderModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"product":[MLPersonOrderProduct class]};
}




- (void)setProduct:(NSArray *)product{
    _product = product;
    self.isMore = (_product.count>2);
}


@end


@implementation MLPersonOrderProduct

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


@end

@implementation MLInvinfo



@end


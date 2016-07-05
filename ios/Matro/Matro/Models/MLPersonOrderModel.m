
//
//  MLPersonOrderModel.m
//  Matro
//
//  Created by MR.Huang on 16/6/16.
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


- (void)setSetmeal:(NSArray *)setmeal{
    if (_setmeal != setmeal) {
        _setmeal = setmeal;
        if (![_setmeal isKindOfClass:[NSArray class]]) {
            return;
        }
        NSMutableString *str = [NSMutableString string];
        for (NSDictionary *dic in _setmeal) {
            NSString *key = dic[@"key"];
            NSString *value = dic[@"value"];
            [str appendFormat:@"%@：%@ ",key,value];
        }
        _setmeal_str = [str copy];
        
    }
}

@end

@implementation MLInvinfo



@end


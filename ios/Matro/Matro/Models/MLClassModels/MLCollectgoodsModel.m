//
//  MLCollectgoodsModel.m
//  Matro
//
//  Created by Matro on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCollectgoodsModel.h"
@class MLSetmeal;

@implementation MLCollectgoodsModel


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"setmeal":[MLSetmeal class]};
}

@end



@implementation MLSetmeal





@end
//
//  MLCollectgoodsModel.m
//  Matro
//
//  Created by Matro on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCollectgoodsModel.h"



@class MLPsetmeal;


@implementation MLCollectgoodsModel



+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}



+ (NSDictionary *)objectClassInArray{
    return @{@"setmeal":[MLPsetmeal class]};
}

@end





@implementation MLPsetmeal

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"SID":@"sid",
             @"Code":@"code"
             
             };
}


@end
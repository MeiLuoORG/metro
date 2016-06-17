//
//  MLShippingaddress.m
//  Matro
//
//  Created by 黄裕华 on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShippingaddress.h"

@implementation MLShippingaddress

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"sub":[MLShippingaddress class]};
}


@end

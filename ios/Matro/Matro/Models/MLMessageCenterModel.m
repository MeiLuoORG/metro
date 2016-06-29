//
//  MLMessageCenterModel.m
//  Matro
//
//  Created by 黄裕华 on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLMessageCenterModel.h"

@implementation MLMessageCenterModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end
@implementation MLSystemMessageModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end

@implementation MLActiveMessageModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


@end
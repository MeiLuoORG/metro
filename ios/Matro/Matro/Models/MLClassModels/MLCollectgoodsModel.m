//
//  MLCollectgoodsModel.m
//  Matro
//
//  Created by Matro on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCollectgoodsModel.h"

@implementation MLCollectgoodsModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             
             @"ID" : @"id",
             @"Pid" : @"pid",
             @"Pname" : @"pname",
             @"Pimage" : @"image",
             @"Pprice": @"price",
             @"Psetmeal":@"setmeal",
             };
}


@end

//
//  MLCollectstoresModel.m
//  Matro
//
//  Created by Matro on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCollectstoresModel.h"

@implementation MLCollectstoresModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             
             @"Shopid" : @"shopid",
             @"Sscore" : @"score",
             @"Shopname" : @"shopname",
             @"Slogo" : @"logo",
             
             };
}
@end

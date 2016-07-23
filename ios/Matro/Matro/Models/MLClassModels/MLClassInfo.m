//
//  MLClassInfo.m
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLClassInfo.h"

@implementation MLClassInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             /*
             @"HEIGHT" : @"HEIGHT",
             @"HOTIMG" : @"HOTIMG",
             @"CID" : @"ID",
             @"MC" : @"MC",
             @"SRC" : @"SRC",
             @"TITLE" : @"TITLE",
             @"URL" : @"URL",
             @"WIDTH" : @"WIDTH",
              */
             @"code" : @"code",
             @"mc" : @"mc",
             @"ishot" : @"ishot",
             @"istuij" : @"istuij",
             @"inx" : @"inx",
             @"imgurl" : @"imgurl",
             @"catid" : @"catid",
             };
}

+ (NSValueTransformer *)SRCJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end

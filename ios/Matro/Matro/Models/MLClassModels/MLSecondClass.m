//
//  MLSecondClass.m
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSecondClass.h"

@implementation MLSecondClass

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"SecondaryClassification_Ggw" : @"Second_Category",
            // @"SecondaryClassification_WebrameCode" : @"SecondaryClassification_WebrameCode",
             @"ThreeClassificationList" : @"Third_Category",
             };
}

@end

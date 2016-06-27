
//
//  MLReturnsDetailModel.m
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsDetailModel.h"
#import "MLTuiHuoModel.h"


@class MLReturnsQuestiontype;

@implementation MLReturnsDetailModel


+ (NSDictionary *)objectClassInArray{
    return @{@"question_type":[MLReturnsQuestiontype class],@"products":[MLTuiHuoProductModel class]};
}



- (void)setProducts:(NSArray *)products{
    _products = products;
    self.isMore = (_products.count>2);
    
}


@end

@implementation MLReturnsReturnInfo

@end
@implementation MLReturnsQuestiontype
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


@end
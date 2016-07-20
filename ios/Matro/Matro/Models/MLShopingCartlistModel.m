//
//  MLShopingCartlistModel.m
//  Matro
//
//  Created by MR.Huang on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopingCartlistModel.h"
@class MLShopingCartModel;
@class MLProlistModel;

@implementation MLShopingCartlistModel



+ (NSDictionary *)objectClassInArray{
    return @{@"cart":[MLShopingCartModel class]};
}

@end


@implementation MLShopingCartModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"prolist":[MLProlistModel class]};
}


- (void)setSelect_All:(BOOL)select_All{
    if (_select_All != select_All) {
        _select_All = select_All;
    }
}


- (void)setProlist:(NSArray *)prolist{
    if (_prolist != prolist) {
        _prolist = prolist;
        _isMore = (_prolist.count>2);
    }
   
}



@end

@implementation MLProlistModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}




- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] ==NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] ==NSOrderedDescending)
        return NO;
    
    return YES;
}

- (float)realPrice{
    NSDate *now = [NSDate new];
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[self.promition_start_time floatValue]];
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:[self.promition_end_time floatValue]];
    if ([self date:now isBetweenDate:startTime andDate:endTime]) { //在促销期间
        return self.promotion_price;
    }else{
        return self.pro_price;
    }
}




@end


//@implementation MLYouhuiQuanModel
//
//
//
//@end



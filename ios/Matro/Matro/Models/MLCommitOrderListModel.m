//
//  MLCommitOrderListModel.m
//  Matro
//
//  Created by Matro on 16/7/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommitOrderListModel.h"
@class MLOrderCartModel;
@class MLOrderProlistModel;

@implementation MLCommitOrderListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"cart":[MLOrderCartModel class]};
}

@end
@implementation MLOrderCartModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"prolist":[MLOrderProlistModel class]};
}


- (void)setProlist:(NSArray *)prolist{
    if (_prolist != prolist) {
        _prolist = prolist;
        _isMore = (_prolist.count>2);
    }
    
}

@end

@implementation MLOrderProlistModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


@end
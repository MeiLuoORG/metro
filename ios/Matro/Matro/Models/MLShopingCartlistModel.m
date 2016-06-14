//
//  MLShopingCartlistModel.m
//  Matro
//
//  Created by 黄裕华 on 16/6/14.
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
        for (MLProlistModel *model in self.prolist) {
            model.is_check = _select_All?1:0;
        } 
    }
}


@end

@implementation MLProlistModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
@end
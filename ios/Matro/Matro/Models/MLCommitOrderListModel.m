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
@class MLYouHuiQuanModel;
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
    return @{@"prolist":[MLOrderProlistModel class],@"shipping":[MLKuaiDiModel class],@"yhqdata":[MLYouHuiQuanModel class]};
}

- (void)setShipping:(NSArray *)shipping{
    if (_shipping != shipping) {
        _shipping = shipping;
        _canOpenKuaiDi = (_shipping.count > 0);
        if (_canOpenKuaiDi) {
            self.kuaiDiFangshi = [_shipping firstObject];
        }
    }
}

- (void)setYhqdata:(NSArray *)yhqdata{
    if (_yhqdata != yhqdata) {
        _yhqdata = yhqdata;
        _canOpenYouHui = (_yhqdata.count > 0);
    }
}



- (void)setProlist:(NSArray *)prolist{
    if (_prolist != prolist) {
        _prolist = prolist;
        _isMore = (_prolist.count>2);
    }
    
}

- (float)youhuiMoney{
    float count = 0;
    for (MLYouHuiQuanModel *youhuiQuan in self.yhqdata) {
        count += youhuiQuan.useSum;
    }
    return count;
}



@end

@implementation MLOrderProlistModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end
@implementation MLKuaiDiModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
@end

@implementation MLYouHuiQuanModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end

@implementation MLConsigneeInfo



@end


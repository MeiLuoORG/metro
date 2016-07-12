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
//@class MLTaxInfo;

@implementation MLCommitOrderListModel


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"taxinfo":@"tax"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"cart":[MLOrderCartModel class],@"tax":[MLTaxInfo class]};
}

- (float)realTax{
    float taxCount = 0;
    for (MLOrderCartModel *model in self.cart) {
        taxCount += model.realShuiFei;
    }
    return taxCount;
}

- (float)realYunFei{
    float count = 0;
    for (MLOrderCartModel *model in self.cart) {
        count += model.kuaiDiFangshi.price;
    }
    return count;
}

- (float)realYouHui{
    float count = 0;
    for (MLOrderCartModel *model in self.cart) {
        count += model.youhuiMoney;
    }
    return count;
}

- (float)realPrice{
    float count = 0;
    count = self.realTax + self.sumprice - self.realYouHui + self.realYunFei;
    return count;
    
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


- (float)dingdanXiaoji{
    float count = 0;
    count = self.realShuiFei + self.sumprice - self.youhuiMoney + _kuaiDiFangshi.price;
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


@implementation MLTaxInfo



@end


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
    count = self.realTax + self.sumprice - self.realYouHui + self.realYunFei - self.realManJian;
    if (count > 0) {
        return count;
    }
    return 0;
}


- (float)realManJian{
    float count = 0;
    for (MLOrderCartModel *model in self.cart) {
        count += model.reduce_price;
    }
    return count;
}


- (BOOL)isHaveHaiWai{
    BOOL isHave = NO;
    for (MLOrderCartModel *model in self.cart) {
        if (model.way == 2) {
            isHave = YES;
            break;
        }
    }
    return isHave;
}


- (void)setIdentity_card:(NSString *)identity_card{
    if (_identity_card != identity_card) {
        _identity_card = identity_card;
        if ([_identity_card isEqualToString:@"0"]) {
            _identity_card = nil;
        }
    }
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
    count = self.realShuiFei + self.sumprice - self.youhuiMoney + _kuaiDiFangshi.price - self.reduce_price;
    return count;
    
}


- (float)realShuiFei{
    float count = 0;
    
    count = self.kuaiDiFangshi.sumtax;
    return count;
    
}


- (float)realYouHuiQuan{
    float count = 0;
    count = self.sumprice - self.youhuiMoney;
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

- (BOOL)isOk{
    return (self.address.length > 0 && self.mobile.length>0 && self.name.length > 0);
    
}

@end


@implementation MLTaxInfo



@end


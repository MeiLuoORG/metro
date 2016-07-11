//
//  MLOffLineShopCart.m
//  Matro
//
//  Created by MR.Huang on 16/7/4.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOffLineShopCart.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation MLOffLineShopCart
- (void)setCpInfo:(CompanyInfo *)cpInfo{
    if (_cpInfo != cpInfo) {
        _cpInfo = cpInfo;
        //根据id查出所有
        NSMutableArray *tmp = [NSMutableArray array];
        NSArray *pids = [_cpInfo.shopCart componentsSeparatedByString:@","];
        for (NSString *pid in pids) {
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"pid == %@",pid];
            OffLlineShopCart *model = [OffLlineShopCart MR_findFirstWithPredicate:pre];
            [tmp addObject:model];
        }
        _goodsArray = tmp;
        _isMore = _goodsArray.count > 2;
    }
}

- (void)setCheckAll:(BOOL)checkAll{
    if (_checkAll != checkAll) {
        _checkAll = checkAll;
        for (OffLlineShopCart *model in self.goodsArray) {
            model.is_check = checkAll?1:0;
        }
//        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    }
}


@end

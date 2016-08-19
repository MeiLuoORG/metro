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
            NSLog(@"离线购物车中：pid =%@++++++pid数组为：%@",pid,pids);
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"sku == %@",pid];
            NSArray * arr = [OffLlineShopCart MR_findAll];
            
            for (OffLlineShopCart *model1 in arr) {
                
                NSLog(@"离线购物车为的数组中购物车的PID为：%@",model1.sku);
                
            }
            OffLlineShopCart *model = [OffLlineShopCart MR_findFirstWithPredicate:pre];
            
            /*
             zhoulu 修改20160819 START
             */
            if (model && model != nil) {
                [tmp addObject:model];
            }
            /*
             zhoulu 修改20160819 END
             */

        }
        _goodsArray = tmp;
        _isMore = _goodsArray.count > 2;
    }
}

- (void)setCheckAll:(BOOL)checkAll{
    if (_checkAll != checkAll) {
        _checkAll = checkAll;
    }
}


@end

//
//  MLOrderListModel.m
//  Matro
//
//  Created by MR.Huang on 16/5/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderListModel.h"
#import "MLProductModel.h"

@implementation MLOrderListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"PRODUCTLIST":[MLProductModel class]};
}



- (void)setPRODUCTLIST:(NSArray *)PRODUCTLIST{
    _PRODUCTLIST = PRODUCTLIST;
    if (_PRODUCTLIST.count>2) {
        _isMore = YES;
    }
}

@end

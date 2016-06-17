//
//  VIPCardHistoryModel.h
//  Matro
//
//  Created by lang on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface VIPCardHistoryModel : MTLModel

@property (assign, nonatomic) int sum;
@property (strong, nonatomic) NSString * billId;
@property (strong, nonatomic) NSString * gainedCent;
@property (strong, nonatomic) NSString * saleMoney;
@property (strong, nonatomic) NSString * saleTime;
@property (strong, nonatomic) NSString * storeName;

@end

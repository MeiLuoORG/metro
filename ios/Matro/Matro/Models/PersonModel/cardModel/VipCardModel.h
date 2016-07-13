//
//  VipCardModel.h
//  Matro
//
//  Created by lang on 16/6/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface VipCardModel : MTLModel

@property (strong, nonatomic) NSString * cardNo;
@property (assign, nonatomic) int * cardTypeId;
@property (strong, nonatomic) NSString * cardTypeIdString;
@property (strong, nonatomic) NSString * cardTypeName;
@property (strong, nonatomic) NSString * cardID;
@property (assign, nonatomic) double points;
@property (assign, nonatomic) double consumeAmount;
@property (assign, nonatomic) int isDefault;
@property (assign, nonatomic) int status;
@property (strong, nonatomic) NSString * offLineCardId;
@property (strong, nonatomic) NSString * expireTime;
@property (strong, nonatomic) NSString * qrCode;

@property (strong, nonatomic) NSString * cardRule;
@property (strong, nonatomic) NSString * cardImg;
@property (strong, nonatomic) NSString * validCent;
@property (strong, nonatomic) NSString * yuE;

@end

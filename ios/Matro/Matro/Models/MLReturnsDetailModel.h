//
//  MLReturnsDetailModel.h
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLReturnsQuestiontype;
@class MLReturnsReturnInfo;
@interface MLReturnsDetailModel : NSObject
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,assign)float product_price;
@property (nonatomic,strong)NSArray *products;
@property (nonatomic,strong)NSArray *question_type;
@property (nonatomic,copy)NSString *return_code;
@property (nonatomic,copy)NSString *return_status;
@property (nonatomic,copy)NSString *return_add_time;

@property (nonatomic,strong)MLReturnsReturnInfo *returnInfo;


@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;


@end

@interface MLReturnsReturnInfo : NSObject
@property (nonatomic,copy)NSString *message;
@property (nonatomic,assign)NSInteger invoice;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *userphone;
@property (nonatomic,strong)NSArray *pic;
@property (nonatomic,strong)MLReturnsQuestiontype *question_type;

@end

@interface MLReturnsQuestiontype : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *content;
@end



//
//  MLReturnsDetailModel.h
//  Matro
//
//  Created by MR.Huang on 16/6/22.
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
@property (nonatomic,copy)NSString *transaction_price;
@property (nonatomic,copy)NSString *return_price;
@property (nonatomic,copy)NSString *pro_id;


@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;


@end

@interface MLReturnsReturnInfo : NSObject
@property (nonatomic,copy)NSString *message;
@property (nonatomic,assign)NSInteger invoice;
@property (nonatomic,strong)NSArray *pic;
@property (nonatomic,copy)NSString *question_type;
@property (nonatomic,copy)NSString *question_type_content;


@end

@interface MLReturnsQuestiontype : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *content;
@end




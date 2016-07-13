//
//  MLTuiHuoModel.h
//  Matro
//
//  Created by MR.Huang on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLTuiHuoModel : NSObject
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,assign)float product_price;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,strong)NSArray *products;
@property (nonatomic,copy)NSString *return_code;
@property (nonatomic,copy)NSString *statu;

@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;

@end
@interface MLTuiHuoProductModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,assign)float price;
@property (nonatomic,copy)NSString *setmeal;
@property (nonatomic,copy)NSString *pid;

@end

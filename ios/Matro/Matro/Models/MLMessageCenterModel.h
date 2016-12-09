//
//  MLMessageCenterModel.h
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLMessageCenterModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *last_time;
@property (nonatomic,copy)NSString *noread_num;
@end

@interface MLSystemMessageModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,assign)NSInteger send_type;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSString *order_id;
@end

@interface MLActiveMessageModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *link;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSInteger send_type;
@property (nonatomic,copy)NSString *create_time;

@end




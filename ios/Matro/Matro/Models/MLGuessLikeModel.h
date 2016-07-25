//
//  MLGuessLikeModel.h
//  Matro
//
//  Created by MR.Huang on 16/6/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLGuessLikeModel : NSObject

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *pname;
@property (nonatomic,copy)NSString *p_name;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,assign)float price;
@property (nonatomic,assign)float promotion_price;
@property (nonatomic,copy)NSString *catid;

@property (nonatomic,copy)NSString *userid;

@end

//
//  MLShippingaddress.h
//  Matro
//
//  Created by MR.Huang on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLShippingaddress : NSObject

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *pid;

@property (nonatomic,strong)NSArray *sub;



@end

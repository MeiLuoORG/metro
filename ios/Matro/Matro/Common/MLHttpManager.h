//
//  MLHttpManager.h
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface MLHttpManager : NSObject

+ (NSString *)md5:(NSString *)str;

+ (void)post:(NSString *)url params:(NSDictionary *)params m:(NSString *)m s:(NSString *)s success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)get:(NSString *)url params:(NSDictionary *)params m:(NSString *)m s:(NSString *)s success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end

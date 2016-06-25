//
//  MLGuessLikeModel.m
//  Matro
//
//  Created by 黄裕华 on 16/6/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGuessLikeModel.h"

@implementation MLGuessLikeModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

- (void)setPic:(NSString *)pic{
    _pic = pic;
    
    _pic = [NSString stringWithFormat:@"http://bbctest.matrojp.com/%@",pic];
    
}

@end

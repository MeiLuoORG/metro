//
//  MLGuessLikeModel.m
//  Matro
//
//  Created by MR.Huang on 16/6/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGuessLikeModel.h"
#import "HFSConstants.h"

@implementation MLGuessLikeModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

- (void)setPic:(NSString *)pic{
    _pic = pic;
    
    _pic = [NSString stringWithFormat:@"%@/%@",MATROJP_BASE_URL,pic];
    
}

@end

//
//  MLCollectstoresModel.h
//  Matro
//
//  Created by Matro on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLCollectstoresModel : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *shopid;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *shopname;
@property(nonatomic,copy)NSString *logo;

@property (nonatomic,assign)BOOL isSelect;


@end

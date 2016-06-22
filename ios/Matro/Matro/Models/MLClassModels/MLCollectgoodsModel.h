//
//  MLCollectgoodsModel.h
//  Matro
//
//  Created by Matro on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLCollectgoodsModel : NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *PID;
@property(nonatomic,copy)NSString *Pname;
@property(nonatomic,copy)NSString *Pimage;
@property(nonatomic,copy)NSString *Pprice;
@property (nonatomic,copy)NSArray *Psetmeal;

@property (nonatomic,assign)BOOL isSelect;


@end

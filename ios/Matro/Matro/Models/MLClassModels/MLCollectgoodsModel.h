//
//  MLCollectgoodsModel.h
//  Matro
//
//  Created by Matro on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLCollectgoodsModel : NSObject


@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)NSString *pname;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *price;



@property (nonatomic,strong)NSArray *setmeal;

@property (nonatomic,assign)BOOL isSelect;


@end


@interface MLSetmeal : NSObject

@property (nonatomic,copy)NSString *sid;
@property (nonatomic,copy)NSString *code;

@end

@interface MLPsetmeal : NSObject

@property(nonatomic,copy)NSString *SID;
@property(nonatomic,copy)NSString *Code;

@end



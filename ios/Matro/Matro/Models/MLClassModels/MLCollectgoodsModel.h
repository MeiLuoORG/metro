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
@property(nonatomic,strong)NSString *PID;
@property(nonatomic,strong)NSString *Pname;
@property(nonatomic,strong)NSString *Pimage;
@property(nonatomic,strong)NSString *Pprice;
@property (nonatomic,strong)NSArray *Psetmeal;

@property (nonatomic,assign)BOOL isSelect;


@end

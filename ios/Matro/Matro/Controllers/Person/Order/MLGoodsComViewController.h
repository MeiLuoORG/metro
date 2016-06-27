//
//  MLGoodsComViewController.h
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommentProductModel.h"


typedef void(^GoodsComSuccess)();

@interface MLGoodsComViewController : UIViewController

@property (nonatomic,strong)MLCommentProductModel *product;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)GoodsComSuccess goodsComSuccess;


@end

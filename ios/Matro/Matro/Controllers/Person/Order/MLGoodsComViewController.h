//
//  MLGoodsComViewController.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLCommentProductModel.h"


@interface MLGoodsComViewController : MLBaseViewController
@property (nonatomic,strong)MLCommentProductModel *product;
@property (nonatomic,copy)NSString *pid;


@end

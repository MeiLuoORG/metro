//
//  MLGoodsComViewController.h
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommentProductModel.h"
#import "YYAnimationIndicator.h"

typedef void(^GoodsComSuccess)();

@interface MLGoodsComViewController : UIViewController

@property (nonatomic,strong)MLCommentProductModel *product;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)GoodsComSuccess goodsComSuccess;
@property (nonatomic,copy)NSString *order_id;
//窗体加载进度
- (void)showLoadingView;
- (void)closeLoadingView;
@end

//
//  MLOrderComProductCell.h
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommentProductModel.h"


#define kOrderComProductCell @"OrderComProductCell"

typedef void(^GoodsComBlock)();

@interface MLOrderComProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shaidanBtn;


@property (nonatomic,strong)MLCommentProductModel *product;

@property (nonatomic,copy)GoodsComBlock  goodsComblock;


@end

//
//  MLProductComDetailHeadCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommentProductModel.h"
#import "MLScoreView.h"

#define kProductComDetailHeadCell  @"productComDetailHeadCell"
@interface MLProductComDetailHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIView *scoreBgView;
@property (nonatomic,strong)MLScoreView *scoreView;
@property (nonatomic,strong)MLProductCommentDetailProduct *productModel;


@end

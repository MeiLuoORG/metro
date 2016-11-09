//
//  MLOrderCenterTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonOrderModel.h"
#import "MLTuiHuoModel.h"
#import "MGSwipeTableCell.h"
#import "MLCommitOrderListModel.h"
#import "CPStepper.h"
#define kOrderCenterTableViewCell  @"orderCenterTableViewCell"
typedef void (^ShouhouBlock)();

@interface MLOrderCenterTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsDesc;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UIButton *shouhouBtn;
@property (weak, nonatomic) IBOutlet CPStepper *countNum;

@property (copy,nonatomic)ShouhouBlock shouhoublock;

@property (nonatomic,strong)MLPersonOrderProduct *productOrder;
@property (nonatomic,strong)MLTuiHuoProductModel *tuiHuoProduct;


@property (nonatomic,strong)MLOrderProlistModel *order_submit_product;


@end

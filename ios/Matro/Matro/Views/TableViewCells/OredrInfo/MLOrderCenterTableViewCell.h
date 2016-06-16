//
//  MLOrderCenterTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonOrderModel.h"

#define kOrderCenterTableViewCell  @"orderCenterTableViewCell"
@interface MLOrderCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsDesc;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@property (nonatomic,strong)MLPersonOrderProduct *productOrder;

@end

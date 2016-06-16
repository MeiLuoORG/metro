//
//  MLOrderInfoFooterTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonOrderModel.h"


#define kOrderInfoFooterTableViewCell  @"orderInfoFooterTableViewCell"
@interface MLOrderInfoFooterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)MLPersonOrderModel *orderList;

@end

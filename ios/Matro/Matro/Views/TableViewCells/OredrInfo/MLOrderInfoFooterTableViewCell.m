//
//  MLOrderInfoFooterTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderInfoFooterTableViewCell.h"

@implementation MLOrderInfoFooterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderList:(MLPersonOrderModel *)orderList{
    _orderList = orderList;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderList.product_price];
}



@end

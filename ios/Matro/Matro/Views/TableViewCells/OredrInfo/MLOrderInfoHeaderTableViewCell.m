//
//  MLOrderInfoHeaderTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderInfoHeaderTableViewCell.h"

@implementation MLOrderInfoHeaderTableViewCell

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
    self.shopName.text = _orderList.company;
    self.statusLabel.text = _orderList.statu_text;
    
}

@end

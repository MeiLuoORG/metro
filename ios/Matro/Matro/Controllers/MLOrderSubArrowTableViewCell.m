//
//  MLOrderSubArrowTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderSubArrowTableViewCell.h"

@implementation MLOrderSubArrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

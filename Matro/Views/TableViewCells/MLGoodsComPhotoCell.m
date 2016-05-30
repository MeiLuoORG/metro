//
//  MLGoodsComPhotoCell.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsComPhotoCell.h"

@implementation MLGoodsComPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)delClick:(id)sender {
    if (self.goodsComDelImageBlock) {
        self.goodsComDelImageBlock();
    }
}

@end

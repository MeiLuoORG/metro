//
//  MLBagGoodsTableViewCell.m
//  Matro
//
//  Created by hyk on 16/3/24.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBagGoodsTableViewCell.h"

@implementation MLBagGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClick:(id)sender {
    if (self.cellImageClick) {
        self.cellImageClick();
    }
}

@end

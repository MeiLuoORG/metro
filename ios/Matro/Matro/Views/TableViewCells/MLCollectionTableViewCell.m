//
//  MLCollectionTableViewCell.m
//  Matro
//
//  Created by Matro on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCollectionTableViewCell.h"

@implementation MLCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)checkBoxClick:(id)sender {
    
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.isSelected = !btn.isSelected;
    if (self.wishlistCheckBlock) {
        self.wishlistCheckBlock(btn.isSelected);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MLSureOrderHeaderCell.m
//  Matro
//
//  Created by Matro on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSureOrderHeaderCell.h"

@implementation MLSureOrderHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)actselectAddr:(id)sender {
    if (self.selectAddrblock) {
        self.selectAddrblock();
    }
}

@end

//
//  MLPropertysubCell.m
//  Matro
//
//  Created by Matro on 16/5/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPropertysubCell.h"

@implementation MLPropertysubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actSorce:(id)sender {
    if (self.sorceBlcok) {
        self.sorceBlcok();
    }
}

- (IBAction)actCharge:(id)sender {
    if (self.chargeBlock) {
        self.chargeBlock();
    }
}
- (IBAction)actMoney:(id)sender {
    if (self.moneyBlock) {
        self.moneyBlock();
    }
}

@end

//
//  MLsehnfenzhengCell.m
//  Matro
//
//  Created by Matro on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLsehnfenzhengCell.h"

@implementation MLsehnfenzhengCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)actSave:(id)sender {
    if (self.saveSFZActionBlock) {
        self.saveSFZActionBlock();
    }
}

@end

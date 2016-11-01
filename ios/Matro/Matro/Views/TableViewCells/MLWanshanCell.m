//
//  MLWanshanCell.m
//  Matro
//
//  Created by Matro on 2016/11/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLWanshanCell.h"
#import "HFSConstants.h"

@implementation MLWanshanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wanshanBtn.layer.cornerRadius = 4.f;
    self.wanshanBtn.layer.masksToBounds = YES;
    self.wanshanBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.wanshanBtn.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)wanshanClick:(id)sender {
    if (self.wanshanBlock) {
        self.wanshanBlock();
    }
}

@end

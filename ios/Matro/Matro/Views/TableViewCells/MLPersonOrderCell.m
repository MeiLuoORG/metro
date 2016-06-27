//
//  MLPersonOrderCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonOrderCell.h"

@implementation MLPersonOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)dafahuoClick:(id)sender {
    if (self.daifahuoBlcok) {
        self.daifahuoBlcok();
    }
}
- (IBAction)daifukuanClick:(id)sender {
    if (self.daifukuanBlock) {
        self.daifukuanBlock();
    }
}
- (IBAction)daishouhuoClick:(id)sender {
    if (self.daishouhuoBlock) {
        self.daishouhuoBlock();
    }
}

- (IBAction)tuihuoClick:(id)sender {
    if (self.tuihuoBlock) {
        self.tuihuoBlock();
    }
}



@end

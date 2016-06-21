//
//  MLTuiHuoFukuanTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuiHuoFukuanTableViewCell.h"

@implementation MLTuiHuoFukuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)haveAction:(id)sender {
    [self.haveBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    [self.notBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if (self.tuiHuoFukuanFaPiaoBlock) {
        self.tuiHuoFukuanFaPiaoBlock(YES);
    }
    
}
- (IBAction)notAction:(id)sender {
    [self.haveBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.notBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    if (self.tuiHuoFukuanFaPiaoBlock) {
        self.tuiHuoFukuanFaPiaoBlock(NO);
    }
    
}

@end

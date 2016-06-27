//
//  MLTuiHuoFukuanTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/20.
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
    [self.haveBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
    [self.notBtn setImage:[UIImage imageNamed:@"icon_weixuanzhong"] forState:UIControlStateNormal];
    if (self.tuiHuoFukuanFaPiaoBlock) {
        self.tuiHuoFukuanFaPiaoBlock(YES);
    }
    
}
- (IBAction)notAction:(id)sender {
    [self.haveBtn setImage:[UIImage imageNamed:@"icon_weixuanzhong"] forState:UIControlStateNormal];
    [self.notBtn setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
    if (self.tuiHuoFukuanFaPiaoBlock) {
        self.tuiHuoFukuanFaPiaoBlock(NO);
    }
    
}

- (void)setFapiao:(BOOL)fapiao{
    if (_fapiao != fapiao) {
        _fapiao = fapiao;
        if (_fapiao) {
            [self haveAction:nil];
        }else{
            [self notAction:nil];
        }
        
        
    }
}


@end

//
//  MLTuihuoCaozuoCell.m
//  Matro
//
//  Created by Matro on 2016/11/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuihuoCaozuoCell.h"

@implementation MLTuihuoCaozuoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.yuanView.layer.cornerRadius = 2.5f;
    self.yuanView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

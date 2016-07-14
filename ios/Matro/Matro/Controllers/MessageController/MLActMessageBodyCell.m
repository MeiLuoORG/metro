//
//  MLActMessageBodyCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLActMessageBodyCell.h"

@implementation MLActMessageBodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(delAction:)];
    longPressGr.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPressGr];
    
}

- (void)delAction:(id)sender{
    if (self.delAction) {
        self.delAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

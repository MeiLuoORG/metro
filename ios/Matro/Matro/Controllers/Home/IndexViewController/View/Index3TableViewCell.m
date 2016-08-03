//
//  Index3TableViewCell.m
//  Matro
//
//  Created by lang on 16/8/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "Index3TableViewCell.h"

@implementation Index3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)leftButton:(id)sender {
    if (self.index3Block) {
        self.index3Block(1);
    }
    NSLog(@"点击了左边按钮");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Index3Button_LEFT_NOTICIFICATION object:nil];
    
}
- (IBAction)rightButtonAction:(id)sender {
    if (self.index3Block) {
        self.index3Block(2);
    }
    NSLog(@"点击了右边的按钮");
    [[NSNotificationCenter defaultCenter] postNotificationName:Index3Button_RIGHT_NOTICIFICATION object:nil];
}
- (void)index3BlockAction:(Index3TableViewBlock)block{
    self.index3Block = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

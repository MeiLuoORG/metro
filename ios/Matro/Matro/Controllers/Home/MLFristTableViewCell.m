//
//  MLFristTableViewCell.m
//  Matro
//
//  Created by Matro on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLFristTableViewCell.h"

@implementation MLFristTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)hotspClick:(id)sender {
    
    if (self.hotspClick) {
        self.hotspClick();
    }
}
- (IBAction)hotppClick:(id)sender {
    
    if (self.hotppClick) {
        self.hotppClick();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

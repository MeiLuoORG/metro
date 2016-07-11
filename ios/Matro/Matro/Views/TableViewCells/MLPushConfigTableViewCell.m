//
//  MLPushConfigTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPushConfigTableViewCell.h"

@implementation MLPushConfigTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)swithChange:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if (self.pushConfigChange) {
        self.pushConfigChange(sw.isOn);
    }
}

@end

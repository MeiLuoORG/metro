//
//  MLReturnsDetailHeadCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsDetailHeadCell.h"
#import "HFSConstants.h"

@implementation MLReturnsDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bianjiBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.bianjiBtn.layer.borderWidth = 1.f;
    
    self.quxiaoBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.quxiaoBtn.layer.borderWidth = 1.f;
    
    
}
- (IBAction)tuiHuoAction:(id)sender {
    
}

- (IBAction)bianjiAction:(id)sender {
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

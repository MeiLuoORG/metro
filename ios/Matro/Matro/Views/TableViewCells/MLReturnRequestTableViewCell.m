//
//  MLReturnRequestTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnRequestTableViewCell.h"
#import "HFSConstants.h"

@implementation MLReturnRequestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.textView.layer.masksToBounds = YES;
    self.textView.placeholder = @"请描述您的问题";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textViewDidChange:(UITextView *)textView{
    self.countLabel.text = [NSString stringWithFormat:@"%lu/1000",(unsigned long)textView.text.length];
}
@end

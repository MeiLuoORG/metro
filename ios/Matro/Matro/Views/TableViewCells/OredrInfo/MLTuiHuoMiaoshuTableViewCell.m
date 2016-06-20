//
//  MLTuiHuoMiaoshuTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuiHuoMiaoshuTableViewCell.h"
#import "HFSConstants.h"

@interface MLTuiHuoMiaoshuTableViewCell ()<UITextViewDelegate>



@end

@implementation MLTuiHuoMiaoshuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = RGBA(200, 200, 200, 1).CGColor;
    self.textView.layer.cornerRadius = 5.f;
    self.textView.placeholder = @"请描述您遇到的问题";
    self.textView.delegate = self;
    
}


- (void)textViewDidChange:(UITextView *)textView{
    self.countLabel.text = [NSString stringWithFormat:@"%li/1000",textView.text.length];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

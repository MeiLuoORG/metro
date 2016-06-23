//
//  MLCommentDetailUserTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommentDetailUserTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MLCommentDetailUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBuyUser:(MLProductCommentDetailByuser *)buyUser{
    if (_buyUser != buyUser) {
        _buyUser = buyUser;
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:_buyUser.logo]];
        self.userName.text = _buyUser.user;
        self.timeLabel.text = _buyUser.uptime;
    }
}



@end

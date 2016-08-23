//
//  MLCommentDetailUserTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommentDetailUserTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@implementation MLCommentDetailUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 15.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBuyUser:(MLProductCommentDetailByuser *)buyUser{
    if (_buyUser != buyUser) {
        _buyUser = buyUser;
        
        if ([_buyUser.logo hasSuffix:@"webp"]) {
            [self.headImg setZLWebPImageWithURLStr:_buyUser.logo withPlaceHolderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
        } else {
            [self.headImg sd_setImageWithURL:[NSURL URLWithString:_buyUser.logo] placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
        }
        self.userName.text = _buyUser.user;
        self.timeLabel.text = _buyUser.uptime;
    }
}



@end

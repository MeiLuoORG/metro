//
//  MLWishlistTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLWishlistTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"


#import "Masonry.h"

@implementation MLWishlistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:right];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self addGestureRecognizer:left];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)leftAction:(UISwipeGestureRecognizer *)sender{
    
    self.priceLabel.hidden = YES;
    self.subTitleLabel.hidden = YES;
    
    [self.sideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImageView.mas_right);
        make.right.equalTo(self.mas_right);
    }];
    
}

- (void)rightAction:(UISwipeGestureRecognizer *)sender{
    self.priceLabel.hidden = NO;
    self.subTitleLabel.hidden = NO;
    [self.sideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right);
    }];
}

- (IBAction)addCartClick:(id)sender {
    if (self.wishlistAddCartBlock) {
        self.wishlistAddCartBlock();
    }
}

- (IBAction)delAction:(id)sender {
    if (self.wishlistDeleteBlock) {
        self.wishlistDeleteBlock();
    }
    
}
- (IBAction)checkBoxClick:(id)sender {
    
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.isSelected = !btn.isSelected;
    if (self.wishlistCheckBlock) {
        self.wishlistCheckBlock(btn.isSelected);
    }
}


/**
 *  拦截frame的设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 8;
    frame.origin.x = 8;
    frame.size.width -= 2 * 8;
    frame.size.height -= 8;
    [super setFrame:frame];
}

- (void)setWishlistModel:(MLWishlistModel *)wishlistModel{
    if (_wishlistModel != wishlistModel) {
        _wishlistModel = wishlistModel;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_wishlistModel.LSDJ];
        self.nameLabel.text = _wishlistModel.SPNAME;
        
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:_wishlistModel.IMGURL] placeholderImage:PLACEHOLDER_IMAGE];
        
        
    }
}



@end

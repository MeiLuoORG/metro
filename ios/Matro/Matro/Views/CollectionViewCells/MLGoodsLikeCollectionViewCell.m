//
//  MLGoodsLikeCollectionViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsLikeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@implementation MLGoodsLikeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setLikeModel:(MLGuessLikeModel *)likeModel{
    if (_likeModel != likeModel) {
        _likeModel = likeModel;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_likeModel.pic] placeholderImage:PLACEHOLDER_IMAGE];
        
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_likeModel.price];
        self.goodsName.text = _likeModel.pname;
        
    }
}



@end

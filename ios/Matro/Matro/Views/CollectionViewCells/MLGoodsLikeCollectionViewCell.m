//
//  MLGoodsLikeCollectionViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/14.
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
        NSString *priceStr = nil;
        if (_likeModel.promotion_price && _likeModel.promotion_price > 0) {
            priceStr = [NSString stringWithFormat:@"￥%.2f",_likeModel.promotion_price];
        }else{
            priceStr = [NSString stringWithFormat:@"￥%.2f",_likeModel.price];
        }
        self.priceLabel.text = priceStr;
        self.goodsName.text = _likeModel.pname;
    }
}



@end

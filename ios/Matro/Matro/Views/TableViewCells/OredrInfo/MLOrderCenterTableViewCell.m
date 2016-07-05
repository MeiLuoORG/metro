//
//  MLOrderCenterTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderCenterTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@implementation MLOrderCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setProductOrder:(MLPersonOrderProduct *)productOrder{
    if (_productOrder != productOrder) {
        _productOrder = productOrder;
        self.goodsName.text = _productOrder.name;
        self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_productOrder.price];
        self.goodsCount.text = [NSString stringWithFormat:@"*%@",_productOrder.num];
        self.goodsDesc.text = @"暂无数据";
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_productOrder.pic] placeholderImage:PLACEHOLDER_IMAGE];
        
    }

}

- (void)setTuiHuoProduct:(MLTuiHuoProductModel *)tuiHuoProduct{
    if (_tuiHuoProduct != tuiHuoProduct) {
        _tuiHuoProduct = tuiHuoProduct;
        self.goodsName.text = _tuiHuoProduct.name;
        self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_tuiHuoProduct.price];
        self.goodsDesc.text = @"暂无数据";
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_tuiHuoProduct.pic] placeholderImage:PLACEHOLDER_IMAGE];
        self.goodsCount.text = [NSString stringWithFormat:@"*%@",_tuiHuoProduct.num];
    }
}




@end

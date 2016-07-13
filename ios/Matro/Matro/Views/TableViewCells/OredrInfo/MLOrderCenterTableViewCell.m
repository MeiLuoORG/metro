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

        if (_productOrder.setmeal_str.length > 0) {
            self.goodsDesc.text = _productOrder.setmeal_str;
        }
        self.goodsDesc.text = [NSString stringWithFormat:@"%@",_productOrder.setmeal_str];
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_productOrder.pic] placeholderImage:PLACEHOLDER_IMAGE];
        
    }

}

- (void)setTuiHuoProduct:(MLTuiHuoProductModel *)tuiHuoProduct{
    if (_tuiHuoProduct != tuiHuoProduct) {
        _tuiHuoProduct = tuiHuoProduct;
        self.goodsName.text = _tuiHuoProduct.name;
        self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_tuiHuoProduct.price];
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_tuiHuoProduct.pic] placeholderImage:PLACEHOLDER_IMAGE];
        NSLog(@"%@",_tuiHuoProduct.pic);
        self.goodsCount.text = [NSString stringWithFormat:@"*%@",_tuiHuoProduct.num];
        
        
    }
}

- (void)setOrder_submit_product:(MLOrderProlistModel *)order_submit_product{
    if (_order_submit_product!=order_submit_product) {
        _order_submit_product = order_submit_product;
        self.goodsName.text = _order_submit_product.pname;
        self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_order_submit_product.price];
        if (_order_submit_product.setmealname.length > 0) {
                self.goodsDesc.text = _order_submit_product.setmealname;
        }
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_order_submit_product.pic] placeholderImage:PLACEHOLDER_IMAGE];
        self.goodsCount.text = [NSString stringWithFormat:@"*%ld",(long)_order_submit_product.num];
    }
}





@end

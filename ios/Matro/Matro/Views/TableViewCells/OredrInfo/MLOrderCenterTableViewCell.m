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
    self.shouhouBtn.layer.cornerRadius = 4.f;
    self.shouhouBtn.layer.masksToBounds = YES;
    self.shouhouBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.shouhouBtn.layer.borderWidth = 1.f;
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
        self.goodsCount.text = [NSString stringWithFormat:@"x%@",_productOrder.num];

        if (_productOrder.setmeal_str.length > 0) {
            self.goodsDesc.text = _productOrder.setmeal_str;
        }
        self.goodsDesc.text = [NSString stringWithFormat:@"%@",_productOrder.setmeal_str];
        
        if ([_productOrder.pic hasSuffix:@"webp"]) {
            [self.goodsImg setZLWebPImageWithURLStr:_productOrder.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_productOrder.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        
    }

}

- (void)setTuiHuoProduct:(MLTuiHuoProductModel *)tuiHuoProduct{
    if (_tuiHuoProduct != tuiHuoProduct) {
        _tuiHuoProduct = tuiHuoProduct;
        self.goodsName.text = _tuiHuoProduct.name;
        self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_tuiHuoProduct.price];
        
        if ([_tuiHuoProduct.pic hasSuffix:@"webp"]) {
            [self.goodsImg setZLWebPImageWithURLStr:_tuiHuoProduct.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_tuiHuoProduct.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        NSLog(@"%@--%@",_tuiHuoProduct.pic,_tuiHuoProduct.return_num);
        self.goodsCount.text = [NSString stringWithFormat:@"x%@",_tuiHuoProduct.num];
        self.countNum.maxValue = _tuiHuoProduct.num.integerValue;
        self.countNum.minValue = 1;
        [self.countNum setValue:[_tuiHuoProduct.return_num integerValue]];
        
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
        
        if ([_order_submit_product.pic hasSuffix:@"webp"]) {
            [self.goodsImg setZLWebPImageWithURLStr:_order_submit_product.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_order_submit_product.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        self.goodsCount.text = [NSString stringWithFormat:@"x%ld",(long)_order_submit_product.num];
    }
}

- (IBAction)shouhouClick:(id)sender {
    if (self.shouhoublock) {
        self.shouhoublock();
    }
}




@end

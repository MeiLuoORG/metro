//
//  MLProductOrderCell.m
//  Matro
//
//  Created by 黄裕华 on 16/5/10.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLProductOrderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HFSConstants.h"
#import "HFSUtility.h"

@implementation MLProductOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setProduct:(MLProductModel *)product{
    if (_product != product) {
        _product = product;
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:_product.IMGURL] placeholderImage:PLACEHOLDER_IMAGE];
        self.productNameLabel.text = _product.SPNAME?:_product.NAME;
        self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_product.LSDJ];
        self.numLabel.text = [NSString stringWithFormat:@"×%@",_product.XSSL];
        NSLog(@"%@",self.numLabel.text);
    }
}

@end

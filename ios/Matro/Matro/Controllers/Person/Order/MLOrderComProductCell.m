//
//  MLOrderComProductCell.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderComProductCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@implementation MLOrderComProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(MLProductModel *)product{
    if (_product != product) {
        _product = product;
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:_product.IMGURL] placeholderImage:PLACEHOLDER_IMAGE];
        self.titleLabel.text = _product.SPNAME;
        
    }
}

- (IBAction)goodsComClick:(id)sender {
    if (self.goodsComblock) {
        self.goodsComblock();
    }
}

@end

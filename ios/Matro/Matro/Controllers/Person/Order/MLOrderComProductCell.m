//
//  MLOrderComProductCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/5.
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
    
    self.shaidanBtn.layer.borderWidth = 1.f;
    self.shaidanBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setProduct:(MLCommentProductModel *)product{
    if (_product != product) {
        _product = product;
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:_product.pic]];
        self.titleLabel.text = _product.name;
        if (_product.is_commented == 0) {
            [self.shaidanBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
        }else{
            [self.shaidanBtn setTitle:@"查看评价" forState:UIControlStateNormal];
        }
        
    }
}




- (IBAction)goodsComClick:(id)sender {
    if (self.goodsComblock) {
        self.goodsComblock();
    }
}

@end

//
//  MLCartHeadCollectionReusableView.m
//  Matro
//
//  Created by MR.Huang on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCartHeadCollectionReusableView.h"

@implementation MLCartHeadCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)checkBoxChange:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.cartSelected = !btn.cartSelected;
    self.shopingCart.select_All = btn.cartSelected;
    
    if (self.cartHeadBlock) {
        self.cartHeadBlock(btn.cartSelected);
    }
}
- (IBAction)youhuiAction:(id)sender {
    if (self.youHuiBlock) {
        self.youHuiBlock();
    }
}


- (void)setShopingCart:(MLShopingCartModel *)shopingCart{
    if (_shopingCart != shopingCart) {
        _shopingCart = shopingCart;
        self.titleLabel.text = _shopingCart.warehouse_nickname;
        self.checkBox.cartSelected = _shopingCart.select_All;
        self.youhuiBtn.hidden = !(_shopingCart.dpyhq.count>0);
    }
}

@end

//
//  MLShopBagTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopBagTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MLShopBagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.countField.maxValue = 10;
    self.countField.minValue = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProlistModel:(MLProlistModel *)prolistModel{
    if (_prolistModel != prolistModel) {
        _prolistModel = prolistModel;
        [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_prolistModel.pic]];
        self.goodName.text = _prolistModel.pname;
        self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _prolistModel.pro_price];
        self.checkBox.cartSelected = (_prolistModel.is_check == 1);
        self.manjianLabel.hidden = !(_prolistModel.mjtitle.length > 0);
        if (_prolistModel.setmealname.length > 0) {
            self.goodDesc.text = [NSString stringWithFormat:@"%@：%@",_prolistModel.setmealname,_prolistModel.setmeal];
        }
        [self.countField setTextValue:_prolistModel.num];
        
    }
}

- (void)setOfflineCart:(OffLlineShopCart *)offlineCart{
    if (_offlineCart != offlineCart) {
        _offlineCart = offlineCart;
        [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_offlineCart.pic]];
        self.goodName.text = _offlineCart.pname;
        self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _offlineCart.pro_price];
        self.checkBox.cartSelected = NO;
        self.goodDesc.hidden = YES;
        self.manjianLabel.hidden = !(_offlineCart.mjtitle.length > 0);
        [self.countField setTextValue:_offlineCart.num];
    }
}

- (IBAction)changeCheckBox:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.cartSelected = !btn.cartSelected;
    //    self.prolistModel.is_check = btn.cartSelected?1:0;
    if (self.shopCartCheckBoxBlock) {
        self.shopCartCheckBoxBlock(btn.cartSelected);
    }
}



@end

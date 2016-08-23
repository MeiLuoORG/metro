//
//  MLShopBagTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopBagTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@implementation MLShopBagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProlistModel:(MLProlistModel *)prolistModel{
    if (_prolistModel != prolistModel) {
        _prolistModel = prolistModel;
        [self.countField setTextValue:_prolistModel.num];
        if ([_prolistModel.stock isKindOfClass:[NSNull class]]) {
            self.countField.maxValue = _prolistModel.amount;
        }else{
        
            self.countField.maxValue = [_prolistModel.stock integerValue];
        }
        self.countField.minValue = 1;
        
        if ([_prolistModel.pic hasSuffix:@"webp"]) {
            [self.goodImgView setZLWebPImageWithURLStr:_prolistModel.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_prolistModel.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        self.goodName.text = _prolistModel.pname;
//        if ([_prolistModel.pro_setmeal_price isEqual:nil]) {
//             self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _prolistModel.realPrice];
//        }else{
//            float realPrice = [_prolistModel.pro_setmeal_price floatValue];
//             self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f",realPrice];
//        }
       self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _prolistModel.realPrice];
        self.checkBox.cartSelected = (_prolistModel.is_check == 1);
        self.manjianLabel.hidden = !(_prolistModel.mjtitle.length > 0);
        if (_prolistModel.setmealname.length> 0 ) {
             self.goodDesc.text = [NSString stringWithFormat:@"%@",_prolistModel.setmealname];
        }
    
    }
}

- (void)setOfflineCart:(OffLlineShopCart *)offlineCart{
    if (_offlineCart != offlineCart) {
        _offlineCart = offlineCart;
       
        if ([_offlineCart.pic hasSuffix:@"webp"]) {
            [self.goodImgView setZLWebPImageWithURLStr:_offlineCart.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
             [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_offlineCart.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        self.goodName.text = _offlineCart.pname;
        self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _offlineCart.pro_price];
        self.checkBox.cartSelected = NO;
        self.manjianLabel.hidden = !(_offlineCart.mjtitle.length > 0);
        [self.countField setTextValue:_offlineCart.num];
        self.countField.maxValue = _offlineCart.amount;
        self.countField.minValue = 1;
        if (_offlineCart.setmeal.length> 0 ) {
            self.goodDesc.text = [NSString stringWithFormat:@"%@",_offlineCart.setmeal];
            
        }
    }
}

- (IBAction)changeCheckBox:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.cartSelected = !btn.cartSelected;
    if (self.shopCartCheckBoxBlock) {
        self.shopCartCheckBoxBlock(btn.cartSelected);
    }
}




@end

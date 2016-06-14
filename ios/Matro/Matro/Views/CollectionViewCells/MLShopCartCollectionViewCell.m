//
//  MLShopCartCollectionViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopCartCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@interface MLShopCartCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *actlabel;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;

@end

@implementation MLShopCartCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.actlabel.layer.borderColor = RGBA(255, 78, 37, 1).CGColor;
    self.giftLabel.layer.borderColor = RGBA(255, 78, 37, 1).CGColor;
    self.countField.maxValue = 10;
    self.countField.minValue = 1;
}


- (void)setProlistModel:(MLProlistModel *)prolistModel{
    if (_prolistModel != prolistModel) {
        _prolistModel = prolistModel;
        [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_prolistModel.pic]];
        self.goodName.text = _prolistModel.pname;
        self.goodDesc.text = @"暂无数据";
        self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _prolistModel.pro_price];
        self.checkBox.cartSelected = (_prolistModel.is_check == 1);
//        if (_prolistModel.shipfree_val > 0) { //说明是有包邮情况的
            self.topConstraints.constant = 25;
            self.actDesc.text = [NSString stringWithFormat:@"满%lu包邮",(long)_prolistModel.shipfree_val];
//        }
//        else{
//            self.topConstraints.constant = 0;
//        }
        self.giftDesc.text = @"暂无数据";
        
        self.countField.value = _prolistModel.num;
        
        
        
    }
}







- (IBAction)changeCheckBox:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.cartSelected = !btn.cartSelected;
    self.prolistModel.is_check = btn.cartSelected?1:0;
    
}


@end

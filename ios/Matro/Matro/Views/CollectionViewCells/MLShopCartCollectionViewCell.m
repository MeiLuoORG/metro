//
//  MLShopCartCollectionViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopCartCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@interface MLShopCartCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *actlabel;
@property (nonatomic,assign)BOOL showDel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MLShopCartCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.actlabel.layer.borderColor = RGBA(255, 78, 37, 1).CGColor;
    self.countField.maxValue = 10;
    self.countField.minValue = 1;
    
    
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:rightRecognizer];
    
}



- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (!_showDel) {
            [UIView animateWithDuration:0.2 animations:^{
                self.countL.constant = 8 + 80;
                self.checkBoxL.constant = 16 - 80;
                self.actL.constant = 39 - 80;

            } completion:^(BOOL finished) {
                _showDel = YES;
            }];
        }

    }
    else{//收齐
        [UIView animateWithDuration:0.2 animations:^{
            self.countL.constant = 8;
            self.checkBoxL.constant = 16;
            self.actL.constant = 39;
        } completion:^(BOOL finished) {
            _showDel = NO;
        }];
    }
}


- (void)setProlistModel:(MLProlistModel *)prolistModel{
    if (_prolistModel != prolistModel) {
        _prolistModel = prolistModel;
        self.showDel = NO;
        [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_prolistModel.pic]];
        self.goodName.text = _prolistModel.pname;
        self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _prolistModel.pro_price];
        self.checkBox.cartSelected = (_prolistModel.is_check == 1);
        
        [self.countField setTextValue:_prolistModel.num];
        
    }
}




- (IBAction)delAction:(id)sender {
    
    if (self.shopCartDelBlock) {
        self.shopCartDelBlock();
    }
}



- (IBAction)changeCheckBox:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.cartSelected = !btn.cartSelected;
    self.prolistModel.is_check = btn.cartSelected?1:0;
    if (self.shopCartCheckBoxBlock) {
        self.shopCartCheckBoxBlock();
    }
}


@end

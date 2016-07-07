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
    
    
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
//    [self.contentView addGestureRecognizer:pan];
    
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:rightRecognizer];
    
    
}


- (void)panAction:(UIPanGestureRecognizer *)recognizer{
    
    
    
}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (!_showDel) {
            
            [UIView animateWithDuration:1 delay:0.3 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.contentView.center = CGPointMake(self.contentView.center.x-60, self.contentView.center.y);
            } completion:^(BOOL finished) {
                _showDel = YES;
            }];
        }
    }
    else{//收齐
        [UIView animateWithDuration:1 delay:0.3 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentView.center = CGPointMake(self.contentView.center.x+60, self.contentView.center.y);
        } completion:^(BOOL finished) {
            _showDel = YES;
        }];
    }
}


- (void)setProlistModel:(MLProlistModel *)prolistModel{
    if (_prolistModel != prolistModel) {
        _prolistModel = prolistModel;
        self.showDel = NO;
        self.countL.constant = 8;
        self.checkBoxL.constant = 16;
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
        self.showDel = NO;
        self.countL.constant = 8;
        self.checkBoxL.constant = 16;
        [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_offlineCart.pic]];
        self.goodName.text = _offlineCart.pname;
        self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _offlineCart.pro_price];
        self.checkBox.cartSelected = NO;
        self.goodDesc.hidden = YES;
        self.manjianLabel.hidden = !(_offlineCart.mjtitle.length > 0);
        [self.countField setTextValue:_offlineCart.num];
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
//    self.prolistModel.is_check = btn.cartSelected?1:0;
    if (self.shopCartCheckBoxBlock) {
        self.shopCartCheckBoxBlock(btn.cartSelected);
    }
}





@end

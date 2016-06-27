//
//  MLCheckBoxButton.m
//  Matro
//
//  Created by MR.Huang on 16/5/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCheckBoxButton.h"

@implementation MLCheckBoxButton


- (void)setIsSelected:(BOOL)isSelected{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected) {
            [self setImage:[UIImage imageNamed:@"zSelected"] forState:UIControlStateNormal];
        }
        else{
            [self setImage:[UIImage imageNamed:@"zSelectBtn"] forState:UIControlStateNormal];
        }
    }
}


- (void)setCartSelected:(BOOL)cartSelected{
    if (_cartSelected != cartSelected) {
        _cartSelected = cartSelected;
        if (_cartSelected) {
            [self setImage:[UIImage imageNamed:@"zSelected"] forState:UIControlStateNormal];
        }
        else{
            [self setImage:[UIImage imageNamed:@"zSelectBtn"] forState:UIControlStateNormal];
        }
    }
}


- (void)setAddSelected:(BOOL)addSelected{
    if (_addSelected != addSelected) {
        _addSelected = addSelected;
        if (_addSelected) {
            [self setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateNormal];
        }
        else{
            [self setImage:[UIImage imageNamed:@"icon_weixuanzhong"] forState:UIControlStateNormal];
        }
        
        
    }
}

@end

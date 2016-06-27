//
//  MLWishlistFootView.m
//  Matro
//
//  Created by MR.Huang on 16/5/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLWishlistFootView.h"
#import "HFSConstants.h"

@implementation MLWishlistFootView

+ (MLWishlistFootView *)WishlistFootView{
    return LoadNibWithSelfClassName;
}

- (IBAction)selectAllClick:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.isSelected = !btn.isSelected;
    if (self.selectAllBlock) {
        self.selectAllBlock(btn.isSelected);
    }
}
- (IBAction)addCartClick:(id)sender {
    if (self.addCartBlock) {
        self.addCartBlock();
    }
}

- (IBAction)delClick:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

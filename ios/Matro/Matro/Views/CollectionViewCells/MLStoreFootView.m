//
//  MLStoreFootView.m
//  Matro
//
//  Created by Matro on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLStoreFootView.h"
#import "HFSConstants.h"

@implementation MLStoreFootView

+ (MLStoreFootView *)MLStoreFootView{
    return LoadNibWithSelfClassName;
}

- (IBAction)selectAllClick:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.isSelected = !btn.isSelected;
    if (self.selectAllBlock) {
        self.selectAllBlock(btn.isSelected);
    }
}

- (IBAction)cancelClick:(id)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end

//
//  MLShopCartMoreCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopCartMoreCell.h"
#import "UIButton+HeinQi.h"
@implementation MLShopCartMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)moreAction:(id)sender {
    if (self.moreActionBlock) {
        self.moreActionBlock();
    }
}

@end

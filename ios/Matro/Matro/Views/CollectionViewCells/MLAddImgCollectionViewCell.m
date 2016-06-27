//
//  MLAddImgCollectionViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddImgCollectionViewCell.h"

@implementation MLAddImgCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)delAction:(id)sender {
    if (self.addImgCollectionDelBlock) {
        self.addImgCollectionDelBlock();
    }
}

@end

//
//  MLFootTableViewCell.m
//  Matro
//
//  Created by Matro on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLFootTableViewCell.h"
#import "Masonry.h"
@implementation MLFootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:rightRecognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.sideView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pimage.mas_right);
            make.right.equalTo(self.mas_right);
        }];

    }
    else{
        [self.sideView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right);
        }];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

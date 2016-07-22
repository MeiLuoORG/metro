//
//  LingQuQuanCell.m
//  Matro
//
//  Created by lang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "LingQuQuanCell.h"
#import "HFSUtility.h"
#import "CommonHeader.h"

@implementation LingQuQuanCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //[self.selectButton setBackgroundImage:[UIImage imageNamed:@"zSelectBtn"] forState:UIControlStateNormal];
    //[self.selectButton setBackgroundImage:[UIImage imageNamed:@"zSelected"] forState:UIControlStateSelected];
    
    self.backView.layer.cornerRadius = 4.0f;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.backView.layer.borderWidth = 1.0f;
    
    
    NSLog(@"优惠券页面的bounds为：%g+++%g++,frame:+++%g+++%g+",self.topView.bounds.size.width,self.topView.bounds.size.height,self.topView.frame.size.width,self.topView.frame.size.height);
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(4.0,4.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.topView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    //self.topView.layer.mask = maskLayer2;
    
    
    /*
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.layer.borderWidth = 1.0f;
    */
    self.youXiaoQiLabel.adjustsFontSizeToFitWidth = YES;
    self.youXiaoQiLabel.minimumScaleFactor = 0.5;
    self.pingTaiTypeLabel.adjustsFontSizeToFitWidth = YES;
    self.pingTaiTypeLabel.minimumScaleFactor = 0.5;
    self.miaoShuLabel.adjustsFontSizeToFitWidth = YES;
    self.miaoShuLabel.minimumScaleFactor = 0.5f;
    self.mingChengLabel.adjustsFontSizeToFitWidth = YES;
    self.mingChengLabel.minimumScaleFactor = 0.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  MLOrderSubComCell.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderSubComCell.h"
#import "MLScoreView.h"

@implementation MLOrderSubComCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
    MLScoreView *view1 = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    view1.starViewBlock = ^(NSInteger score){
        if (self.shangpinBlock) {
            self.shangpinBlock(score);
        }
    };
    [self.shangpingBgView addSubview:view1];
    
    MLScoreView *view2 = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    view2.starViewBlock = ^(NSInteger score){
        if (self.wuliuBlock) {
            self.wuliuBlock(score);
        }
    };
    [self.wuliuBgView addSubview:view2];
    
    MLScoreView *view3 = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    view3.starViewBlock = ^(NSInteger score){
        if (self.fuwuBlock) {
            self.fuwuBlock(score);
        }
    };
    [self.fuwuBgView addSubview:view3];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

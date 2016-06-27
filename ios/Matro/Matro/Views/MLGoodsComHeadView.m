//
//  MLGoodsComHeadView.m
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsComHeadView.h"
#import "HFSConstants.h"
#import "MLScoreView.h"

@implementation MLGoodsComHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textView.layer.cornerRadius = 1.f;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.textView.placeholder = @"请写下您的购物体会，为其他小伙伴提供参考";
    MLScoreView *scoreView = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    scoreView.starViewBlock = ^(NSInteger score){
        if (self.comScore) {
            self.comScore(score);
        }
    };
    [self.scoreBgView addSubview:scoreView];
    
    
}


+ (MLGoodsComHeadView *)goodsComHeadView{
    return LoadNibWithSelfClassName;
}

- (void)textViewDidChange:(UITextView *)textView{
    self.countLabel.text = [NSString stringWithFormat:@"%lu/1000",(unsigned long)textView.text.length];
}
@end

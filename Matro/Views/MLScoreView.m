//
//  MLScoreView.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLScoreView.h"
#import "Masonry.h"



@implementation MLScoreView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupBaseView];
    }
    return self;
}
- (void)setupBaseView{
    CGFloat btnCenterY = self.frame.size.height/2;
    CGFloat btnW = 20;
    CGFloat btnH = 20;
    NSMutableArray *tmp = [NSMutableArray array];
    
    for (NSInteger i = 0; i<5; i++) {
        CGFloat btnCenterX = btnW*i+10;
        UIButton *btn = [UIButton new];
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        btn.center = CGPointMake(btnCenterX, btnCenterY);
        [btn setImage:[UIImage imageNamed:@"Star_small1"] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [tmp addObject:btn];

    }
    self.starArray = [tmp copy];
}

- (void)btnClick:(UIButton *)sender{
    for (UIButton *btn in self.starArray)
    {
        [btn setImage:[UIImage imageNamed:@"Star_small1"] forState:UIControlStateNormal];
    }
    NSInteger index = sender.tag - 100;
    for (int i = 0; i<=index; i++)
    {
        UIButton *btn = (UIButton *)self.starArray[i];
        [btn setImage:[UIImage imageNamed:@"Star_small2"] forState:UIControlStateNormal];
    }
    if(self.starViewBlock)
    {
        self.starViewBlock(index+1);
    }
}



@end

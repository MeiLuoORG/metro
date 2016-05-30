//
//  NavTopCommonImage.m
//  1PXianProject
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 JiJianNetwork. All rights reserved.
//

#import "NavTopCommonImage.h"

@implementation NavTopCommonImage

- (instancetype)initWithTitle:(NSString *)title 
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.frame = CGRectMake(0, 0, SIZE_WIDTH, 64);
         
        self.backgroundColor = [CustomeColorObject makeColorWithHue:46 withSaturation:1 withbrightness:1 withAlpha:1.0f];
        
        //self.image = [UIImage imageNamed:@"navBackground@2x.png"];
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( (SIZE_WIDTH-100)/2, 30, 100, 35)];
        titleLabel.text = title;
        titleLabel.font = [UIFont fontWithName:EN_FONT size:18.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //[self addSubview:navBackImage];

    }
    return self;
}

- (void)loadBackButton{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setFrame:CGRectMake(10, 33, 35, 20)];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    //[backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //[backBtn setBackgroundColor:[UIColor blueColor]];
    [backBtn setImage:[UIImage imageNamed:@"img28"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn@2x.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
}

- (void)loadRightButton{


}

- (void)backBtnAction:(UIButton *)sender{
    self.backsBlock(YES);//block方法
}

- (void)backButtonAction:(BackBtnBlock)block
{
    self.backsBlock = block;

}

- (void)rightBtnAction:(UIButton *)sender{
    self.rightBlock(YES);
    
}

- (void)rightButtonBlockAction:(RightBtnBlock)block{
    self.rightBlock = block;
}


- (void)loadNavImageWithTitle:(NSString *)title{

    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

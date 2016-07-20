//
//  YYAnimationIndicator.m
//  AnimationIndicator
//
//  Created by 王园园 on 14-8-26.
//  Copyright (c) 2014年 王园园. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "YYAnimationIndicator.h"


#define MS_RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

@implementation YYAnimationIndicator{
    UIView *postView;
}

-(void)initView:(UIView*)InView{
    postView=InView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isAnimating = NO;
        //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width,frame.size.height-10)];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, frame.size.width-20,49)];
        imageView.backgroundColor= [UIColor clearColor];
        [self addSubview:imageView];
        //设置动画帧
        imageView.animationImages=[NSArray arrayWithObjects: [UIImage imageNamed:@"progress_bg_01"],
                                   [UIImage imageNamed:@"progress_bg_02"],
                                   [UIImage imageNamed:@"progress_bg_03"],
                                   [UIImage imageNamed:@"progress_bg_04"],
                                   [UIImage imageNamed:@"progress_bg_05"],
                                   [UIImage imageNamed:@"progress_bg_06"],
                                   [UIImage imageNamed:@"progress_bg_07"],
                                   [UIImage imageNamed:@"progress_bg_08"],
                                   [UIImage imageNamed:@"progress_bg_09"],
                                   [UIImage imageNamed:@"progress_bg_10"],
                                   [UIImage imageNamed:@"progress_bg_11"],
                                   [UIImage imageNamed:@"progress_bg_12"],
                                   nil ];
        
        
       // Infolabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        Infolabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 59, frame.size.width, 20)];
        Infolabel.backgroundColor = [UIColor clearColor];
        Infolabel.textAlignment = NSTextAlignmentCenter;
        Infolabel.textColor = MS_RGBA(200, 35, 35, 1.0);
        Infolabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14.0f];
        [self addSubview:Infolabel];
        self.layer.hidden = YES;
    }
    return self;
}


- (void)startAnimation
{
    _isAnimating = YES;
    self.layer.hidden = NO;
    [self doAnimation];
}

-(void)doAnimation{
    
    Infolabel.text = _loadtext;
    
    //设置动画总时间
    imageView.animationDuration=2.0;
    //设置重复次数,0表示不重复
    imageView.animationRepeatCount=0;
    //开始动画
    [imageView startAnimating];
}

- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
{
    _isAnimating = NO;
    Infolabel.text = text;
    if(type){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView stopAnimating];
            self.layer.hidden = YES;
            self.alpha = 1;
        }];
    }else{
        [imageView stopAnimating];
        [imageView setImage:[UIImage imageNamed:@"3"]];
    }
    
}


-(void)setLoadText:(NSString *)text;
{
    if(text){
        _loadtext = text;
    }
}

@end

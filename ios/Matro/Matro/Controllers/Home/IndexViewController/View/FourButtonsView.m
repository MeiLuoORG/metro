//
//  FourButtonsView.m
//  Matro
//
//  Created by lang on 16/8/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "FourButtonsView.h"

@implementation FourButtonsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*
- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"执行了awakeFromNib方法");
}
*/
/*
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"FourButtonsView" owner:self options:nil]objectAtIndex:0];
        [self addSubview:view];
    }
    return self;
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
  
    if(self = [super initWithFrame:frame]){
    
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"FourButtonsView" owner:self options:nil]objectAtIndex:0];
         [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    
    return self;
}

- (IBAction)firstControlAction:(UIControl *)sender {

    NSLog(@"点击按钮对应个Tag值为%ld",sender.tag);
    if (self.block) {
        self.block(sender.tag);
    }
    else{
        NSLog(@"++++block为空");
    }
    
    //[self performSelectorOnMainThread:@selector(senderAction:) withObject:sender waitUntilDone:YES];
    
    
}
- (IBAction)secondAction:(UIControl *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
    else{
        NSLog(@"++++block为空");
    }
    
    
    
}

- (void)senderAction:(UIControl *)sender{
    NSLog(@"点击按钮对应个Tag值为%ld",sender.tag);
    self.block(sender.tag);
    
}


- (void)fourButtonBlockAction:(FourButtonBlock)block{
    self.block = block;
}

@end

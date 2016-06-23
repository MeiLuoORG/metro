//
//  YMPhoneCondeButton.m
//  YMShare
//
//  Created by MR.Huang on 16/1/26.
//  Copyright © 2016年 YMKJ. All rights reserved.
//

#import "YMPhoneCondeButton.h"

@interface YMPhoneCondeButton()
@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationToValidity;
@end


@implementation YMPhoneCondeButton

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.enabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.enabled = YES;
    }
    return self;
}

- (void)awakeFromNib{
    self.enabled = self.isEnabled;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        [self setTitle:@"发送验证码" forState:UIControlStateNormal];
       }else if ([self.titleLabel.text isEqualToString:@"发送验证码"]){
        [self setTitle:@"正在发送..." forState:UIControlStateNormal];
    }
}

- (void)startUpTimer{
    _durationToValidity = 60;
    
    if (self.isEnabled) {
        self.enabled = NO;
    }
    [self setTitle:[NSString stringWithFormat:@"%.0fs重新发送", _durationToValidity] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}



- (void)invalidateTimer{
    if (!self.isEnabled) {
        self.enabled = YES;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%.0f 秒", _durationToValidity];//防止 button_title 闪烁
        [self setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
    }
}

@end

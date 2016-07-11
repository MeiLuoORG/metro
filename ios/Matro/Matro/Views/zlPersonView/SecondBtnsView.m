//
//  SecondBtnsView.m
//  Matro
//
//  Created by lang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "SecondBtnsView.h"
#import "HFSConstants.h"

@implementation SecondBtnsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    //self.headBtn.layer.cornerRadius = 32.f;
    //self.headBtn.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    //self.headBtn.layer.masksToBounds = YES;
    //[self.daiFuButton addTarget:self action:@selector(butonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)daiFuButtonsAction:(UIButton *)sender {
   
    
}

- (IBAction)daFuControlAction:(UIControl *)sender {
    NSLog(@"点击了待付款Control");
    if (self.daiFuBLock) {
        self.daiFuBLock(YES);
    }
}

- (IBAction)daiFaControlAction:(UIControl *)sender {
    NSLog(@"+++++");
    if (self.daiFaHuoBLock) {
        self.daiFaHuoBLock(YES);
    }
    
}



- (IBAction)daiPingControlAction:(UIControl *)sender {
    
    NSLog(@"+++++");
    if (self.daiPingBLock) {
        self.daiPingBLock(YES);
    }
}


- (IBAction)tuiHuoControlAction:(UIControl *)sender {
    
    NSLog(@"+++++");
    if (self.tuiHuoBLock) {
        self.tuiHuoBLock(YES);
    }
}


- (IBAction)quanBuControlAction:(UIControl *)sender {
    NSLog(@"+++++");
    if (self.quanBuBLock) {
        self.quanBuBLock(YES);
    }
    
}


+ (SecondBtnsView *)personHeadView{
    return LoadNibWithSelfClassName;
}
@end

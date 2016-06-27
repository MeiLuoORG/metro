//
//  MLPersonHeadView.m
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonHeadView.h"
#import "HFSConstants.h"
#import "CommonHeader.h"

@implementation MLPersonHeadView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.headBtn.layer.cornerRadius = 32.f;
    self.headBtn.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.headBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 4.0f;
    self.regBtn.layer.cornerRadius = 4.0f;
    
    [self setFrame:CGRectMake(0, 0, SIZE_WIDTH, 125.0f)];
    self.backgroundImg.userInteractionEnabled = YES;
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.backgroundImg addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)keyboardHide:(id)sender{

    if (self.imageBlock) {
        self.imageBlock();
    }
    
    
}

+ (MLPersonHeadView *)personHeadView{
    return LoadNibWithSelfClassName;
}
- (IBAction)rightButtonAction:(UIButton *)sender {
    
    if (self.imageBlock) {
        self.imageBlock();
    }
    
}

- (IBAction)headClick:(id)sender {
    if (self.imageBlock) {
        self.imageBlock();
    }
}

- (IBAction)loginClick:(id)sender {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (IBAction)regClick:(id)sender {
    if (self.regBlock) {
        self.regBlock();
    }
}


@end

//
//  MLPersonHeadView.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
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

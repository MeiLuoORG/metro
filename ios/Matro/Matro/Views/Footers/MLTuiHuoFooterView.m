//
//  MLTuiHuoFooterView.m
//  Matro
//
//  Created by MR.Huang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuiHuoFooterView.h"
#import "HFSConstants.h"

@implementation MLTuiHuoFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 3.f;
    
}


+ (MLTuiHuoFooterView *)footView{
    return LoadNibWithSelfClassName;
}


@end

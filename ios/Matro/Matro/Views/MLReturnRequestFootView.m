//
//  MLReturnRequestFootView.m
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnRequestFootView.h"
#import "HFSConstants.h"

@implementation MLReturnRequestFootView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.imageBgView.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.imageBgView.layer.borderWidth = 1.f;
    self.imageBgView.layer.masksToBounds = YES;
    self.cameraBtn.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.cameraBtn.layer.borderWidth = 1.f;
    self.cameraBtn.layer.masksToBounds = YES;
    
}


+ (MLReturnRequestFootView *)returnFootView{
    return LoadNibWithSelfClassName;
}



@end

//
//  MLReturnsHeader.m
//  Matro
//
//  Created by MR.Huang on 16/5/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsHeader.h"
#import "HFSConstants.h"

@implementation MLReturnsHeader



- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
}


+ (MLReturnsHeader *)returnsHeader{
    return LoadNibWithSelfClassName;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        if (self.searchBlock) {
            self.searchBlock(textField.text);
        }
    }
    return YES;
}


@end

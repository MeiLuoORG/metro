//
//  nameLableTitle.m
//  Goldmantis
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 lang. All rights reserved.
//

#import "nameLableTitle.h"

@implementation nameLableTitle

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self){
        UILabel *namelable=[[UILabel alloc]init];
        namelable.text = title;
        namelable.font = [UIFont fontWithName:EN_FONT size:14.0f];
        namelable.textAlignment = NSTextAlignmentCenter;
        namelable.textColor=[UIColor whiteColor];
        [self addSubview:namelable];
        [namelable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).with.offset(0);
            make.height.mas_offset(@30);
            make.width.mas_offset(@120);
        }];
        
        
    }
    return self;
}


@end

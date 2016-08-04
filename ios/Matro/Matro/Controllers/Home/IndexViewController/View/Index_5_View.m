//
//  Index_5_View.m
//  Matro
//
//  Created by lang on 16/8/4.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "Index_5_View.h"

@implementation Index_5_View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"Index_5_View" owner:self options:nil]objectAtIndex:0];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}



@end

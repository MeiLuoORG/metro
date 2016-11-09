//
//  MLTuihuojilvFooterView.m
//  Matro
//
//  Created by Matro on 2016/11/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuihuojilvFooterView.h"

@implementation MLTuihuojilvFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MLTuihuojilvFooterView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return nil;
        }
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor clearColor];
        ((UITableViewHeaderFooterView *)arrayOfViews[0]).backgroundView = backgroundView;
        
        self = arrayOfViews[0];
        
    }
    
    //_headerImageView.userInteractionEnabled = YES;
    //原图或拉伸图片
    //    _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}

@end

//
//  MLKefuHeader.m
//  Matro
//
//  Created by Matro on 16/6/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLKefuHeader.h"

@implementation MLKefuHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MLKefuHeader" owner:self options:nil];
        
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

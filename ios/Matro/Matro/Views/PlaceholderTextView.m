//
//  PlaceholderTextView.m
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import "PlaceholderTextView.h"
#import "Masonry.h"
@interface PlaceholderTextView()<UITextViewDelegate>


@end
@implementation PlaceholderTextView

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}


- (void)awakeFromNib {
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];

    float left=5,top=2,hegiht=30;
    
    self.placeholderColor = [UIColor lightGrayColor];
//    PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
//                                                               , self.frame.size.width, hegiht)];
    _PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _PlaceholderLabel.font=self.placeholderFont?self.placeholderFont:self.font;
    _PlaceholderLabel.textColor=self.placeholderColor;
    [self addSubview:_PlaceholderLabel];
    _PlaceholderLabel.text=self.placeholder;
    [_PlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left);
        make.top.equalTo(self).offset(top);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(hegiht);
    }];

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    else
        _PlaceholderLabel.text=placeholder;
    _placeholder=placeholder;

    
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        _PlaceholderLabel.hidden=YES;
    }
    else{
        _PlaceholderLabel.hidden=NO;
    }
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_PlaceholderLabel removeFromSuperview];


}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

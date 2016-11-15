//
//  CPStepper.m
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/18.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "CPStepper.h"
#import "UIColor+HeinQi.h"


@class MLProlistModel;

@interface CPStepper () <UITextFieldDelegate,UIAlertViewDelegate> {
    
}

@end

@implementation CPStepper

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    _minValue = 1;
//    _maxValue = 100000;
    
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *Lview = [[UIView alloc ]initWithFrame:CGRectMake(26, 0, 1, rect.size.height)];
    Lview.backgroundColor = RGBA(230, 230, 230, 1);
    [self addSubview:Lview];
    UIView *Rview = [[UIView alloc ]initWithFrame:CGRectMake(71, 0, 1, rect.size.height)];
    Rview.backgroundColor = RGBA(230, 230, 230, 1);
    [self addSubview:Rview];
    
    UIButton *subButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subButton.frame = CGRectMake(0, 0, 25, rect.size.height);
    
    [subButton setTitle:@"-" forState:UIControlStateNormal];
    subButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [subButton setTintColor:[UIColor colorWithHexString:@"#7A7A7A"]];
    [subButton addTarget:self action:@selector(sub:) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftView = subButton;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(0, 0, 25, rect.size.height);
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [addButton setTintColor:[UIColor colorWithHexString:@"#7A7A7A"]];
    
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightView = addButton;
    
    
    self.textAlignment = NSTextAlignmentCenter;
    self.delegate = self;
    
    if(_value){
        self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    }else{
        self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_minValue];
        _value = _minValue;
    }

}

-(void)setTextValue:(int)value
{
    self.text = [NSString stringWithFormat:@"%lu", (unsigned long)value];
    _value = value;

}

-(void)sub:(UIButton *)sender {
//    _value = [self.text integerValue];
    
    if (_value <= _minValue) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已经是最小数量了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    _value--;
    
    self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    
    if (self.stepperDelegate && [self.stepperDelegate respondsToSelector:@selector(subButtonClicked: count:)]) {
        [self.stepperDelegate subButtonClicked:self.paramDic count:self.text.intValue];
    }
    if (self.stepperDelegate && [self.stepperDelegate respondsToSelector:@selector(subButtonClick: count:)]) {
        [self.stepperDelegate subButtonClick:self.proList count:self.text.intValue];
    }
}

-(void)add: (UIButton *)sender {
//    _value = [self.text integerValue];
    
    if (_value >= _maxValue) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已经是最大数量了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

        return;
    }

    _value++;
    
    if ([self.proList isKindOfClass:[MLProlistModel class]]) {
        MLProlistModel *model = (MLProlistModel *)self.proList;
        if (model.amount&&model.amount > 0) {
            if (_value > model.amount) {//提示
                _value --;
               self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
                
                if ([self.stepperDelegate respondsToSelector:@selector(showFieldErrorMessage)]) {
                    [self.stepperDelegate showFieldErrorMessage];
                }
                return;
            }
        }
        
    }
    
    self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    
    if (self.stepperDelegate && [self.stepperDelegate respondsToSelector:@selector(addField:ButtonClick:count:)] ) {
        [self.stepperDelegate addField:self ButtonClick:self.proList  count:self.value];
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        return;
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    _value = textField.text.intValue;
    
    if (_value <= _minValue) {
        _value = _minValue;
        textField.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    }
    
    if (_value >= _maxValue) {
        _value = _maxValue;
        textField.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    }
    if (self.stepperDelegate &&  [self.stepperDelegate respondsToSelector:@selector(subButtonClicked: count:)]) {
        [self.stepperDelegate subButtonClicked:self.paramDic count:self.text.intValue];
    }
    if (self.stepperDelegate && [self.stepperDelegate respondsToSelector:@selector(subButtonClick: count:)]) {
        [self.stepperDelegate subButtonClick:self.proList count:self.text.intValue];
    }
}

@end

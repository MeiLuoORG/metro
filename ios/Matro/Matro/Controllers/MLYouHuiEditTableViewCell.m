//
//  MLYouHuiEditTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLYouHuiEditTableViewCell.h"
#import "HFSConstants.h"
#import "NSString+GONMarkup.h"

@implementation MLYouHuiEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.cornerRadius = 4.f;
    self.editField.layer.masksToBounds = YES;
    self.editField.layer.cornerRadius = 4.f;
    self.editBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.editBtn.layer.borderWidth = 1.f;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2,25)];
    self.editField.leftView = leftView;
    self.editField.leftViewMode = UITextFieldViewModeAlways;
    self.editField.delegate = self;
}

- (void)setYouHuiQuan:(MLYouHuiQuanModel *)youHuiQuan{
    if (_youHuiQuan != youHuiQuan) {
        _youHuiQuan = youHuiQuan;
        NSString *attr =[NSString stringWithFormat:@"<font size=\"14\"><color value=\"#999999\">可用余额</><color value=\"#FF4E25\">￥%.1f</></>",_youHuiQuan.payable];
        self.yuLabel.attributedText = [attr createAttributedString];
        self.nameLabel.text = _youHuiQuan.name;
        if (_youHuiQuan.useSum > 0) {
           self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",_youHuiQuan.useSum];
        }else{
            self.priceLabel.text = @"￥";
        }

    }
}


- (IBAction)useClick:(id)sender { //使用按钮
    UIButton *btn = (UIButton *)sender;
        if ([btn.titleLabel.text isEqualToString:@"使用"]) {//点击使用的时候事件
            float useMoney = [self.editField.text floatValue];
            if (useMoney <= self.youHuiQuan.payable ) { //小于等于可支付金额时
                self.youHuiQuan.useSum = useMoney;
            }else{ //大于余额时点击使用的情况
                self.youHuiQuan.useSum = self.youHuiQuan.payable;
            }
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",_youHuiQuan.useSum];
            self.editField.hidden = YES;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
    }else{ //点击取消时
            self.editField.text = @""; //清空之前输入的金额
            self.editField.hidden= NO;
            self.youHuiQuan.useSum = 0;
            self.priceLabel.text = @"￥";
            [btn setTitle:@"使用" forState:UIControlStateNormal];
        }
    if (self.changeBlock) {
        self.changeBlock();
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.editField) {
        float useMoney = [self.editField.text floatValue];
        if (useMoney > self.youHuiQuan.payable){
            self.editField.text = [NSString stringWithFormat:@"%.1f",self.youHuiQuan.payable];
        }
    }
}

@end

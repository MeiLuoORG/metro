//
//  MLReturnsDetailHeadCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsDetailHeadCell.h"
#import "HFSConstants.h"
#import "NSString+GONMarkup.h"

@implementation MLReturnsDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bianjiBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.bianjiBtn.layer.borderWidth = 1.f;
    
    self.quxiaoBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.quxiaoBtn.layer.borderWidth = 1.f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}



- (void)setTuiHuoModel:(MLReturnsDetailModel *)tuiHuoModel{
    if (_tuiHuoModel != tuiHuoModel) {
        _tuiHuoModel = tuiHuoModel;
        self.shouHouLabel.attributedText = [self attributedStringWithTitle:@"订单状态" AndValue:self.tuiHuoModel.return_status];
        self.tuiHuoLabel.attributedText = [self attributedStringWithTitle:@"退货单号" AndValue:self.tuiHuoModel.return_code];
        self.timeLabel.attributedText = [self attributedStringWithTitle:@"申请时间" AndValue:self.tuiHuoModel.return_add_time];
        self.orderIdLabel.attributedText = [self attributedStringWithTitle:@"订单单号" AndValue:self.tuiHuoModel.order_id];
        if ([self.tuiHuoModel.return_status isEqualToString:@"审核中"]) {
            self.quxiaoBtn.hidden = NO;
            self.bianjiBtn.hidden = NO;
        }else{
            self.bianjiBtn.hidden = YES;
            self.quxiaoBtn.hidden = YES;
        }
        
    }
}




- (IBAction)tuiHuoAction:(id)sender {
    if (self.returnsDetailQuxiaoAction) {
        self.returnsDetailQuxiaoAction();
    }
}

- (IBAction)bianjiAction:(id)sender {
    if (self.returnsDetailBianjiAction) {
        self.returnsDetailBianjiAction();
    }
}

- (IBAction)kefuAction:(id)sender {
    if (self.returnsDetailKeFuAction) {
        self.returnsDetailKeFuAction();
    }
}

- (NSAttributedString *)attributedStringWithTitle:(NSString *)title AndValue:(NSString *)value{
    NSString *attStr = [NSString stringWithFormat:@"%@：<color value=\"#999999\">%@</>",title,value];
    return [attStr createAttributedString];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

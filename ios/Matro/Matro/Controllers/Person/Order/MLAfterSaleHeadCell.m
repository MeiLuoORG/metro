//
//  MLAfterSaleHeadCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAfterSaleHeadCell.h"
#import "NSString+GONMarkup.h"

@implementation MLAfterSaleHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTuiHuoModel:(MLTuiHuoModel *)tuiHuoModel{
    if (_tuiHuoModel != tuiHuoModel) {
        _tuiHuoModel = tuiHuoModel;
        self.shouHouLabel.attributedText = [self attributedStringWithTitle:@"售后状态" AndValue:_tuiHuoModel.statu];
        self.tuiHuoLabel.attributedText = [self attributedStringWithTitle:@"退货单号" AndValue:_tuiHuoModel.return_code];
        
        self.timeLabel.attributedText = [self attributedStringWithTitle:@"申请时间" AndValue:_tuiHuoModel.add_time];
        self.orderIdLabel.attributedText = [self attributedStringWithTitle:@"订单单号" AndValue:_tuiHuoModel.order_id];
    }
    
}




- (NSAttributedString *)attributedStringWithTitle:(NSString *)title AndValue:(NSString *)value{
    NSString *attStr = [NSString stringWithFormat:@"%@：<color value=\"#999999\">%@</>",title,value];
    return [attStr createAttributedString];
}



@end

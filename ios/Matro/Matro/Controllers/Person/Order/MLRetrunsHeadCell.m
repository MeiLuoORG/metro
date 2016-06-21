//
//  MLRetrunsHeadCell.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLRetrunsHeadCell.h"
#import "HFSConstants.h"
#import "NSString+GONMarkup.h"

@implementation MLRetrunsHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.returnBtn.layer.cornerRadius = 3.f;
    self.returnBtn.layer.masksToBounds = YES;
    self.returnBtn.layer.borderWidth = 1.f;
    self.returnBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tuihuoAction:(id)sender {
    if (self.tuihuoBlock) {
        self.tuihuoBlock();
    }
}


//@property (weak, nonatomic) IBOutlet UILabel *orderNum;
//@property (weak, nonatomic) IBOutlet UILabel *orderTime;
//@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
//@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

- (void)setTuihuoModel:(MLTuiHuoModel *)tuihuoModel{
    _tuihuoModel = tuihuoModel;
    self.orderNum.attributedText = [self attributedStringWithTitle:@"订单编号" AndValue:_tuihuoModel.order_id];
    self.orderTime.attributedText = [self attributedStringWithTitle:@"下单时间" AndValue:_tuihuoModel.create_time];
    self.orderStatus.attributedText = [self attributedStringWithTitle:@"订单状态" AndValue:_tuihuoModel.status];
    
}



- (NSAttributedString *)attributedStringWithTitle:(NSString *)title AndValue:(NSString *)value{
    NSString *attStr = [NSString stringWithFormat:@"%@：<color value=\"#999999\">%@</>",title,value];
    return [attStr createAttributedString];
}

@end

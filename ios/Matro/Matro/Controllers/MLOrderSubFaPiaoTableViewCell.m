//
//  MLOrderSubFaPiaoTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderSubFaPiaoTableViewCell.h"
#import "Masonry.h"

@implementation MLOrderSubFaPiaoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//@property (weak, nonatomic) IBOutlet UILabel *fapiaoType;
//@property (weak, nonatomic) IBOutlet UILabel *company;
//@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
- (void)setShifouKai:(BOOL)shifouKai{
    if (_shifouKai != shifouKai) {
        _shifouKai = shifouKai;
        if (_shifouKai) {//开发票情况
            [self.tishiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(16);
                make.right.equalTo(self).offset(-16);
                make.bottom.equalTo(self).offset(-8);
            }];
            self.fapiaoType.hidden = NO;
            self.company.hidden = NO;
        }
        else{
            [self.tishiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(16);
                make.right.equalTo(self).offset(-16);
                make.centerY.equalTo(self);
            }];
            self.fapiaoType.hidden = YES;
            self.company.hidden = YES;
            
        }
    }
}


@end

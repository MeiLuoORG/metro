//
//  MLOrderSubLiuYanTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/7/9.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderSubLiuYanTableViewCell.h"
#import "Masonry.h"
#import "HFSConstants.h"

@implementation MLOrderSubLiuYanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"请给卖家留言：";
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectZero];
        field.font = [UIFont systemFontOfSize:14];
        self.liuYanField = field;
        field.placeholder = @"请输入留言";
        [self addSubview:field];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = RGBA(245, 245, 245, 1);
        [self addSubview:line];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(16);
            make.width.mas_equalTo(100);
            make.centerY.equalTo(self);
        }];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(8);
            make.right.equalTo(self).offset(-8);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self).offset(-8);
            make.bottom.equalTo(self);
        }];
        
        
        
    }
    return self;
}

@end

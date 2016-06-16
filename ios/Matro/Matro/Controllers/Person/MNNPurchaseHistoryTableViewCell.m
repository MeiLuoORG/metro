//
//  MNNPurchaseHistoryTableViewCell.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNPurchaseHistoryTableViewCell.h"

@implementation MNNPurchaseHistoryTableViewCell {
    UILabel *_time;

    UILabel *_money;

    UILabel *_integral;

    UILabel *_address;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
        [self reloadCell];
    }
    return self;
}
- (void)createViews {
        self.contentView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0f alpha:1.0f];
    UIView * blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 168)];
    blackView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:blackView];
    _time          = [UILabel new];
    self.timeLabel     = [UILabel new];
    _money         = [UILabel new];
    self.moneyLabel    = [UILabel new];
    _integral      = [UILabel new];
    self.integralLabel = [UILabel new];
    _address       = [UILabel new];
    self.addressLabel  = [UILabel new];
    [self.contentView addSubview:_time];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:_money];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:_integral];
    [self.contentView addSubview:self.integralLabel];
    [self.contentView addSubview:_address];
    [self.contentView addSubview:self.addressLabel];
}
- (void)reloadCell {
    _time.text           = @"消费时间";
    _time.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _time.font           = [UIFont systemFontOfSize:12];
    _money.text          = @"消费金额";
    _money.font          = [UIFont systemFontOfSize:12];
    _money.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];

    _integral.text       = @"获得积分";
    _integral.font       = [UIFont systemFontOfSize:12];
    _integral.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];

    _address.text        = @"消费门店";
    _address.font        = [UIFont systemFontOfSize:12];
    _address.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];

    self.timeLabel.text      = @"2016-03-01 12:00:00";
    self.timeLabel.font      = [UIFont systemFontOfSize:12];

    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor grayColor];
    self.moneyLabel.text     = @"￥12543.00";
    self.moneyLabel.font     = [UIFont systemFontOfSize:12];

    self.moneyLabel.textAlignment = NSTextAlignmentRight;
     self.moneyLabel.textColor = [UIColor grayColor];
    self.integralLabel.text  = @"1000000";
    self.integralLabel.font  = [UIFont systemFontOfSize:12];

    self.integralLabel.textAlignment = NSTextAlignmentRight;
     self.integralLabel.textColor = [UIColor grayColor];
    self.addressLabel.text   = @"美罗观前街";
    self.addressLabel.font   = [UIFont systemFontOfSize:12];

    self.addressLabel.textAlignment = NSTextAlignmentRight;
     self.addressLabel.textColor = [UIColor grayColor];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _time.frame = CGRectMake(19, 0, 80, 42.5);
    self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, 0, 191, 42.5);
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.minimumScaleFactor = 0.5f;
    _money.frame = CGRectMake(19, CGRectGetMaxY(_time.frame), 80, 42.5);
    self.moneyLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, CGRectGetMaxY(self.timeLabel.frame), 191, 42.5);
    _integral.frame = CGRectMake(19, CGRectGetMaxY(_money.frame), 80, 42.5);
    self.integralLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, CGRectGetMaxY(self.moneyLabel.frame), 191, 42.5);
    _address.frame = CGRectMake(19, CGRectGetMaxY(_integral.frame), 80, 42.5);
    self.addressLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, CGRectGetMaxY(self.integralLabel.frame), 191, 42.5);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

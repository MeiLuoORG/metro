
//
//  MLShopBagHeaderView.m
//  Matro
//
//  Created by 黄裕华 on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopBagHeaderView.h"
#import "masonry.h"
#import "HFSConstants.h"

@implementation MLShopBagHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}


- (void)initView{
    MLCheckBoxButton *checkBox = [[MLCheckBoxButton alloc]initWithFrame:CGRectZero];
    [checkBox setImage:[UIImage imageNamed:@"zSelectBtn"] forState:UIControlStateNormal];
    checkBox.cartSelected = NO;
    self.checkBox = checkBox;
    [checkBox addTarget:self action:@selector(checkBoxChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkBox];
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLabel = titleLb;
    [self addSubview:titleLb];
    UILabel *arrow = [[UILabel alloc]initWithFrame:CGRectZero];
    arrow.backgroundColor = [UIColor redColor];
    arrow.textColor = [UIColor whiteColor];
    arrow.font = [UIFont systemFontOfSize:12];
    arrow.text = @">";
    arrow.hidden = YES;
    self.arrow = arrow;
    [self addSubview:arrow];
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectZero];
    downLine.backgroundColor = RGBA(245, 245, 245, 1);
    [self addSubview:downLine];
    UIButton *youhuiBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [youhuiBtn setTitle:@"优惠券" forState:UIControlStateNormal];
    [youhuiBtn setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
    youhuiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [youhuiBtn addTarget:self action:@selector(youhuiAction:) forControlEvents:UIControlEventTouchUpInside];
    self.youhuiBtn = youhuiBtn;
    [self addSubview:youhuiBtn];
    
    [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(18);
        make.left.mas_equalTo(self).offset(16);
        
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(checkBox.mas_right).offset(8);
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(titleLb.mas_right).offset(8);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(8);
    }];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [youhuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(self).offset(-16);
    }];
    self.contentView.backgroundColor = [UIColor whiteColor];
}


- (void)checkBoxChange:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.cartSelected = !btn.cartSelected;
    self.shopingCart.select_All = btn.cartSelected;
    
    if (self.cartHeadBlock) {
        self.cartHeadBlock(btn.cartSelected);
    }
}
- (void)youhuiAction:(id)sender {
    if (self.youHuiBlock) {
        self.youHuiBlock();
    }
}


- (void)setShopingCart:(MLShopingCartModel *)shopingCart{
    if (_shopingCart != shopingCart) {
        _shopingCart = shopingCart;
        self.titleLabel.text = _shopingCart.warehouse_nickname;
        self.checkBox.cartSelected = _shopingCart.select_All;
        self.youhuiBtn.hidden = !(_shopingCart.dpyhq.count>0);
    }
}


@end

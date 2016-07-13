
//
//  MLShopBagHeaderView.m
//  Matro
//
//  Created by MR.Huang on 16/7/6.
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
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectZero];
    arrow.image = [UIImage imageNamed:@"跳转箭头"];
    self.arrow = arrow;
    [self addSubview:arrow];
    UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [shopBtn addTarget:self action:@selector(shopClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shopBtn];
    
    
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
        make.height.width.mas_equalTo(42);
        make.left.mas_equalTo(self).offset(0);
        
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(checkBox.mas_right).offset(0);
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(titleLb.mas_right).offset(8);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLb);
        make.right.equalTo(arrow);
        make.top.bottom.equalTo(self);
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
        self.titleLabel.text = _shopingCart.company;
        self.checkBox.cartSelected = _shopingCart.select_All;
        self.youhuiBtn.hidden = !(_shopingCart.dpyhq.count>0);
    }
}

- (void)shopClick:(id)sender{
    if (self.shopClick) {
        self.shopClick();
    }
}


@end

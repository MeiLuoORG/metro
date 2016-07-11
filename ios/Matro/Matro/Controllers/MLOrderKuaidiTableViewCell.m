//
//  MLOrderKuaidiTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderKuaidiTableViewCell.h"
#import "Masonry.h"
#import "HFSConstants.h"


@interface MLOrderKuaidiTableViewCell ()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation MLOrderKuaidiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14];
    self.titleLabel = label;
    
    UILabel *slabel = [[UILabel alloc]initWithFrame:CGRectZero];
    slabel.font = [UIFont systemFontOfSize:14];
    slabel.textColor = RGBA(174, 142, 93, 1);
    self.subLabel = slabel;
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectZero];
    arrow.image = [UIImage imageNamed:@"xiayiye_arrow"];
    [headView addSubview:arrow];
    [headView addSubview:label];
    [headView addSubview:slabel];
    [self addSubview:headView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = RGBA(245, 245, 245, 1);
    [headView addSubview:line];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.bounces = NO;
    self.tableView = tableView;
    [self addSubview:tableView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.top.equalTo(self);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(16);
        make.centerY.equalTo(headView);
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView).offset(-16);
        make.centerY.equalTo(headView);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(8);
    }];
    [slabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrow.mas_left).offset(-8);
        make.centerY.equalTo(headView);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(16);
        make.right.equalTo(headView).offset(-16);
        make.bottom.equalTo(headView);
        make.height.mas_equalTo(1);
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(headView.mas_bottom);
    }];
}



#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderKuaidiSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[OrderKuaidiSubCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MLKuaiDiModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.company;
    NSString *priceStr = nil;
    if (model.price > 0) {
        priceStr = [NSString stringWithFormat:@"￥%.2f",model.price];
        cell.subLabel.textColor = RGBA(255, 78, 38, 1);
    }else{
        priceStr = @"免邮";
        cell.subLabel.textColor = RGBA(153, 153, 153, 1);
    }
    cell.subLabel.text = priceStr;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderKuaiDiSel) {
        self.orderKuaiDiSel(indexPath.row);
    }
}




- (void)setDataSource:(NSArray *)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self.tableView reloadData];
    }
}


@end
@implementation OrderKuaidiSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}


- (void)initUI{
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    leftLabel.font = [UIFont systemFontOfSize:14];
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLabel.textColor = RGBA(255, 78, 38, 1);
    rightLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16);
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = RGBA(245, 245, 245, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    self.titleLabel = leftLabel;
    self.subLabel = rightLabel;
    
}

@end





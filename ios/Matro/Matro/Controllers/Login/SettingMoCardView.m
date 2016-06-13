//
//  SettingMoCardView.m
//  Matro
//
//  Created by lang on 16/6/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "SettingMoCardView.h"

#define CELLID @"cardcellid"

@implementation SettingMoCardView


/*
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super init];
    if (self) {
        
    }
    return self;
}
*/

- (void)loadViews{
    self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SIZE_WIDTH, SIZE_HEIGHT-64)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SIZE_WIDTH, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"您是美罗VIP会员,请选择默认会员卡";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.minimumScaleFactor = 0.5;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLabel];
    

    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setFrame:CGRectMake(SIZE_WIDTH-50, 55, 30, 30)];
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 122, SIZE_WIDTH, SIZE_HEIGHT-250) style:UITableViewStylePlain];
    self.tableview.backgroundColor = [UIColor whiteColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"SettingMoCardCell" bundle:nil] forCellReuseIdentifier:CELLID];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self addSubview:self.tableview];
    
    self.OKButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.OKButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.OKButton setFrame:CGRectMake(30, SIZE_HEIGHT-80, SIZE_WIDTH-60, 40)];
    [self.OKButton setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
    [self.OKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.OKButton addTarget:self action:@selector(OKbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.OKButton.userInteractionEnabled = NO;
    [self addSubview:self.OKButton];
}

- (void)closeBtnAction:(UIButton *)sender{

    NSLog(@"点击关闭按钮");
}
- (void)OKbuttonAction:(UIButton *)sender{

    NSLog(@"点击了确定按钮");
    self.block(YES);
}

#pragma mark  TableViewDelegate
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
*/
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.cardARR.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (SettingMoCardCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingMoCardCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
   // SettingMoCardCell * cell2 = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = (SettingMoCardCell *)[[NSBundle mainBundle] loadNibNamed:@"MessagesTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击单元格");
    VipCardModel * cardModel = (VipCardModel *)[self.cardARR objectAtIndex:indexPath.row];
    self.cardNoString = cardModel.cardNo;

    self.cardNoString = cardModel.cardTypeIdString;


    SettingMoCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectButton.selected = YES;
    NSLog(@"所选默认卡的卡号为：%@",self.cardNoString);
    [self.OKButton setBackgroundColor:[HFSUtility hexStringToColor:Main_BackgroundColor]];
    self.OKButton.userInteractionEnabled = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingMoCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.selectButton.selected = NO;
    [tableView reloadData];
    //[tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:nil];
    //self layoutIfNeeded
}

- (void)bindButtonBlockAction:(BindButtonBlock)block{
    self.block = block;
}

#pragma end mark
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

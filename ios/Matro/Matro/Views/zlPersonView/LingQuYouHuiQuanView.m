//
//  LingQuYouHuiQuanView.m
//  Matro
//
//  Created by lang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "LingQuYouHuiQuanView.h"
#define CELLID @"cardcellid"
@implementation LingQuYouHuiQuanView


- (void)createView{

    self.quanARR  = [[NSMutableArray alloc]init];
    self.backgroundColor = [UIColor clearColor];
    UIView * bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-275-64)];
    bkView.backgroundColor = [UIColor clearColor];
    [self addSubview:bkView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTableView)];
    [bkView addGestureRecognizer:tap];
    
    UIView * bkView2 = [[UIView alloc]initWithFrame:CGRectMake(0, SIZE_HEIGHT-275-64-45, SIZE_WIDTH, 275+45)];
    bkView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:bkView2];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 120, 21)];
    label.text = @"点击领取优惠券";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0f];
    [bkView2 addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bkView2);
        make.centerY.mas_equalTo(bkView2.mas_top).offset(30);

    }];
    
    self.tablieview = [[UITableView alloc]initWithFrame:CGRectMake(15, SIZE_HEIGHT-275-64, SIZE_WIDTH-30, 275) style:UITableViewStylePlain];
    self.tablieview.delegate = self;
    self.tablieview.dataSource = self;
    self.tablieview.showsVerticalScrollIndicator = NO;
    self.tablieview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tablieview];
}
- (void)setHideBlockAction:(HideTableViewBlock)hideBlock{

    self.hideBlock = hideBlock;
}
- (void)selectQuanBlockAction:(SelectQuanCellBlock)selectQuanBlock{
    self.selectQuanBlock = selectQuanBlock;

}
- (void)hideTableView{
    NSLog(@"出发了点击事件");
    self.hideBlock(YES);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 125.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //return 4;
    return self.quanARR.count;
}

- (LingQuQuanCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //SettingMoCardCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    LingQuQuanCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = (LingQuQuanCell *)[[NSBundle mainBundle] loadNibNamed:@"LingQuQuanCell" owner:nil options:nil][0];
        
    }
    YouHuiQuanModel * model = [self.quanARR objectAtIndex:indexPath.row];
    
    cell.jinELabel.text = [NSString stringWithFormat:@"￥%@",model.jinE];
    
    NSString * youXiaoLabel = [NSString stringWithFormat:@"有效期:%@-%@",model.startTime,model.endTime];
    cell.youXiaoQiLabel.text = youXiaoLabel;
    cell.mingChengLabel.text = model.mingChengStr;
    /*
    NSString * rowKey = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.selectedBtnDic setObject:cell.selectButton forKey:rowKey];
    
    NSLog(@"执行了cellForRowAtIndexPath：allKeys:%ld",self.selectedBtnDic.allKeys.count);
    if ([rowKey isEqualToString:self.currentSelectIndex]) {
        cell.selectButton.selected  = YES;
    }
     */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了选择Cell");
    LingQuQuanCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.yiLingQuImageView.hidden = NO;
    YouHuiQuanModel * model = [self.quanARR objectAtIndex:indexPath.row];
    
    http://bbctest.matrojp.com/api.php?m=member&s=admin_coupons&action=set_coupons&test_phone=18868672308
    self.selectQuanBlock(YES,model);
}

@end

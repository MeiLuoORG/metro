//
//  LingQuYouHuiQuanView.m
//  Matro
//
//  Created by lang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "LingQuYouHuiQuanView.h"
#define CELLID @"cardcellid"
@implementation LingQuYouHuiQuanView{

    MBProgressHUD * _hud;
    NSMutableDictionary * _yilingQuCellDIC;
}


- (void)createView{

    self.quanARR  = [[NSMutableArray alloc]init];
    _yilingQuCellDIC = [[NSMutableDictionary alloc]init];
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
    
    NSString * rowKey = [NSString stringWithFormat:@"%ld",indexPath.row];
    for (NSString * rowStr in _yilingQuCellDIC.allKeys) {
        if ([rowKey isEqualToString:rowStr]) {
            cell.yiLingQuImageView.hidden = NO;
        }
        
    }
    if ([model.flag isEqualToString:@"0"]) {
        cell.yiLingQuImageView.hidden = NO;
    }
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
    YouHuiQuanModel * model = [self.quanARR objectAtIndex:indexPath.row];
    
    //http://bbctest.matrojp.com/api.php?m=member&s=admin_coupons&action=set_coupons&test_phone=18868672308
    //self.selectQuanBlock(YES,model);
    if ([model.flag isEqualToString:@"1"]) {
         [self selectYouHuiQuan:model withCell:cell withIndexPath:indexPath];
    }
    
   
}

- (void)selectYouHuiQuan:(YouHuiQuanModel *)model withCell:(LingQuQuanCell *) cell withIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakself = self;
    //NSLog(@"优惠券信息;%@,%@,%@",model.quanType,model.quanBH,model.quanID);
    
    NSDictionary * ret = @{@"cxlx":model.quanType,
                           @"jlbh":model.quanBH,
                           @"yhqid":model.quanID
                           };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:nil];
    //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *params = @{@"action":@"set_coupons"};
    
    /*
     [[HFSServiceClient sharedJSONClient] POST:LingQuanAction_URLString parameters:ret constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"点击领取优惠券%@",responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"优惠券请求失败：%@",error);
     }];
     */
    
    
    
    //m=member&s=admin_coupons&action=set_coupons&test_phone=18868672308
    [MLHttpManager post:LingQuanAction_URLString params:ret m:@"member" s:@"admin_coupons" success:^(id responseObject) {
        NSLog(@"点击领取优惠券%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        NSDictionary * dataDic = result[@"data"];
        if (dataDic) {
            int flag = [dataDic[@"flag"] intValue];
            if (flag == 1) {
                
                cell.yiLingQuImageView.hidden = NO;
                NSString * indexRowStr = [NSString stringWithFormat:@"%ld",indexPath.row];
                [_yilingQuCellDIC setObject:cell forKey:indexRowStr];
                
            }
            else{
                
            }
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"优惠券请求失败：%@",error);
        _hud = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];
    
    
}


@end

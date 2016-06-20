//
//  MLReturnRequestViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnRequestViewController.h"
#import "MLReturnRequestFootView.h"
#import "Masonry.h"
#import "MLReturnRequestTableViewCell.h"

#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLZTextTableViewCell.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLTuiHuoFooterView.h"
#import "MLTuiHuoMiaoshuTableViewCell.h"
#import "MLTuiHuoFukuanTableViewCell.h"
#import "MLXuanZeTuPianTableViewCell.h"
#import "MBProgressHUD+Add.h"






@interface MLReturnRequestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLTuiHuoFooterView *footerView;

@end

@implementation MLReturnRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLZTextTableViewCell" bundle:nil] forCellReuseIdentifier:kZTextTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLTuiHuoFukuanTableViewCell" bundle:nil] forCellReuseIdentifier:kTuiHuoMiaoshuTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLTuiHuoMiaoshuTableViewCell" bundle:nil] forCellReuseIdentifier:kTuiHuoFukuanTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLXuanZeTuPianTableViewCell" bundle:nil] forCellReuseIdentifier:kXuanZeTuPianTableViewCell];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MLTuiHuoFooterView *footView = [MLTuiHuoFooterView footView];
        footView.frame = CGRectMake(0, 0, SCREENWIDTH, 250);
        tableView.tableFooterView = footView;
        self.footerView = footView;
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];

    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //订单号
            MLZTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
            cell.titleLabel.text = @"订单单号：1234511111";
            cell.subLabel.text = @"￥2000.0";
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
            line.backgroundColor = RGBA(245, 245, 245, 1);
            [cell addSubview:line];
            return cell;
            
        }else if (indexPath.row == 1){//商铺头
            MLOrderInfoHeaderTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            return cell;
        }else {
            MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
    }else if (indexPath.section == 1){
        MLTuiHuoMiaoshuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTuiHuoMiaoshuTableViewCell forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.section == 2){
        MLTuiHuoFukuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTuiHuoFukuanTableViewCell forIndexPath:indexPath];
        return cell;
    }else{
        MLXuanZeTuPianTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:kXuanZeTuPianTableViewCell forIndexPath:indexPath];
        __weak typeof(self) weakself = self;
        cell.xuanZeTuPianBlock = ^(){//选择图片
            MLXuanZeTuPianTableViewCell *cell  =[weakself.tableView cellForRowAtIndexPath:indexPath];
            [cell.imgsArray insertObject:[UIImage imageNamed:@"wufaxianshi-1"] atIndex:0];
            [cell.collectionView reloadData];
        };
        return cell;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {
            return 44;
        }
        return 134;
    }
    else if (indexPath.section == 1){
        return 88;
    }else if (indexPath.section == 2){
        return 200;
    }
    return 180;
}

@end

//
//  MLPersonDetailViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonOrderDetailViewController.h"
#import "MLZTTableViewCell.h"
#import "MLTisTableViewCell.h"
#import "MLAddTableViewCell.h"
#import "MLRPayTableViewCell.h"
#import "MLZTextTableViewCell.h"
#import "HFSConstants.h"
#import "masonry.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLMoreTableViewCell.h"
#import "MLOrderCenterTableViewCell.h"


@interface MLPersonOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@end

@implementation MLPersonOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _tableView = ({
        UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"MLZTTableViewCell" bundle:nil] forCellReuseIdentifier:kZTTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLAddTableViewCell" bundle:nil] forCellReuseIdentifier:kAddTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLTisTableViewCell" bundle:nil] forCellReuseIdentifier:kTisTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLRPayTableViewCell" bundle:nil] forCellReuseIdentifier:kRPayTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLZTextTableViewCell" bundle:nil] forCellReuseIdentifier:kZTextTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    _footView = ({
        UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footView];
        footView;
    });
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
    
}


#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else if (section == 1 || section == 2){
        return 1;
    }
    else if (section == 3){
        return 4;
    }
    else if (section == 4){
        return 3;
    }
    else if (section == 5){
        return 2;
    }else if (section == 6){
        return 5;
    }
    return 0;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { //ZTTableViewCell
        MLZTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZTTableViewCell forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"订单编号：";
            cell.ztLabel.text = @"12345678";
            
        }
        else{
            cell.titleLabel.text = @"订单状态：";
            cell.ztLabel.text = @"待发货";
            
        }
        return cell;
        
    }
    else if (indexPath.section == 1){
        MLTisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTisTableViewCell forIndexPath:indexPath];
        cell.tisLabel.text = @"订单已通过审核，仓库配送中.....";

        cell.timeLabel.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 2){
        MLAddTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:kAddTableViewCell forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 3){ //商品列表
        if (indexPath.row == 0) {
            MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
            return cell;
        }
        else{
            MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            return cell;
        }

    }else if (indexPath.section == 4){
        MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
        cell.titleLabel.text = @"支付方式";
        cell.subLabel.text = @"在线支付";
        return cell;
    }else if (indexPath.section == 5){
        MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
        cell.titleLabel.text = @"发票信息";
        cell.subLabel.text = @"不开发票";
        return cell;
    }
    else if (indexPath.section == 6){
        if (indexPath.row <4) {
            MLZTextTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLabel.text = @"商品总额：";
                    cell.subLabel.text = @"￥1233.00";
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);

                }
                    break;
                case 1:
                {
                    cell.titleLabel.text = @"优    惠：";
                    cell.subLabel.text = @"-￥200.00";
                    cell.subLabel.textColor = [UIColor blackColor];
                }
                    break;
                case 2:
                {
                    cell.titleLabel.text = @"税    费：";
                    cell.subLabel.text = @"+￥20.00";
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);

                }
                    break;
                case 3:
                {
                    cell.titleLabel.text = @"运    费：";
                    cell.subLabel.text = @"+￥0.00";
                    cell.subLabel.textColor = RGBA(255, 78, 37, 1);
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
        MLRPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRPayTableViewCell forIndexPath:indexPath];
        cell.rpayLabel.text = @"￥12856.00";
        cell.rpayLabel.textColor = RGBA(255, 78, 37, 1);
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }else if (indexPath.section == 1){
        return 80;
    }else if (indexPath.section == 2){
        return 120;
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 40;
        }
        return 134;
    }
    else if (indexPath.section == 4){
        return 40;
    }else if (indexPath.section == 5){
        return 44;
    }
    else if (indexPath.section == 6){
        if (indexPath.row < 4) {
            return 30;
        }
        return 50;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}



@end

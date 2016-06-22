//
//  MLReturnsDetailViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsDetailViewController.h"
#import "UIView+BlankPage.h"
#import "Masonry.h"
#import "MLReturnsHeader.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLTuiHuoModel.h"
#import "MJExtension.h"
#import "HFSServiceClient.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLReturnRequestViewController.h"
#import "MBProgressHUD+Add.h"
#import "HFSUtility.h"
#import "MLMoreTableViewCell.h"
#import "MLReturnsDetailHeadCell.h"
#import "MLReturnsWentiTableViewCell.h"

@interface MLReturnsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;


@end

@implementation MLReturnsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLReturnsDetailHeadCell" bundle:nil] forCellReuseIdentifier:kReturnsDetailHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLReturnsWentiTableViewCell" bundle:nil] forCellReuseIdentifier:kReturnsWentiTableViewCell];
        
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MLReturnsDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kReturnsDetailHeadCell forIndexPath:indexPath];
            return cell;
        }else if (indexPath.row == 1){
            MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.statusLabel.hidden = YES;
            return cell;
        }
        else{
            MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            return cell;
        }
    }else if (indexPath.section == 0){
        if (indexPath.row == 0) {
            MLReturnsWentiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReturnsWentiTableViewCell forIndexPath:indexPath];
            return cell;
        }
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 130;
        }else if (indexPath.row == 1){
            return 40;
        }
        else{
            return 134;
        }
    }else if (indexPath.section == 0){
        if (indexPath.row == 0) {
            return 140;
        }
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

//
//  MLActMessageViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLActMessageViewController.h"
#import "HFSConstants.h"
#import "MLSystemHeaderCell.h"

#import "MLActMessageBodyCell.h"
#import "MLActMessageFootCell.h"
#import "Masonry.h"
#import "MJRefresh.h"

@interface MLActMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MLActMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动消息";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]init];
        [tableView registerNib:[UINib nibWithNibName:@"MLSystemHeaderCell" bundle:nil] forCellReuseIdentifier:kSystemHeaderCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLActMessageBodyCell" bundle:nil] forCellReuseIdentifier:kActMessageBodyCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLActMessageFootCell" bundle:nil] forCellReuseIdentifier:kActMessageFootCell];
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self.tableView.header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MLSystemHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemHeaderCell forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 1){
        MLActMessageBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:kActMessageBodyCell forIndexPath:indexPath];
        return cell;
    }
    else{
        MLActMessageFootCell *cell = [tableView dequeueReusableCellWithIdentifier:kActMessageFootCell forIndexPath:indexPath];
        return cell;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 30;
    }else if (indexPath.row == 1){
        return 210;
    }
    else{
        return 30;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end

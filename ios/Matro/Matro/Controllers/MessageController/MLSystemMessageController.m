//
//  MLSystemMessageController.m
//  Matro
//
//  Created by MR.Huang on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSystemMessageController.h"
#import "MLSystemBodyCell.h"
#import "MLSystemHeaderCell.h"
#import "Masonry.h"
#import "MJRefresh.h"

@interface MLSystemMessageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation MLSystemMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统消息";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]init];
        [tableView registerNib:[UINib nibWithNibName:@"MLSystemBodyCell" bundle:nil] forCellReuseIdentifier:kSystemBodyCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLSystemHeaderCell" bundle:nil] forCellReuseIdentifier:kSystemHeaderCell];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MLSystemHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemHeaderCell forIndexPath:indexPath];
        return cell;
    }
    else{
        MLSystemBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemBodyCell forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 30;
    }
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}



@end

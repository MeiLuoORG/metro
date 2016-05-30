//
//  MLReturnsViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsViewController.h"
#import "MLAfterSaleProductCell.h"
#import "MLRetrunsHeadCell.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "Masonry.h"
#import "MLReturnsHeader.h"

@interface MLReturnsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation MLReturnsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MLReturnsHeader *header = [MLReturnsHeader  returnsHeader];
    header.searchBlock = ^(NSString *searchText){
        NSLog(@"搜索关键词%@",searchText);
    };
    [self.view addSubview:header];
    
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"MLRetrunsHeadCell" bundle:nil] forCellReuseIdentifier:kMLRetrunsHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleProductCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleProductCell];
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.top.equalTo(header.mas_bottom);
        make.bottom.mas_equalTo(self.view).offset(-65);
    }];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.header endRefreshing];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeTuihuo hasData:(self.dataSource.count>0)];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer endRefreshing];
        [self.dataSource addObjectsFromArray:@[@"",@"",@"",@""]];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeTuihuo hasData:(self.dataSource.count>0)];
    }];
    
    [self.tableView.header beginRefreshing];
    
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        MLRetrunsHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLRetrunsHeadCell forIndexPath:indexPath];
        return cell;
    }
    
    MLAfterSaleProductCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLAfterSaleProductCell forIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90.f;
    }
    return 120.f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 10.F)];
    foot.backgroundColor = RGBA(245, 245, 245, 1);
    
    return foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end

//
//  MLFootMarkViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLFootMarkViewController.h"
#import "Masonry.h"
#import "MLFootMarkTableViewCell.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "MLWishlistModel.h"


@interface MLFootMarkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation MLFootMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览足迹";
    // Do any additional setup after loading the view.
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLFootMarkTableViewCell" bundle:nil] forCellReuseIdentifier:kMLFootMarkTableViewCell];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(removeAll:)];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.header endRefreshing];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeLiuLan hasData:(self.dataSource.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"浏览足迹的去逛逛");
            
        };
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer endRefreshing];
        [self.dataSource addObjectsFromArray:@[@"",@"",@"",@""]];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeLiuLan hasData:(self.dataSource.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"浏览足迹的去逛逛");

        };
        
    }];
    
    [self.tableView.header beginRefreshing];
    
}





#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLFootMarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLFootMarkTableViewCell forIndexPath:indexPath];
    cell.footMarkAddCartBlock = ^(){
        NSLog(@"加入购物车操作");
    };
    cell.footMarkDeleteBlock = ^(){
        NSLog(@"删除足迹操作");
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}


- (void)removeAll:(id)sender{
    NSLog(@"删除所有");
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self.view configBlankPage:EaseBlankPageTypeLiuLan hasData:(self.dataSource.count>0)];
    self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
        NSLog(@"浏览足迹的去逛逛");
        
    };
}


- (NSMutableArray *)dataSource{
    if (!_dataSource ) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end

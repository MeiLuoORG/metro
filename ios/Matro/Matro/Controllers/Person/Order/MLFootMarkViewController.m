//
//  MLFootMarkViewController.m
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLFootMarkViewController.h"
#import "Masonry.h"
#import "MLFootMarkTableViewCell.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "MLWishlistModel.h"
#import "HFSServiceClient.h"
#import "UIImageView+WebCache.h"
@interface MLFootMarkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation MLFootMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览足迹";
    // Do any additional setup after loading the view.
    
    [self loadData];
    
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
        //[self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeLiuLan hasData:(self.dataSource.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"浏览足迹的去逛逛");
            
        };
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer endRefreshing];
        //[self.dataSource addObjectsFromArray:@[@"",@"",@"",@""]];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeLiuLan hasData:(self.dataSource.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"浏览足迹的去逛逛");

        };
        
    }];
    
    [self.tableView.header beginRefreshing];
    
}



-(void)loadData{

    //http://bbctest.matrojp.com/api.php?m=product&s=detail_footprint&test_test_phone=13771961207&action=sel_footprint
    
    
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=detail_footprint&test_phone=13771961207&action=sel_footprint",@"http://bbctest.matrojp.com"];
    [[HFSServiceClient sharedJSONClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"请求成功 ==== %@",responseObject);
        self.dataSource = responseObject[@"data"][@"footprint_info"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络错误");
    }];
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
    NSDictionary *tempDic = self.dataSource[indexPath.row];
    cell.Pname.text = tempDic[@"panme"];
    cell.Pprice.text = [NSString stringWithFormat:@"￥%@",tempDic[@"price"]];
    NSString *imageStr = tempDic[@"pic"];
    
    if (![imageStr isKindOfClass:[NSNull class]]) {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"imageloading"]];
        
    }else{
        cell.imageView.image = [UIImage imageNamed:@"imageloading"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 1.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
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

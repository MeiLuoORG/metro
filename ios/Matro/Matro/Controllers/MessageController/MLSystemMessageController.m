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
#import "MLMessageCenterModel.h"
#import "MJExtension.h"
#import "HFSConstants.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "MLPersonOrderDetailViewController.h"
#import "HFSUtility.h"
#import "UIViewController+MLMenu.h"
#import "MLLoginViewController.h"


@interface MLSystemMessageController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,assign)NSInteger pageIndex;

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
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getMessages];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMessages)];
    self.pageIndex = 1;
    [self getMessages];
    
    [self addMenuButton];
    
    
}

#pragma mark--展示下拉菜单


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messageArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLSystemMessageModel *message = [self.messageArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        MLSystemHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemHeaderCell forIndexPath:indexPath];
        cell.timeLabel.text = message.create_time;
        return cell;
    }
    else{
        MLSystemBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemBodyCell forIndexPath:indexPath];
        cell.titleLabel.text = message.title;
        cell.contentLabel.text  = message.desc;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLSystemMessageModel *model = [self.messageArray objectAtIndex:indexPath.section];
    MLPersonOrderDetailViewController *vc = [[MLPersonOrderDetailViewController alloc]init];
    vc.order_id = model.order_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return YES;
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        MLSystemMessageModel *model = [self.messageArray objectAtIndex:indexPath.section];
        [self deleteMessage:model];
        [self.messageArray removeObject:model];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

    }
}


- (void)getMessages{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=system_list&cur_page=%li&page_size=10",MATROJP_BASE_URL,self.pageIndex];
    [MLHttpManager get:url params:nil m:@"push" s:@"system_list" success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            if (self.pageIndex == 1) {
                [self.messageArray removeAllObjects];
            }
            
            NSDictionary *data = result[@"data"];
            NSArray *list = data[@"list"];
            NSString *total = data[@"total"];
            if (self.messageArray.count < [total integerValue]) {
                [self.messageArray addObjectsFromArray:[MLSystemMessageModel mj_objectArrayWithKeyValuesArray:list]];
                self.pageIndex ++;
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showMessag:@"暂无更多数据" toView:self.view];
            }
        }else if ([result[@"code"]isEqual:@1002]){
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
            
        }
        else{
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}

- (void)deleteMessage:(MLSystemMessageModel *)message{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=delete",MATROJP_BASE_URL];
    NSDictionary *params = @{@"type":@"1",@"delete_id":message.ID?:@""};
    [MLHttpManager post:url params:params m:@"push" s:@"delete" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"删除成功" toView:self.view];
        }else if ([result[@"code"]isEqual:@1002]){
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
            
        } else{
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}


@end

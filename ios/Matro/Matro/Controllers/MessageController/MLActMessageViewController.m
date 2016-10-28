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
#import "MJExtension.h"
#import "MLMessageCenterModel.h"
#import "HFSConstants.h"
#import "UIImageView+WebCache.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+MLMenu.h"
#import "MLActWebViewController.h"
#import "MLPersonAlertViewController.h"
#import "MLLoginViewController.h"

@interface MLActMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger pageIndex;
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
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getActMessages];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getActMessages)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.pageIndex = 1;
    [self getActMessages];
    [self addMenuButton];
}

- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messageArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLActiveMessageModel *message = [self.messageArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        MLSystemHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemHeaderCell forIndexPath:indexPath];
        cell.timeLabel.text = message.create_time;
        return cell;
    }else if (indexPath.row == 1){
        MLActMessageBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:kActMessageBodyCell forIndexPath:indexPath];
        cell.titleLabel.text = message.title;
        
        
        if ([message.pic hasSuffix:@"webp"]) {
            [cell.actImage setZLWebPImageWithURLStr:message.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [cell.actImage sd_setImageWithURL:[NSURL URLWithString:message.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        cell.descLabel.text = message.desc;
        __weak typeof(self) weakself = self;
        cell.delAction = ^(){
            MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定删除此消息？" AndAlertDoneAction:^{
                [weakself deleteMessage:message];
            }];
            [weakself showTransparentController:vc];
        };
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
        return 240;
    }
    else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLActiveMessageModel *message = [self.messageArray objectAtIndex:indexPath.section];
    MLActWebViewController *vc = [[MLActWebViewController alloc]init];
    vc.link = message.link;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getActMessages{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=promotion_list&cur_page=%li&page_size=10",MATROJP_BASE_URL,self.pageIndex];
    [MLHttpManager get:url params:nil m:@"push" s:@"promotion_list" success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *list = data[@"list"];
            NSString *total = data[@"total"];
            if (self.pageIndex == 1) {
                [self.messageArray removeAllObjects];
            }
            if (self.messageArray.count < [total integerValue]) {
               [self.messageArray addObjectsFromArray:[MLActiveMessageModel mj_objectArrayWithKeyValuesArray:list]]; 
            }else{
                [MBProgressHUD showMessag:@"暂无更多数据" toView:self.view];
            }
            [self.tableView reloadData];
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

- (void)deleteMessage:(MLActiveMessageModel *)message{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=delete",MATROJP_BASE_URL];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSDictionary *params = @{@"type":@"2",@"delete_id":message.ID?:@""};
    [MLHttpManager post:url params:params m:@"push" s:@"delete" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"删除成功" toView:self.view];
            [self.tableView.header beginRefreshing];
        }else if ([result[@"code"]isEqual:@1002]){
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
            
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}


@end

//
//  MLPushConfigViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPushConfigViewController.h"
#import "MLPushConfigTableViewCell.h"
#import "HFSConstants.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "MLLoginViewController.h"

@interface MLPushConfigViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *settingArray;

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MLPushConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息设置";
    // Do any additional setup after loading the view.
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        [tableView registerNib:[UINib nibWithNibName:@"MLPushConfigTableViewCell" bundle:nil] forCellReuseIdentifier:kPushConfigTableViewCell];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = 0;
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 100)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40, 40, MAIN_SCREEN_WIDTH - 80, 40)];
        [btn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"清空全部消息" forState:UIControlStateNormal];
        [btn setBackgroundColor:RGBA(174, 142, 93, 1)];
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;
        [footerView addSubview:btn];
        tableView.tableFooterView = footerView;
        [self.view addSubview:tableView];
        tableView;
    });
    [self getSettingInfo];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    __weak typeof(self) weakself = self;
    MLPushConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPushConfigTableViewCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        for (NSDictionary *dic in self.settingArray) {
            if ([dic[@"type"] isEqual:@2]) {
                NSString * strss = dic[@"status"]?:@"";
                if (![strss isKindOfClass:[NSNull class]]) {
                    
                    cell.switchs.on = [strss isEqualToString:@"1"];
                }
                
            }
        }
        cell.titleLabel.text = @"促销优惠";
        cell.pushConfigChange = ^(BOOL pushOn){
            [weakself messageInfoSettingWithType:@"2" andOption:pushOn];
        };
    }else{
        for (NSDictionary *dic in self.settingArray) {
            if ([dic[@"type"] isEqual:@1]) {
                NSString * strss = dic[@"status"]?:@"";
                if (![strss isKindOfClass:[NSNull class]]) {
                    cell.switchs.on = [strss isEqualToString:@"1"];
                }
            }
        }
        cell.titleLabel.text = @"系统通知";
        cell.pushConfigChange = ^(BOOL pushOn){
            [weakself messageInfoSettingWithType:@"1" andOption:pushOn];
        };
    }
    return cell;
}


- (void)messageInfoSettingWithType:(NSString *)type andOption:(BOOL)option{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=setting",MATROJP_BASE_URL];
    NSDictionary *param = @{@"type":type,@"option":option?@"1":@"0"};
    
    [MLHttpManager post:url params:param m:@"push" s:@"setting" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"操作成功" toView:self.view];
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
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (void)clearAction:(id)sender{ //请空全部消息操作
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=delete",MATROJP_BASE_URL];
    NSDictionary *params = @{@"type":@"-1",@"delete_id":@"-1"};
    [MLHttpManager post:url params:params m:@"push" s:@"delete" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"删除成功" toView:self.view];
            if (self.removeAllMessage) {
                self.removeAllMessage();
            }
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

- (void)getSettingInfo{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=get_setting",MATROJP_BASE_URL];
    NSLog(@"消息设置的URL为：%@",url);
    [MLHttpManager get:url params:nil m:@"push" s:@"get_setting" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"消息设置为：%@",result);
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data= result[@"data"];
            NSArray *list = data[@"list"];
            [self.settingArray addObjectsFromArray:list];
            [self.tableView reloadData];
        }else if ([result[@"code"]isEqual:@1002]){
            
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
        }else{
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}

- (NSMutableArray *)settingArray{
    if (!_settingArray) {
        _settingArray = [NSMutableArray array];
    }
    return _settingArray;
}


@end

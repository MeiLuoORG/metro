//
//  MLMessagesViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLMessagesViewController.h"
#import "MLMessagesControlCell.h"
#import "MLSystemMessageController.h"
#import "MLActMessageViewController.h"
#import "MLHttpManager.h"
#import "MLMessageCenterModel.h"
#import "HFSConstants.h"
#import "MBProgressHUD+Add.h"
#import "MJExtension.h"
#import "MLPushConfigViewController.h"
#import "UIView+BlankPage.h"
#import "MLLoginViewController.h"



@interface MLMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *messageArray;

@end

@implementation MLMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLMessagesControlCell" bundle:nil] forCellReuseIdentifier:kMessagesControlCell];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:tableView];
        tableView;
    });
    
    UIButton  *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 22, 22);
    [btn setBackgroundImage:[UIImage imageNamed:@"settingzl"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actSettingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.view configBlankPage:EaseBlankPageTypeXiaoxi hasData:NO];
    [self getDataSource];
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (void)actSettingAction{
    MLPushConfigViewController *vc = [[MLPushConfigViewController alloc]init];
    vc.removeAllMessage = ^(){
        [self getDataSource];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLMessagesControlCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessagesControlCell  forIndexPath:indexPath];
    MLMessageCenterModel *model  = [self.messageArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"系统消息";
        cell.imgView.image = [UIImage imageNamed:@"icon_xitongxiaoxi"];
        if (model.type == 1) {
            cell.timeLabel.text = model.last_time;
            cell.contentLabel.text = model.desc;
        }
        else{
            model = [self.messageArray lastObject];
            cell.timeLabel.text = model.last_time;
            cell.contentLabel.text = model.desc;
        }
    }
    else{
        cell.titleLabel.text = @"优惠促销";
        cell.imgView.image = [UIImage imageNamed:@"icon_youhuiquan"];
        if (model.type == 2) {
            cell.timeLabel.text = model.last_time;
            cell.contentLabel.text = model.desc;
        }
        else{
            model = [self.messageArray lastObject];
            cell.timeLabel.text = model.last_time;
            cell.contentLabel.text = model.desc;
        }
    }
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 ) {
        MLSystemMessageController *vc = [[MLSystemMessageController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MLActMessageViewController *vc = [[MLActMessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
    }
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (void)getDataSource{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=push&s=message_center",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"push" s:@"message_center" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *list = data[@"list"];
            [self.messageArray addObjectsFromArray:[MLMessageCenterModel mj_objectArrayWithKeyValuesArray:list]];
            [self.tableView reloadData];
            
        }else if ([result[@"code"]isEqual:@1002]){
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self loginAction:nil];
            
        }  else{
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
        }
         [self.view configBlankPage:EaseBlankPageTypeXiaoxi hasData:(self.messageArray.count>0)];
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}





@end

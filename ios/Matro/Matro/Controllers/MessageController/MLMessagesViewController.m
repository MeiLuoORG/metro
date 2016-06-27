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

@interface MLMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

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
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLMessagesControlCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessagesControlCell  forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"系统消息";
        cell.imgView.image = [UIImage imageNamed:@"icon_xitongxiaoxi"];
    }
    else{
        cell.titleLabel.text = @"优惠促销";
        cell.imgView.image = [UIImage imageNamed:@"icon_youhuiquan"];
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



@end

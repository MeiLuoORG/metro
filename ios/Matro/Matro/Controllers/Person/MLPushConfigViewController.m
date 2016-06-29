//
//  MLPushConfigViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPushConfigViewController.h"
#import "MLPushConfigTableViewCell.h"
#import "HFSConstants.h"

@interface MLPushConfigViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLPushConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPushConfigTableViewCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"促销优惠";
        cell.pushConfigChange = ^(BOOL pushOn){
            
        };
    }else{
        cell.titleLabel.text = @"系统通知";
        cell.pushConfigChange = ^(BOOL pushOn){
            
        };
    }
    return cell;
}


- (void)clearAction:(id)sender{ //请空全部消息操作
    
}






@end

//
//  MLSureOrderViewController.m
//  Matro
//
//  Created by Matro on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSureOrderViewController.h"
#import "MLInvoiceViewController.h"
#import "MLAddressSelectViewController.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "MLShopCartMoreCell.h"
#import "MLAddressListModel.h"
#import "MLPeisongTableViewCell.h"
#import "MLCommitOrderListModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MLSureOrderHeaderCell.h"
#import "MLsehnfenzhengCell.h"
#import "MLMoreTableViewCell.h"
#import "MLOrderListTableViewCell.h"

@interface MLSureOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation MLSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLSureOrderHeaderCell" bundle:nil] forCellReuseIdentifier:KMLSureOrderHeaderCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLsehnfenzhengCell" bundle:nil] forCellReuseIdentifier:KMLsehnfenzhengCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        
        [self.view addSubview:tableView];
        tableView;
    });
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

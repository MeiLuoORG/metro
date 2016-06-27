//
//  MLCusServiceController.m
//  Matro
//
//  Created by MR.Huang on 16/5/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCusServiceController.h"
#import "MLCusServiceCell.h"
#import "MLCusHelpViewController.h"

@interface MLCusServiceController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *imageItems;
    NSArray *titleItems;
}

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation MLCusServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    imageItems = @[@"icon_zhinan",@"icon_baozhang",@"icon_zhifu",@"icon_shouhou",@"icon_wenti"];
    titleItems = @[@"购物指南",@"服务保障",@"支付帮助",@"售后服务",@"常见问题"];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLCusServiceCell" bundle:nil] forCellReuseIdentifier:kMLCusServiceCell];
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 180)];
        headImg.image = [UIImage imageNamed:@"img_bangzhuzhongxing"];
        tableView.tableHeaderView = headImg;
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 100)];
        footView.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, MAIN_SCREEN_WIDTH-100, 100)];
        leftLabel.text = @"  客服电话：400-885-0668";
        leftLabel.font = [UIFont systemFontOfSize:12];
        
        [footView addSubview:leftLabel];
        UILabel  *rightLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame), 0,80, 100)];
        rightLabel.text = @"9:00~22:00  ";
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:12];
        [footView addSubview:rightLabel];
        tableView.tableFooterView = footView;
        [self.view addSubview:tableView];
        tableView;
    });
    
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return imageItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLCusServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLCusServiceCell forIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:[imageItems objectAtIndex:indexPath.row]];
    cell.myTitleLabel.text = [titleItems objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLCusHelpViewController *vc = [[MLCusHelpViewController alloc]initWithHelpType:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



@end

//
//  MLReturnsDetailViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsDetailViewController.h"
#import "UIView+BlankPage.h"
#import "Masonry.h"
#import "MLReturnsHeader.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLTuiHuoModel.h"
#import "MJExtension.h"
#import "HFSServiceClient.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLReturnRequestViewController.h"
#import "MBProgressHUD+Add.h"
#import "HFSUtility.h"
#import "MLMoreTableViewCell.h"
#import "MLReturnsDetailHeadCell.h"
#import "MLReturnsWentiTableViewCell.h"
#import "MLReturnsDetailPhototCell.h"
#import "MLLogisticsTableViewCell.h"
#import "UIColor+HeinQi.h"
#import "MLReturnsDetailModel.h"
#import "MLTuiHuoModel.h"
#import "MLReturnRequestViewController.h"




@interface MLReturnsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)MLReturnsDetailModel *returnsDetail;

@end

@implementation MLReturnsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLReturnsDetailHeadCell" bundle:nil] forCellReuseIdentifier:kReturnsDetailHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLReturnsWentiTableViewCell" bundle:nil] forCellReuseIdentifier:kReturnsWentiTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLReturnsDetailPhototCell" bundle:nil] forCellReuseIdentifier:kReturnsDetailPhototCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLLogisticsTableViewCell" bundle:nil] forCellReuseIdentifier:kLogisticsTableViewCell];
        
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self.view);
    }];
    [self getOrderDetail];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.returnsDetail.products.count+2;
    }else if (section==1){
        return 2;
    }
    return 5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakself = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MLReturnsDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kReturnsDetailHeadCell forIndexPath:indexPath];
            
            cell.tuiHuoModel = self.returnsDetail;
        
            cell.returnsDetailKeFuAction = ^(){//客服按钮
                
                
            };
            cell.returnsDetailBianjiAction = ^(){//编辑订单
                MLReturnRequestViewController *vc = [[MLReturnRequestViewController alloc]init];
                vc.order_id = weakself.returnsDetail.order_id;
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            cell.returnsDetailQuxiaoAction = ^(){ //取消订单
                [weakself returnsCancelAction];
            };
            
            return cell;
        }else if (indexPath.row == 1){
            MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.statusLabel.hidden = YES;
            cell.shopName.text = self.returnsDetail.company;
            
            return cell;
        }
        else{
            MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MLTuiHuoProductModel *model = [self.returnsDetail.products objectAtIndex:indexPath.row-2];
            cell.tuiHuoProduct = model;
            return cell;
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            MLReturnsWentiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReturnsWentiTableViewCell forIndexPath:indexPath];
            cell.wentiDesc.text = self.returnsDetail.returnInfo.question_type.content;
            cell.wentiText.text = self.returnsDetail.returnInfo.message;
            
            return cell;
        }
        else {
            MLReturnsDetailPhototCell *cell = [tableView dequeueReusableCellWithIdentifier:kReturnsDetailPhototCell forIndexPath:indexPath];
            cell.imgsArray = self.returnsDetail.returnInfo.pic;
            return cell;
        }
    }else{ //物流信息
        MLLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogisticsTableViewCell forIndexPath:indexPath];
        if (indexPath.row == 0) { //头
            cell.topLine.hidden = YES;
            cell.point.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
            cell.infoLabel.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
        }else if (indexPath.row == 4){ //尾
            cell.bottomLine.hidden = YES;
            cell.point2.hidden = YES;
            cell.point.backgroundColor = [UIColor colorWithHexString:@"#dcdcdc"];
            cell.infoLabel.textColor = [UIColor colorWithHexString:@"#0e0e0e"];
        }else{
            cell.point2.hidden = YES;
        }
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 130;
        }else if (indexPath.row == 1){
            return 40;
        }
        else{
            return 134;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 140;
        }else if (indexPath.row ==1){
            return 120;
        }
    }else{//物流信息
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 0;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 200, 40)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"售后信息跟踪";
    [headView addSubview:label];
    return headView;
}


#pragma mark 网络请求

- (void)getOrderDetail{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=order_detail&test_phone=13771961207&order_id=%@",@"http://bbctest.matrojp.com",self.order_id];
    NSDictionary *params = @{@"order_id":self.order_id?:@""};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSDictionary *order_detail = data[@"order_detail"];
            self.returnsDetail = [MLReturnsDetailModel mj_objectWithKeyValues:order_detail];
            [self.tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)returnsCancelAction{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=cancel",@"http://bbctest.matrojp.com"];
    NSDictionary *params = @{@"order_id":self.returnsDetail.order_id?:@""};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            //取消成功  返回上一页
            [MBProgressHUD showMessag:@"取消成功" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    
    
    
}





@end

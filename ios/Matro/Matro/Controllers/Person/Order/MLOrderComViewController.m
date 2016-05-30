//
//  MLOrderCommentViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderComViewController.h"
#import "HFSServiceClient.h"
#import "MLOrderSubComCell.h"
#import "MLOrderSubHeadCell.h"
#import "MLOrderComProductCell.h"
#import "UIColor+HeinQi.h"
#import "Masonry.h"
#import "MLOrderListModel.h"
#import "MJExtension.h"
#import "MLProductModel.h"
#import "HFSConstants.h"
#import "MBProgressHUD+Add.h"
#import "MLGoodsComViewController.h"


@interface MLOrderComViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)MLOrderListModel *orderDetail;

@end


static NSInteger logisticsScore,productScore,serviceScore;

@implementation MLOrderComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单评价";
    self.JLBH = @"160022049";
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderSubComCell" bundle:nil] forCellReuseIdentifier:kOrderComSubCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderSubHeadCell" bundle:nil] forCellReuseIdentifier:kOrderComHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderComProductCell" bundle:nil] forCellReuseIdentifier:kOrderComProductCell];
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    [self downLoadOrderDetail];
    // Do any additional setup after loading the view.
}



- (void)downLoadOrderDetail {
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/OrderDetail.ashx?op=orderdetail&jlbh=%@&tpgg=M&userid=%@",SERVICE_GETBASE_URL,self.JLBH?:@"",userId?:@""];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"订单详情 请求成功%@",responseObject);
        NSLog(@"dd %@",(NSDictionary*)responseObject);
        self.orderDetail = [MLOrderListModel mj_objectWithKeyValues:responseObject];
        if (self.orderDetail) {
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单详情 请求失败");
    }];
}

- (void)subOrderCom{
    
    if (logisticsScore > 0 && productScore >0 &&serviceScore) {
        NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID]?:@"";
        
        NSDictionary *parm = @{@"orderId":self.JLBH,@"userId":userId,@"productScore":[NSNumber numberWithInteger:productScore],@"serviceScore":[NSNumber numberWithInteger:serviceScore],@"logisticsScore":[NSNumber numberWithInteger:logisticsScore]};
        
        [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"order/StarScore" parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [responseObject objectForKey:@"status"];
            NSLog(@"%@",responseObject);
            if ([result isEqualToString:@"0"]) {
                
                [MBProgressHUD showSuccess:@"评价成功" toView:self.view];
                [self performSelector:@selector(goBack) withObject:nil afterDelay:2];
                
            }
            else{
                [MBProgressHUD showMessag:responseObject[@"msg"] toView:self.view];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [MBProgressHUD showMessag:@"请求失败" toView:self.view];
        }];
        
        
    }
    else{
        [MBProgressHUD showMessag:@"请完善评分" toView:self.view];
    }
}


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.orderDetail.PRODUCTLIST.count;
    }
    return 2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MLOrderComProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderComProductCell forIndexPath:indexPath];
        MLProductModel *product = [self.orderDetail.PRODUCTLIST objectAtIndex:indexPath.row];
        cell.product = product;
        __weak typeof(self) weakself = self;
        cell.goodsComblock = ^(){
            MLGoodsComViewController *vc = [[MLGoodsComViewController alloc]init];
            vc.product = product;
            vc.orderid = weakself.JLBH;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }
    else{
        if (indexPath.row == 0) {
            MLOrderSubHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderComHeadCell forIndexPath:indexPath];
            return cell;
        }
        else{
            MLOrderSubComCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderComSubCell forIndexPath:indexPath];
            [cell.subBtn addTarget:self action:@selector(subOrderCom) forControlEvents:UIControlEventTouchUpInside];
            cell.wuliuBlock = ^(NSInteger score){
                logisticsScore = score;
            };
            cell.fuwuBlock = ^(NSInteger score){
                serviceScore = score;

            };
            cell.shangpinBlock = ^(NSInteger score){
                productScore = score;
            };
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80.f;
    }
    else{
        if (indexPath.row == 0 ) {
            return 45.f;
        }
        return 192.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}



@end

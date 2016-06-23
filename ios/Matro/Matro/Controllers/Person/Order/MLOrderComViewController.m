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
#import "MJExtension.h"
#import "HFSConstants.h"
#import "MBProgressHUD+Add.h"
#import "MLGoodsComViewController.h"
#import "MLPersonOrderModel.h"
#import "MLCommentProductModel.h"



@interface MLOrderComViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *productArr;

@end


static NSInteger logisticsScore,productScore,serviceScore;

@implementation MLOrderComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单评价";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor whiteColor];
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
    [self getAllCommentProduct];
    // Do any additional setup after loading the view.
}



- (void)subOrderCom{
    
    if (logisticsScore > 0 && productScore >0 &&serviceScore) {
        NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID]?:@"";
        
        NSDictionary *parm = @{@"orderId":@"",@"userId":userId,@"productScore":[NSNumber numberWithInteger:productScore],@"serviceScore":[NSNumber numberWithInteger:serviceScore],@"logisticsScore":[NSNumber numberWithInteger:logisticsScore]};
        
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

- (void)getAllCommentProduct{
    
//    http://bbctest.matrojp.com/api.php?m=product&s=comment_submit&method=order&id={订单编号}&uid={用户编号}
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment_submit&method=order&id=%@&uid=13771961207",@"http://bbctest.matrojp.com",self.order_id];
    [[HFSServiceClient sharedJSONClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *order = data[@"order"];
            [self.productArr addObjectsFromArray:[MLCommentProductModel mj_objectArrayWithKeyValuesArray:order]];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}




#pragma mark tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.productArr.count;
    }
    return 2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MLOrderComProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderComProductCell forIndexPath:indexPath];
        MLCommentProductModel *product = [self.productArr objectAtIndex:indexPath.row];
        cell.product = product;
        __weak typeof(self) weakself = self;
        cell.goodsComblock = ^(){ //商品评价
            if (product.is_commented == 0) { //未评价  去商品评价页面
                MLGoodsComViewController *vc = [[MLGoodsComViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }else{ //已评价  去评价详情页面
                NSLog(@"去评价详情");
            }
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 8.f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }
    else{
        if (indexPath.row == 0 ) {
            return 44;
        }
        return 255.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,MAIN_SCREEN_WIDTH, 8)];
        footView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        return footView;
    }
    return nil;
}

- (NSMutableArray *)productArr{
    if (!_productArr) {
        _productArr = [NSMutableArray array];
    }
    return _productArr;
}





@end

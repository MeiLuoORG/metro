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
#import "MLProductComDetailViewController.h"
#import "MLHttpManager.h"



@interface MLOrderComViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger logisticsScore,productScore,serviceScore,fahuoScore;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *productArr;
@property (nonatomic,strong)NSDictionary *order_comment;

@end




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
    
    if (logisticsScore > 0 && productScore >0 &&serviceScore>0&&fahuoScore>0) {
        
        NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment_submit&method=order_submit&",MATROJP_BASE_URL];
        NSDictionary *params = @{@"snuma":[NSNumber numberWithInteger:productScore],@"snumd":[NSNumber numberWithInteger:logisticsScore],@"snumb":[NSNumber numberWithInteger:serviceScore],@"snumc":[NSNumber numberWithInteger:fahuoScore],@"id":self.order_id?:@""};
        
        [MLHttpManager post:url params:params m:@"product" s:@"comment_submit" success:^(id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            if ([result[@"code"] isEqual:@0]) {
                [MBProgressHUD showMessag:@"评价成功" toView:self.view];
            }else{
                NSString *msg = result[@"msg"];
                [MBProgressHUD showMessag:msg toView:self.view];
                
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment_submit&method=order&id=%@",MATROJP_BASE_URL,self.order_id];
    
    [MLHttpManager post:url params:nil m:@"product" s:@"comment_submit" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *order = data[@"order"];
            [self.productArr removeAllObjects];
            [self.productArr addObjectsFromArray:[MLCommentProductModel mj_objectArrayWithKeyValuesArray:order]];
            if ([data[@"order_comment"] isKindOfClass:[NSDictionary class]]) {
                self.order_comment = data[@"order_comment"];
            }
            [self.tableView reloadData];
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }

    } failure:^(NSError *error) {
         [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
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
                vc.product = product;
                vc.pid = product.pid;
                vc.goodsComSuccess = ^(){
                    [weakself getAllCommentProduct];
                };
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }else{ //已评价  去评价详情页面
                
                MLProductComDetailViewController *vc = [[MLProductComDetailViewController alloc]init];
                vc.comment_id = product.detail_id;
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
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
            if (self.order_comment) { //如果有值 赋值
                cell.subBtn.hidden = YES;
                cell.comment_info = self.order_comment;
                
            }else{
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
                cell.fahuoBlock = ^(NSInteger score){
                    fahuoScore = score;
                };

            }
            
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
        return 290.f;
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

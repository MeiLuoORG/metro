//
//  MLReturnsDetailViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/22.
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
#import "MLHttpManager.h"
#import "MJPhotoBrowser.h"
#import "UIViewController+MLMenu.h"

#import "MLPersonAlertViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLLoginViewController.h"
#import "MLTuihuoCaozuoCell.h"
#import "MLTuihuojineCell.h"

@interface MLReturnsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *talk_listArr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLReturnsDetailModel *returnsDetail;
@property (nonatomic,strong)MLReturnsReturnInfo *returnInfo;
@end

@implementation MLReturnsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"退货单详情";
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
        [tableView registerNib:[UINib nibWithNibName:@"MLTuihuoCaozuoCell" bundle:nil] forCellReuseIdentifier:@"MLTuihuoCaozuoCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLTuihuojineCell" bundle:nil] forCellReuseIdentifier:@"MLTuihuojineCell"];
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self.view);
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    
    [self addMenuButton];
    [self getOrderDetail];
}


- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.returnsDetail.products.count+3;
    }else if(section == 1){
        return 2;
    }else{
        return talk_listArr.count;
    }
    
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
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"打电话给客服？" message:KeFuDianHua preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    tel(KeFuDianHua);
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertVc addAction:doneAction];
                [alertVc addAction:cancel];
                [weakself presentViewController:alertVc animated:YES completion:nil];
            };
            cell.returnsDetailBianjiAction = ^(){//编辑订单
                MLReturnRequestViewController *vc = [[MLReturnRequestViewController alloc]init];
                vc.order_id = weakself.returnsDetail.order_id;
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            cell.returnsDetailQuxiaoAction = ^(){ //取消退货
                MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定取消退货？" AndAlertDoneAction:^{
                     [weakself returnsCancelAction];
                }];
                [self showTransparentController:vc];
                
            };
            return cell;
        }else if (indexPath.row == 1){
            MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.statusLabel.hidden = YES;
            cell.shopName.text = self.returnsDetail.company;
            
            return cell;
        }else if (indexPath.row == 2+self.returnsDetail.products.count){
            MLTuihuojineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLTuihuojineCell" forIndexPath:indexPath];
            cell.jiaoyiLab.text = [NSString stringWithFormat:@"￥%.2f",self.returnsDetail.transaction_price.floatValue];
            cell.tuikuanLab.text = [NSString stringWithFormat:@"￥%.2f",self.returnsDetail.return_price.floatValue];
            return cell;
        
        }
        else{
            MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MLTuiHuoProductModel *model = [self.returnsDetail.products objectAtIndex:indexPath.row-2];
            cell.shouhouBtn.hidden = YES;
            cell.countNum.hidden = YES;
            cell.tuiHuoProduct = model;
            return cell;
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            MLReturnsWentiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReturnsWentiTableViewCell forIndexPath:indexPath];
            cell.wentiDesc.text = self.returnInfo.question_type_content;
            cell.wentiText.text = self.returnInfo.message;
            
            return cell;
        }
        else {
            MLReturnsDetailPhototCell *cell = [tableView dequeueReusableCellWithIdentifier:kReturnsDetailPhototCell forIndexPath:indexPath];
            cell.imgsArray = self.returnInfo.pic;
            cell.returnPhotoClick = ^(NSInteger index){
               MJPhotoBrowser *_photoBrow = [[MJPhotoBrowser alloc]init];
                NSMutableArray *tmp = [NSMutableArray array];
                for (NSString *imgUrl  in self.returnInfo.pic) {
                    MJPhoto *photo = [[MJPhoto alloc]init];
                    photo.url = [NSURL URLWithString:imgUrl];
                    [tmp addObject:photo];
                }
                _photoBrow.photos = [tmp copy];
                _photoBrow.currentPhotoIndex = index;
                [_photoBrow show];
            };
            return cell;
        }
    }else{
        MLTuihuoCaozuoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLTuihuoCaozuoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (talk_listArr && talk_listArr.count >0) {
            
            NSDictionary *talkDic = [talk_listArr objectAtIndex:indexPath.row];
            cell.tuihuoInfoLab.text = talkDic[@"content"];
            cell.tuihuoTimeLab.text = talkDic[@"add_time"];
            cell.tuihuorenNameLab.text = [NSString stringWithFormat:@"操作人:%@",talkDic[@"username"]] ;
        }
        
        if (indexPath.row == 0) {
            cell.shangView.hidden = YES;
        }
        return cell;
        
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([self.returnsDetail.return_status isEqualToString:@"审核中"]) {
                return 140;
            }
            return 100;
        }else if (indexPath.row == 1 || indexPath.row == 2 + self.returnsDetail.products.count){
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
    }else if(indexPath.section == 2){
        return 130;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             return;
        }else if (indexPath.row == 1){
            return;
        }
        else{
            MLTuiHuoProductModel *model = [self.returnsDetail.products objectAtIndex:indexPath.row-2];
            MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
            NSDictionary *params = @{@"id":model.pid?:@""};
            vc.hidesBottomBarWhenPushed = YES;
            vc.paramDic = params;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, 40)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"售后信息跟踪";
    [headView addSubview:label];
    return headView;
}


#pragma mark 网络请求

- (void)getOrderDetail{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"vc.order_id===%@ vc.pro_id===%@",self.order_id,self.pro_id);
    [self showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=order_detail",MATROJP_BASE_URL];
    NSDictionary *params = @{@"order_id":self.order_id?:@"",@"pro_id":self.pro_id?:@""};
    [MLHttpManager post:url params:params m:@"return" s:@"order_detail" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSDictionary *returnInfo = data[@"returnInfo"];
            NSDictionary *order_detail = data[@"order_detail"];
            talk_listArr = data[@"order_detail"][@"talk_list"];
            NSLog(@"talk_listArr===%@",talk_listArr);
            
            self.returnsDetail = [MLReturnsDetailModel mj_objectWithKeyValues:order_detail];
            self.returnInfo = [MLReturnsReturnInfo mj_objectWithKeyValues:returnInfo];
            [self.tableView reloadData];
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
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
    
}

- (void)returnsCancelAction{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=cancel",MATROJP_BASE_URL];
    NSDictionary *params = @{@"order_id":self.returnsDetail.order_id?:@""};
    [MLHttpManager post:url params:params m:@"return" s:@"cancel" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            //取消成功  返回上一页
            [MBProgressHUD showMessag:@"取消成功" toView:self.view];
            if (self.cancelSuccess) {
                self.cancelSuccess();
            }
            [self performSelector:@selector(popback) withObject:nil afterDelay:1];
            
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

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}
- (void)popback{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

//
//  MLPersonController.m
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonController.h"
#import "MLPersonHeadView.h"
#import "MLPersonAccountCell.h"
#import "MLCusServiceCell.h"
#import "MLPersonOrderCell.h"
#import "MNNManagementViewController.h"
#import "MyAddressManagerViewController.h"
#import "HFSOrderListViewController.h"

#import "MLLoginViewController.h"
#import "YMNavigationController.h"
#import "UIButton+WebCache.h"

#import "APPSettingViewController.h"
#import "MLFootprintViewController.h"
#import "MLCusServiceController.h"
#import "MNNMemberViewController.h"
#import "MLWishlistViewController.h"
#import "MLPropertyCell.h"
#import "MLPropertysubCell.h"
#import "MLYHQViewController.h"
#import "MLMyPropertyViewController.h"
#import "JSBadgeView.h"
#import "MJRefresh.h"
#import "MLPersonOrderListViewController.h"

#import "MLCollectionViewController.h"

#import "MLAllOrdersViewController.h"
#import "MLAddressSelectViewController.h"
#import "MLCollectionViewController.h"
#import "MLStoreCollectViewController.h"

#import "MLServiceMainController.h"
#import "MLFootMarkViewController.h"

#import "MLLogisticsViewController.h"

@interface MLPersonController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSArray *imgArray;
    NSString *loginid;
    JSBadgeView *badgeView;
    UIButton * _messageButton;
    UIButton * _settingButton;
    JSBadgeView * _messageBadgeView;
    
    UIScrollView * _backgroundScrollView;
    UIView * _fourButtonsBackView;
    UIView * _thirdButtonBackView;

    UILabel * _xingYunXingValueLabel;
    UILabel * _jiFenValueLabel;
    UILabel * _youhuiValueLabel;
    UILabel * _yuEValueLabel;
    
    float _thirderHeight;
    float _zongViewHeight;
    BOOL _isRenZhengQequestSuc;
    BOOL _isRenZheng;
    
    NSString * _pay_id;
    NSString * _pay_mobile;
    NSString * _real_name;
    NSString * _identity_card;
    NSString * _identity_picurl;
    BOOL  _iS_identity_verify;
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLPersonHeadView *headView;
@property (strong, nonatomic) SecondBtnsView * secondBtnsView;

@end

@implementation MLPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     self.navigationItem.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = nil;
    
    //加载背景图
    _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-64-49)];
    _backgroundScrollView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    
    [self.view addSubview:_backgroundScrollView];
    

    _messageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _messageButton.frame = CGRectMake(0, 0, 22, 22);
    [_messageButton setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [_messageButton addTarget:self action:@selector(actMessage) forControlEvents:UIControlEventTouchUpInside];




    _messageBadgeView = [[JSBadgeView alloc]initWithParentView:_messageButton alignment:JSBadgeViewAlignmentTopRight];
    _messageBadgeView.badgeText = @"●";
    [_messageBadgeView setBadgeTextColor:[HFSUtility hexStringToColor:Main_textRedBackgroundColor]];
    [_messageBadgeView setBadgeBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *message = [[UIBarButtonItem alloc]initWithCustomView:_messageButton];
    UIView *s = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 22)];
    
    
    UIBarButtonItem *l = [[UIBarButtonItem alloc]initWithCustomView:s];
    

    _settingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _settingButton.frame = CGRectMake(0, 0, 22, 22);
    [_settingButton setBackgroundImage:[UIImage imageNamed:@"settingzl"] forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(actSettingAction) forControlEvents:UIControlEventTouchUpInside];



    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithCustomView:_settingButton];
    
    self.navigationItem.rightBarButtonItems = @[message,l,setting];
    
    _headView = ({
        MLPersonHeadView *headView =[MLPersonHeadView personHeadView];
        __weak typeof(self)weakself = self;
        headView.loginBlock = ^(){
            [self hideZLMessageBtnAndSetingBtn];
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = YES;
            //YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
            
            [weakself presentViewController:vc animated:YES completion:nil];
            
        };
        headView.regBlock = ^(){
            [self hideZLMessageBtnAndSetingBtn];
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = NO;
            //YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
            [weakself presentViewController:vc animated:YES completion:nil];
        };
        headView.imageBlock = ^(){
            if (!loginid) {
                [weakself showError];
            }
            else{
                [self hideZLMessageBtnAndSetingBtn];
                MNNManagementViewController *managementVC = [[MNNManagementViewController alloc] init];
                managementVC.hidesBottomBarWhenPushed = YES;

                [weakself.navigationController pushViewController:managementVC animated:YES];
            }

        };
        
        headView;
    });
    [_backgroundScrollView addSubview:_headView];
    //self.tableView.tableHeaderView = self.headView;
    
    /*
    _backgroundScrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableView.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
        badgeView.hidden = NO;
    }];
    */
    [self loadSecondButtonsView];
    [self loadThirdButtonsView];
    [self loadFourButtonsView];
    [self ctreateYOUHUIQuanView];
    
    //李佳接口认证成功后  接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(renZhengAction:) name:RENZHENG_LIJIA_Notification object:nil];
}
- (void)renZhengAction:(id)sender{
    //查询实名认证
    [self chaXunISshiMingRenZheng];
}

#pragma mark zhoulu 第二栏按钮组
- (void)loadSecondButtonsView{
/*
    
    for (int i = 0; i<5; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setFrame:CGRectMake(32, 20, 27, 60)];
        btn.tag = 1000+i;
        
        [_backgroundScrollView addSubview:btn];
    }
*/
    self.secondBtnsView = ({
        SecondBtnsView *headView =[SecondBtnsView personHeadView];
         __weak typeof(self)weakself = self;
        headView.frame = CGRectMake(0, 110, SIZE_WIDTH, 67);
        headView.view2CenterX.constant = -((SIZE_WIDTH/2)-56)/2;
        headView.view4CenterX.constant = ((SIZE_WIDTH/2)-56)/2;
        
        headView.daiFuBLock = ^(BOOL success){
            //待付款
            NSLog(@"待付款");
            if (!loginid) {
                [weakself showError];
                return;
            }else{
                MLPersonOrderListViewController *vc = [[MLPersonOrderListViewController alloc]initWithOrderType:OrderType_Fukuan];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
                
                
            }
            
        };
        headView.daiFaHuoBLock = ^(BOOL success){
            //代发货
            
            if (!loginid) {
                [weakself showError];
                return;
            }else{
                
            MLPersonOrderListViewController *vc = [[MLPersonOrderListViewController alloc]initWithOrderType:OrderType_Shouhuo];
            vc.hidesBottomBarWhenPushed = YES;
            [weakself.navigationController pushViewController:vc animated:YES];
                
            }
        };
        headView.daiPingBLock = ^(BOOL success){
            //待评价
            NSLog(@"待评价");
            if (!loginid) {
                [weakself showError];
                return;
            }else{
                MLPersonOrderListViewController *vc = [[MLPersonOrderListViewController alloc]initWithOrderType:OrderType_Pingjia];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        };
        headView.tuiHuoBLock = ^(BOOL success){
            //退货订单
            if (!loginid) {
                [weakself showError];
                return;
            }else{
                MLServiceMainController *vc = [[MLServiceMainController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
                
                
            }
        };
        
        headView.quanBuBLock = ^(BOOL success){
            //全部订单
            NSLog(@"全部订单");
            if (!loginid) {
                [weakself showError];
                return;
            }else{
                MLAllOrdersViewController *vc = [[MLAllOrdersViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        };
        
        
        
        headView;
    });
    [_backgroundScrollView addSubview:self.secondBtnsView];

}



#pragma end mark 第二按钮组结束

#pragma mark 第三按钮组

- (void)loadThirdButtonsView{

    _thirdButtonBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 182, SIZE_WIDTH, (310.0f/750.0f)*SIZE_WIDTH)];
    _thirdButtonBackView.backgroundColor = [UIColor whiteColor];
    [_backgroundScrollView addSubview:_thirdButtonBackView];
    
    UILabel * labels = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 15)];
    labels.text = @"我的资产";
    labels.font = [UIFont systemFontOfSize:14.0f];
    labels.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    [_thirdButtonBackView addSubview:labels];
    
    UIView * spLiner = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SIZE_WIDTH, 1)];
    spLiner.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [_thirdButtonBackView addSubview:spLiner];
    

    
    _xingYunXingValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 55, 50, 18)];
    _xingYunXingValueLabel.text = @"20000";
     _xingYunXingValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _xingYunXingValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _xingYunXingValueLabel.textAlignment = NSTextAlignmentCenter;
    _xingYunXingValueLabel.adjustsFontSizeToFitWidth = YES;
    _xingYunXingValueLabel.minimumScaleFactor = 0.5f;
    
    
    
     UILabel * xingYunLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 70, 50, 18)];
    xingYunLabel.text = @"幸运星";
    xingYunLabel.font = [UIFont systemFontOfSize:11.0f];
    xingYunLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    xingYunLabel.textAlignment = NSTextAlignmentCenter;
    xingYunLabel.adjustsFontSizeToFitWidth = YES;
    xingYunLabel.minimumScaleFactor = 0.5f;

    
    _jiFenValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3+94), 55, 50, 18)];
    _jiFenValueLabel.text = @"20000";
    _jiFenValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _jiFenValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _jiFenValueLabel.textAlignment = NSTextAlignmentCenter;
    _jiFenValueLabel.adjustsFontSizeToFitWidth = YES;
    _jiFenValueLabel.minimumScaleFactor = 0.5f;
    
    UILabel * jiFenLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3.0f+94), 70, 50, 18)];
    jiFenLabel.text = @"积分";
    jiFenLabel.font = [UIFont systemFontOfSize:11.0f];
    jiFenLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    jiFenLabel.textAlignment = NSTextAlignmentCenter;
    jiFenLabel.adjustsFontSizeToFitWidth = YES;
    jiFenLabel.minimumScaleFactor = 0.5f;
    
    _youhuiValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3.0f*2.0f+144), 55, 50, 18)];
    _youhuiValueLabel.text = @"4";
    _youhuiValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _youhuiValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _youhuiValueLabel.textAlignment = NSTextAlignmentCenter;
    _youhuiValueLabel.adjustsFontSizeToFitWidth = YES;
    _youhuiValueLabel.minimumScaleFactor = 0.5f;
    
    
    
    UILabel * youhuiLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3.0f*2.0f+144), 70, 50, 18)];
    youhuiLabel.text = @"优惠券";
    youhuiLabel.font = [UIFont systemFontOfSize:11.0f];
    youhuiLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    youhuiLabel.textAlignment = NSTextAlignmentCenter;
    youhuiLabel.adjustsFontSizeToFitWidth = YES;
    youhuiLabel.minimumScaleFactor = 0.5f;
    
    
    _yuEValueLabel = [[UILabel alloc]initWithFrame:CGRectMake((SIZE_WIDTH-44-50), 55, 50, 18)];
    _yuEValueLabel.text = @"34588";
    _yuEValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _yuEValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _yuEValueLabel.textAlignment = NSTextAlignmentCenter;
    _yuEValueLabel.adjustsFontSizeToFitWidth = YES;
    _yuEValueLabel.minimumScaleFactor = 0.5f;
    
    UILabel * yuElabel = [[UILabel alloc]initWithFrame:CGRectMake((SIZE_WIDTH-44-50), 70, 50, 18)];
    yuElabel.text = @"余额";
    yuElabel.font = [UIFont systemFontOfSize:11.0f];
    yuElabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    yuElabel.textAlignment = NSTextAlignmentCenter;
    yuElabel.adjustsFontSizeToFitWidth = YES;
    yuElabel.minimumScaleFactor = 0.5f;
    
    [_thirdButtonBackView addSubview:xingYunLabel];
    [_thirdButtonBackView addSubview:_xingYunXingValueLabel];
    [_thirdButtonBackView addSubview:jiFenLabel];
    [_thirdButtonBackView addSubview:_jiFenValueLabel];
    [_thirdButtonBackView addSubview:youhuiLabel];
    [_thirdButtonBackView addSubview:_youhuiValueLabel];
    [_thirdButtonBackView addSubview:yuElabel];
    [_thirdButtonBackView addSubview:_yuEValueLabel];
    
    UIButton * dianWOButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dianWOButton setFrame:CGRectMake(0, (310.0f/750.0f)*SIZE_WIDTH-(100.0f/750.0f)*SIZE_WIDTH, SIZE_WIDTH, (100.0f/750.0f)*SIZE_WIDTH)];
    [dianWOButton setBackgroundImage:[UIImage imageNamed:@"bannarzl"] forState:UIControlStateNormal];
    //[dianWOButton setTitle:@"领取优惠券，请戳这里" forState:UIControlStateNormal];
    [dianWOButton setBackgroundColor:[UIColor blueColor]];
    [dianWOButton addTarget:self action:@selector(bannarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_thirdButtonBackView addSubview:dianWOButton];
 
    _thirderHeight = 182.0f+(310.0f/750.0f)*SIZE_WIDTH;
}

//领取优惠券视图
- (void)ctreateYOUHUIQuanView{

     __weak typeof (self) weakSelf = self;
    self.lingQuQuanView = [[LingQuYouHuiQuanView alloc]initWithFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
    self.lingQuQuanView.quanARR = [[NSMutableArray alloc]init];
    [self.lingQuQuanView createView];
    
    [self.lingQuQuanView setHideBlockAction:^(BOOL success) {
        [weakSelf.tabBarController.tabBar setHidden:NO];
        [UIView animateWithDuration:0.2f animations:^{
            weakSelf.lingQuQuanView.frame = CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT);
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    [self.lingQuQuanView selectQuanBlockAction:^(BOOL success, YouHuiQuanModel *ret) {
        if (ret) {
            
            
            [weakSelf selectYouHuiQuan:ret];
        }
    }];
    
    [self.view addSubview:self.lingQuQuanView];
    

}

- (void)bannarButtonAction:(UIButton *)sender{
    
    
    //self.navigationController.toolbar.hidden = YES;
     //self.hidesBottomBarWhenPushed = YES;

       // __weak typeof (self) weakSelf = self;
    [self qignQiuYouHuiQuan];
    
        NSLog(@"执行了加载了优惠圈视图");
        [UIView animateWithDuration:0.2f animations:^{
            self.lingQuQuanView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT);
        
        } completion:^(BOOL finished) {
            [self.tabBarController.tabBar setHidden:YES];
        }];
        

 
    
    
}


#pragma mark  请求优惠券
- (void)qignQiuYouHuiQuan{
//http://bbctest.matrojp.com/api.php?m=member&s=admin_coupons&action=all_coupons&test_phone=18260127042
    
    [MLHttpManager get:LingQuYouHuiQuan_URLString params:nil m:@"member" s:@"admin_coupons" success:^(id responseObject) {
        NSLog(@"请求优惠券信息：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        NSDictionary * dataDic = result[@"data"];
        NSArray  *  b2cQuanARR = dataDic[@"b2c_coupons"];
        if (b2cQuanARR.count > 0) {
            for (NSDictionary * quanDic in b2cQuanARR) {
             
                YouHuiQuanModel * model = [[YouHuiQuanModel alloc]init];
                model.startTime = quanDic[@"YXQ_B"];
                model.endTime = quanDic[@"YXQ_E"];
                model.mingChengStr = quanDic[@"YHQMC"];
                model.flag = quanDic[@"FLAG"];
                model.jinE = quanDic[@"JE"];
                model.quanBH = quanDic[@"JLBH"];
                model.quanID = quanDic[@"YHQID"];
                model.quanType = quanDic[@"CXLX"];
                
                [self.lingQuQuanView.quanARR addObject:model];
            }
        }
        
        [self.lingQuQuanView.tablieview reloadData];
        
    } failure:^(NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
    }];
    
}

- (void)selectYouHuiQuan:(YouHuiQuanModel *)model{
    NSLog(@"优惠券信息;%@,%@,%@",model.quanType,model.quanBH,model.quanID);
    
    NSDictionary * ret = @{@"cxlx":model.quanType,
                           @"jlbh":model.quanBH,
                           @"yhqid":model.quanID
                           };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:nil];
    //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *params = @{@"action":@"set_coupons"};
    
    /*
    [[HFSServiceClient sharedJSONClient] POST:LingQuanAction_URLString parameters:ret constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"点击领取优惠券%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"优惠券请求失败：%@",error);
    }];
    */
    
    [MLHttpManager post:LingQuanAction_URLString params:ret m:@"member" s:@"admin_coupons" sconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

    } success:^(id responseObject) {
           NSLog(@"点击领取优惠券%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"优惠券请求失败：%@",error);
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];
    
    
    /*
    //m=member&s=admin_coupons&action=set_coupons&test_phone=18868672308
    [MLHttpManager post:LingQuanAction_URLString params:ret m:@"member" s:@"admin_coupons" success:^(id responseObject) {
        NSLog(@"点击领取优惠券%@",responseObject);
        
    } failure:^(NSError *error) {
        NSLog(@"优惠券请求失败：%@",error);
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];
    */

}

#pragma end mark


#pragma end mark 第三按钮组


#pragma mark 第四按钮组
- (void)loadFourButtonsView{

    _fourButtonsBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _thirderHeight, SIZE_WIDTH, 250)];
    _fourButtonsBackView.backgroundColor = [UIColor whiteColor];
    [_backgroundScrollView addSubview:_fourButtonsBackView];
    
    float btnHW = SIZE_WIDTH/3;
    
    static int k = 0;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<3; j++) {
            
            UIImageView * imageview = [[UIImageView alloc]init];
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            UILabel * label = [UILabel new];
            label.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
            label.textAlignment = NSTextAlignmentCenter;
            [label setFrame:CGRectMake(0, 0, 70, 20)];
            label.font = [UIFont systemFontOfSize:11.0f];
            [btn addTarget:self action:@selector(foursButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:imageview];
            [btn addSubview:label];
            
            [_fourButtonsBackView addSubview:btn];
            
            if (k == 0) {
                imageview.image = [UIImage imageNamed:@"shoucangzl"];
                label.text = @"商品收藏";
                [btn setFrame:CGRectMake(0, 0, btnHW ,btnHW)];
                btn.tag = 101;
                [btn addSubview:imageview];
                [btn addSubview:label];
                
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.width.height.mas_equalTo(24);
                    make.centerX.equalTo(btn);
                    make.centerY.equalTo(btn).offset(-5);
                    
                    
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {

                    make.centerX.equalTo(btn);
                    
                    make.top.equalTo(imageview.mas_bottom).offset(5);
                }];
                
            }
            
            if (k == 1) {
                imageview.image = [UIImage imageNamed:@"dianpuzl"];
                label.text = @"店铺收藏";
                [btn setFrame:CGRectMake(btnHW, 0, btnHW ,btnHW)];
                [btn addSubview:imageview];
                [btn addSubview:label];
                btn.tag = 102;
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.width.height.mas_equalTo(24);
                    make.centerX.equalTo(btn);
                    make.centerY.equalTo(btn).offset(-5);
                    
                    
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {

                    make.centerX.equalTo(btn);
                    make.top.equalTo(imageview.mas_bottom).offset(5);
                }];
            }
            if (k == 2) {
                imageview.image = [UIImage imageNamed:@"huiyuankazl"];
                label.text = @"会员卡";
                [btn setFrame:CGRectMake(btnHW*2, 0, btnHW ,btnHW)];
                [btn addSubview:imageview];
                [btn addSubview:label];
                btn.tag = 103;
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.width.height.mas_equalTo(24);
                    make.centerX.equalTo(btn);
                    make.centerY.equalTo(btn).offset(-5);
                    
                    
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {

                    make.centerX.equalTo(btn);
                    make.top.equalTo(imageview.mas_bottom).offset(5);
                }];
            }
            
            if (k == 3) {
                imageview.image = [UIImage imageNamed:@"kefuzl"];
                label.text = @"客服";
                [btn setFrame:CGRectMake(0, btnHW, btnHW ,btnHW)];
                [btn addSubview:imageview];
                [btn addSubview:label];
                btn.tag = 104;
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.width.height.mas_equalTo(24);
                    make.centerX.equalTo(btn);
                    make.centerY.equalTo(btn).offset(-5);
                    
                    
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {

                    make.centerX.equalTo(btn);
                    make.top.equalTo(imageview.mas_bottom).offset(5);
                }];
            }
            if (k == 4) {
                imageview.image = [UIImage imageNamed:@"zujizl"];
                label.text = @"足迹";
                [btn setFrame:CGRectMake(btnHW, btnHW, btnHW ,btnHW)];
                [btn addSubview:imageview];
                [btn addSubview:label];
                btn.tag = 105;
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.width.height.mas_equalTo(24);
                    make.centerX.equalTo(btn);
                    make.centerY.equalTo(btn).offset(-5);
                    
                    
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {

                    make.centerX.equalTo(btn);
                    make.top.equalTo(imageview.mas_bottom).offset(5);
                }];
            }
            if (k == 5) {
                imageview.image = [UIImage imageNamed:@"renzhengzl"];
                label.text = @"实名认证";
                [btn setFrame:CGRectMake(btnHW*2, btnHW, btnHW ,btnHW)];
                [btn addSubview:imageview];
                [btn addSubview:label];
                btn.tag = 106;
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.width.height.mas_equalTo(24);
                    make.centerX.equalTo(btn);
                    make.centerY.equalTo(btn).offset(-5);
                    
                    
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {

                    make.centerX.equalTo(btn);
                    make.top.equalTo(imageview.mas_bottom).offset(5);
                }];
            }

            
            k++;
        }
    }
    UIView * hSplinerView = [[UIView alloc]initWithFrame:CGRectMake(0, btnHW, SIZE_WIDTH, 1)];
    hSplinerView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [_fourButtonsBackView addSubview:hSplinerView];
    
    UIView * VSplinerView1 = [[UIView alloc]initWithFrame:CGRectMake(btnHW, 0, 1, btnHW*2)];
    VSplinerView1.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [_fourButtonsBackView addSubview:VSplinerView1];
    UIView * VSplinerView2 = [[UIView alloc]initWithFrame:CGRectMake(btnHW*2, 0, 1, btnHW*2)];
    VSplinerView2.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [_fourButtonsBackView addSubview:VSplinerView2];
    
    _zongViewHeight = _thirderHeight + SIZE_WIDTH/3*2;
    
    

}

- (void)foursButtonsAction:(UIButton * )sender{

    if (sender.tag == 101) {
        NSLog(@"0商品收藏");
        if (!loginid) {
            [self showError];
            return;
        }
       
        [self hideZLMessageBtnAndSetingBtn];
        MLCollectionViewController *vc = [[MLCollectionViewController alloc] init];
         vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
        
        
        
    }
    if (sender.tag == 102) {
         NSLog(@"1店铺收藏");
        if (!loginid) {
            [self showError];
            return;
        }
        [self hideZLMessageBtnAndSetingBtn];
        MLStoreCollectViewController *vc = [[MLStoreCollectViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
    if (sender.tag == 103) {
         NSLog(@"2会员卡");
        if (!loginid) {
            [self showError];
            return;
        }
        [self hideZLMessageBtnAndSetingBtn];
        NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
        NSString * str = [userdefault objectForKey:kUSERDEFAULT_USERCARDNO];
        if(![str isEqualToString:@""] && str ) {
            MNNMemberViewController *memberVC = [MNNMemberViewController new];
            memberVC.hidesBottomBarWhenPushed = YES;
            //[memberVC loadData];
            [self.navigationController pushViewController:memberVC animated:YES];
        }

    }
    if (sender.tag == 104) {
         NSLog(@"3客服");
    }
    if (sender.tag == 105) {
         NSLog(@"4足迹");
        if (!loginid) {
            [self showError];
            return;
        }
        [self hideZLMessageBtnAndSetingBtn];
        MLFootMarkViewController *vc = [[MLFootMarkViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
    if (sender.tag == 106) {
        if (!loginid) {
            [self showError];
            return;
        }
        NSDatezlModel * model1 = [NSDatezlModel sharedInstance];
        NSLog(@"model2地址为：%p",model1);
        [model1 currentTimeDate];
        
        if (_isRenZhengQequestSuc) {
            ShiMingViewController * shiMingVC = [[ShiMingViewController alloc]init];
            shiMingVC.hidesBottomBarWhenPushed = YES;
            shiMingVC.isRenZheng = _isRenZheng;
            if (_isRenZheng) {
                shiMingVC.pay_id = _pay_id;
                shiMingVC.userPhone = _pay_mobile;
                shiMingVC.userName = _real_name;
                shiMingVC.userShenFenCardID = _identity_card;
                shiMingVC.shenFenImageURLStr = _identity_picurl;
                
            }
            
            [self.navigationController pushViewController:shiMingVC animated:YES];
        }

        
        
         NSLog(@"5实名认证");
    }

}


#pragma mark 查询实名认证
- (void)chaXunISshiMingRenZheng{
    [MLHttpManager get:CHAXUNRENZHENG_RENZHENG_URLStrign params:nil m:@"member" s:@"admin_member" success:^(id responseObject) {
        NSLog(@"查询实名认证：%@",responseObject);
        NSDictionary * dataDic = responseObject[@"data"];
        //identity_list
        _iS_identity_verify = dataDic[@"identity_varify"];
        if (_iS_identity_verify) {
            
            _headView.renZhengLabel.text = @"已认证";
            _isRenZheng = YES;
            
            _pay_id = dataDic[@"pay_id"];
            _pay_mobile = dataDic[@"pay_mobile"];
            _real_name = dataDic[@"real_name"];
            _identity_card = dataDic[@"identity_card"];
            _identity_picurl = dataDic[@"identity_pic"];
        }
        else{
            _isRenZheng = NO;
            _headView.renZhengLabel.text = @"未认证";
        }
        _isRenZhengQequestSuc = YES;
    } failure:^(NSError *error) {
        _isRenZhengQequestSuc = NO;
        NSLog(@"查询实名认证失败：%@",error);
    }];
}


#pragma mark 隐藏消息按钮
- (void)hideZLMessageBtnAndSetingBtn{
    _messageButton.hidden = YES;
    _settingButton.hidden = YES;
    
}
- (void)showZLMessageBtnAndSettingBtn{

    [self performSelector:@selector(howZLView) withObject:self afterDelay:0.3f];
}

- (void)howZLView{
    
    _messageButton.hidden = NO;
    _settingButton.hidden = NO;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    NSString *avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
    if (loginid && ![@"" isEqualToString:loginid]) {
        self.headView.loginBtn.hidden = YES;
        self.headView.regBtn.hidden = YES;
        
        self.headView.headBtn.hidden = NO;
        self.headView.rightBtn.hidden = NO;
        self.headView.renZhengLabel.hidden = NO;
        self.headView.biaoZhiImageView.hidden = NO;
        self.headView.nickLabel.hidden = NO;
        self.headView.cardTypeLabel.hidden = NO;
        
        _thirdButtonBackView.hidden = NO;
        
        [_fourButtonsBackView setFrame:CGRectMake(0, _thirderHeight, SIZE_WIDTH, SIZE_WIDTH/3.0*2.0)];
        
        _zongViewHeight = _thirderHeight + SIZE_WIDTH/3.0*2.0;
        
        if (_zongViewHeight > SIZE_HEIGHT-49.0-64.0) {
        
            _backgroundScrollView.contentSize = CGSizeMake(SIZE_WIDTH, _zongViewHeight);
        }
        else{
            _backgroundScrollView.contentSize = CGSizeMake(SIZE_WIDTH, SIZE_HEIGHT-49.0-64.0);
        }
        

        
    }
    else{
        self.headView.loginBtn.hidden = NO;
        self.headView.regBtn.hidden = NO;
        
        self.headView.headBtn.hidden = YES;
        self.headView.rightBtn.hidden = YES;
        self.headView.renZhengLabel.hidden = YES;
        self.headView.biaoZhiImageView.hidden = YES;
        self.headView.nickLabel.hidden = YES;
        self.headView.cardTypeLabel.hidden = YES;
        
        _thirdButtonBackView.hidden = YES;
        
        [_fourButtonsBackView setFrame:CGRectMake(0, 182, SIZE_WIDTH, SIZE_WIDTH/3.0*2.0)];
        
        _zongViewHeight = 182 + SIZE_WIDTH/3.0*2.0;
        
        if (_zongViewHeight > SIZE_HEIGHT-49.0-64.0) {
            
            _backgroundScrollView.contentSize = CGSizeMake(SIZE_WIDTH, _zongViewHeight);
        }
        else{
            _backgroundScrollView.contentSize = CGSizeMake(SIZE_WIDTH, SIZE_HEIGHT-49.0-64.0);
        }
        
    }
    NSString *nickname = [userDefaults objectForKey:kUSERDEFAULT_USERNAME];
    NSLog(@"用户昵称为：%@",nickname);
    if (nickname && ![@"" isEqualToString:nickname]) {
        
        //会员类型 名称
        NSString * cardTypeid = [userDefaults objectForKey:KUSERDEFAULT_CARDTYPE_CURRENT];
        NSLog(@"会员卡类型：%@",cardTypeid);
        if (cardTypeid) {
            self.headView.cardTypeLabel.text = [NSString stringWithFormat:@"%@",cardTypeid];
            self.headView.cardTypeLabel.hidden = NO;
        }
        
        self.headView.nickLabel.text = nickname;
        self.headView.nickLabel.hidden = NO;
    }
    else
    {
        self.headView.nickLabel.hidden = YES;
        self.headView.cardTypeLabel.hidden = YES;
    }
    

    
    [self.headView.headBtn sd_setImageWithURL:[NSURL URLWithString:avatorurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
    
    [self showZLMessageBtnAndSettingBtn];
    
    //查询实名认证
    [self chaXunISshiMingRenZheng];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!loginid) {
        [self showError];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) { //我的订单
        MLAllOrdersViewController *vc = [[MLAllOrdersViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"我的资产");
        /*
        MLMyPropertyViewController *vc = [[MLMyPropertyViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
         */
    }
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:  //会员卡
            {
                NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
                NSString * str = [userdefault objectForKey:kUSERDEFAULT_USERCARDNO];
                if(![str isEqualToString:@""] && str ) {
                    MNNMemberViewController *memberVC = [MNNMemberViewController new];
                    memberVC.hidesBottomBarWhenPushed = YES;
                    //[memberVC loadData];
                    [self.navigationController pushViewController:memberVC animated:YES];
                }

                
            }
                break;
            case 1:   //客服服务
            {
                
                MLCusServiceController *vc = [[MLCusServiceController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:  //浏览足迹
            {
                MLFootprintViewController *vc = [[MLFootprintViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
                break;
            case 3:  //设置
            {


            }
                break;
            case 4:  //意见反馈
            {
            }
                break;
                
                
            default:
                break;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakself = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MLPersonAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPersonAccountCell forIndexPath:indexPath];
            cell.accountBlcok = ^(){
                
                if (!loginid) {
                    [weakself showError];
                }
                else{
                    MNNManagementViewController *managementVC = [[MNNManagementViewController alloc] init];
                    managementVC.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:managementVC animated:YES];
                }

            };
            cell.addressBlcok = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    MyAddressManagerViewController *vc = [[MyAddressManagerViewController alloc]init];
                    //    vc.delegate = nil;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
             
            };
            cell.storeBlcok = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    
                    MLCollectionViewController *vc = [[MLCollectionViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    /*
                    MLWishlistViewController *vc = [[MLWishlistViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                     */
                }

            };
            return cell;
        }else if (indexPath.row == 1){
            MLCusServiceCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLCusServiceCell forIndexPath:indexPath];
            cell.myTitleLabel.text = @"我的订单";
            cell.myImageView.image = [UIImage imageNamed:@"wodedingdan"];
            cell.mySubLabel.text = @"查看订单";
            cell.mySubLabel.hidden = NO;
            return cell;
        }
        else if (indexPath.row == 2){
            MLPersonOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPersonOrderCell forIndexPath:indexPath];
            //badgeView = [[JSBadgeView alloc] initWithParentView:cell.imgDaifukuan alignment:JSBadgeViewAlignmentTopRight];
            //badgeView.badgeText = @"2";
            //zhoulu
            JSBadgeView * badge1 = [[JSBadgeView alloc]initWithParentView:cell.imgDaifahuo alignment:JSBadgeViewAlignmentTopRight];
            badge1.badgeText = @"0";
            JSBadgeView * badge2 = [[JSBadgeView alloc]initWithParentView:cell.imgDaifukuan alignment:JSBadgeViewAlignmentTopRight];
            badge2.badgeText = @"12";
            JSBadgeView * badge3 = [[JSBadgeView alloc]initWithParentView:cell.imgDaishouhuo alignment:JSBadgeViewAlignmentTopRight];
            badge3.badgeText = @"12";
            JSBadgeView * badge4 = [[JSBadgeView alloc]initWithParentView:cell.imgTuikuan alignment:JSBadgeViewAlignmentTopRight];
            badge4.badgeText = @"12";
            
            cell.daifahuoBlcok = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    HFSOrderListViewController *vc = [[HFSOrderListViewController alloc]init];
                    vc.typeInteger = 2;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
            cell.daifukuanBlock = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    badgeView.hidden = YES;
                    MLPersonOrderListViewController *vc = [[MLPersonOrderListViewController alloc]initWithOrderType:OrderType_Fukuan];

                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
              
            };
            cell.daishouhuoBlock = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    MLPersonOrderListViewController *vc = [[MLPersonOrderListViewController alloc]initWithOrderType:OrderType_Shouhuo];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
               
            };
            cell.tuihuoBlock = ^(){
                if (!loginid) {
                    [self showError];
                }
                else{
                    MLAddressSelectViewController *vc = [[MLAddressSelectViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
               
            };
            return cell;
        }
    }
    else if (indexPath.section == 1){
    
        if (indexPath.row == 0) {
            MLPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPropertyCell forIndexPath:indexPath];
            cell.myImageView.image = [UIImage imageNamed:@"Outlined_gray"];
            cell.labProperty.text = @"我的资产";
            return cell;
        }
        else{
            MLPropertysubCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLPropertysubCell forIndexPath:indexPath];
            cell.sorceBlcok = ^(){
                
                if (!loginid) {
                    [self showError];
                }else{
                
                    NSLog(@"线上积分");
                }
            };
            cell.chargeBlock = ^(){
            
                if (!loginid) {
                    [self showError];
                }else{
                    NSLog(@"优惠券");
                    MLYHQViewController *vc = [[MLYHQViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            };
            cell.moneyBlock = ^(){
                if (!loginid) {
                    [self showError];
                }else{
                
                    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                    NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2290103097&version=1&src_type=web"];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    //webView.delegate = self;
                    [webView loadRequest:request];
                    [self.view addSubview:webView];
                    NSLog(@"余额");
                }
            
            };
            return cell;
        }
    }
    MLCusServiceCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLCusServiceCell forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.myTitleLabel.text = @"会员卡";
            cell.myImageView.image = [UIImage imageNamed:@"Outlined_gray"];
            cell.mySubLabel.text = @"享受特权";
            cell.mySubLabel.hidden = NO;
            
        }
            break;
        case 1:
        {
            cell.myTitleLabel.text = @"客服服务";
            cell.myImageView.image = [UIImage imageNamed:@"kehufuwu"];
        }
            break;
        case 2:
        {
            cell.myTitleLabel.text = @"浏览足迹";
            cell.myImageView.image = [UIImage imageNamed:@"liulanzuji"];
        }
            break;
        case 3:
        {
            cell.myTitleLabel.text = @"设置";
            cell.myImageView.image = [UIImage imageNamed:@"Settings"];
            cell.mySubLabel.hidden = NO;
            cell.mySubLabel.text = @"应用设置";
            
        }
            break;
        case 4:
        {
            cell.myTitleLabel.text = @"意见反馈";
            cell.myImageView.image = [UIImage imageNamed:@"Highlighter"];
        }
            break;   
        default:
            break;
    }

    return cell;

}

-(void)showError
{
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
    //YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return [[UIView alloc]init];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 1? 8:0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row == 2) {
        return 70;
    }if (indexPath.section == 1 && indexPath.row == 1) {
        return 60;
    }
    return 44;
}


-(void)actMessage{
    [self hideZLMessageBtnAndSetingBtn];
    MLMessagesViewController *vc = [[MLMessagesViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
   
}
//设置
- (void)actSettingAction{
    [self hideZLMessageBtnAndSetingBtn];
    APPSettingViewController *vc = [[APPSettingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

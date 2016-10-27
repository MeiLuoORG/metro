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
#import "MLServiceViewController.h"

#import "MLSureViewController.h"

#import "MLVersionViewController.h"
#import "UIColor+HeinQi.h"

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
    NSString * _youHuiQuanCount;
    NSString * _youHuiQuanYuE;
    NSMutableArray * _youHuiQuanMuARR;
    NSDictionary * _orderStatusNumDic;
    
    JSBadgeView * _daiFubadgeView;
    JSBadgeView * _daiShoubadgeView;
    JSBadgeView * _daiPingbadgeView;
    //JSBadgeView * _tuiHuobadgeView;
    //JSBadgeView * _allOrderbadgeView;
    UIButton * _dianWOButton;
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLPersonHeadView *headView;
@property (strong, nonatomic) SecondBtnsView * secondBtnsView;

@end

@implementation MLPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    _youHuiQuanMuARR = [[NSMutableArray alloc]init];
     self.navigationItem.title = @"个人中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#260E00"]}];
    self.navigationItem.leftBarButtonItem = nil;

    //加载背景图
    _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-64-49)];
    _backgroundScrollView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    
    [self.view addSubview:_backgroundScrollView];
    

    _messageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _messageButton.frame = CGRectMake(0, 0, 22, 22);
    [_messageButton setBackgroundImage:[UIImage imageNamed:@"xiaoxizhoulu"] forState:UIControlStateNormal];
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
    [_settingButton setBackgroundImage:[UIImage imageNamed:@"shezhizhoulu"] forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(actSettingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithCustomView:_settingButton];
    
    self.navigationItem.rightBarButtonItems = @[message,l,setting];
    _headView = ({
        MLPersonHeadView *headView =[MLPersonHeadView personHeadView];
        headView.biaoZhiImageView.hidden = YES;
        __weak typeof(self)weakself = self;
        headView.loginBlock = ^(){
            [self hideZLMessageBtnAndSetingBtn];
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = YES;
            [weakself presentViewController:vc animated:YES completion:nil];
            
        };
        headView.regBlock = ^(){
            [self hideZLMessageBtnAndSetingBtn];
            MLLoginViewController *vc = [[MLLoginViewController alloc]init];
            vc.isLogin = NO;
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
    
    [self loadSecondButtonsView];
    [self loadThirdButtonsView];
    [self loadFourButtonsView];
    [self ctreateYOUHUIQuanView];
    
    //李佳接口认证成功后  接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(renZhengAction:) name:RENZHENG_LIJIA_Notification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actMessage) name:@"PushToMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToStoreCenter) name:@"PushToStore" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushToOrderCenter) name:@"PushToOrderCenter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMyZiChanAction) name:LingQuYouHuiQuan_NOTIFICATION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotificationAction:) name:LOGOUT_TUICHU_NOTIFICATION object:nil];
}

//退出登录通知
- (void)logoutNotificationAction:(id)sender{

    _xingYunXingValueLabel.text = @"0";
    _jiFenValueLabel.text = @"0";
    _youhuiValueLabel.text = @"0";
    _yuEValueLabel.text = @"0";

}

- (void)PushToOrderCenter{
    MLPersonOrderListViewController *vc = [[MLPersonOrderListViewController alloc]initWithOrderType:OrderType_Fukuan];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToStoreCenter{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * loginid = (NSString *)[userDefaults objectForKey:kUSERDEFAULT_USERID];
    if (loginid && ![loginid isEqualToString:@""]) {

        MLStoreCollectViewController *vc = [[MLStoreCollectViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else{
        MLLoginViewController * loginVC = [[MLLoginViewController alloc]init];
        loginVC.isLogin = YES;
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (void)renZhengAction:(id)sender{
    //查询实名认证
    [self chaXunISshiMingRenZheng];
    //请求我的资产
    [self getMyZiChanAction];
    //请求订单数目
    [self loadNum];
}

#pragma mark zhoulu 第二栏按钮组

-(void)loadNum{


    [MLHttpManager get:OrderNum_URLString params:nil m:@"shop" s:@"status" success:^(id responseObject) {
        NSLog(@"订单状态数目%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            
            NSDictionary * result = (NSDictionary *)responseObject;
            _orderStatusNumDic = [[NSDictionary alloc]init];
            _orderStatusNumDic = result[@"data"][@"count"];
            NSLog(@"orderStatusNumDic===%@",_orderStatusNumDic);
            
            //SecondBtnsView *headView =[SecondBtnsView personHeadView];
            
            //_daiFubadgeView = [[JSBadgeView alloc]initWithParentView:self.secondBtnsView.daiFuButton alignment:JSBadgeViewAlignmentTopRight];
            NSLog(@"%@",_orderStatusNumDic[@"dfh"]);
            
            NSString *dfh = _orderStatusNumDic[@"dfh"];
            if ([dfh isEqualToString:@"0"]) {
                _daiFubadgeView.hidden = YES;
            }
            else{
                _daiFubadgeView.hidden = NO;
                _daiFubadgeView.badgeText = dfh;
            }
            
    
           // _daiShoubadgeView = [[JSBadgeView alloc]initWithParentView:self.secondBtnsView.daiShouButton alignment:JSBadgeViewAlignmentTopRight];
            NSString *dsh = _orderStatusNumDic[@"dsh"];
            if ([dsh isEqualToString:@"0"]) {
                _daiShoubadgeView.hidden = YES;
            }
            else{
                _daiShoubadgeView.hidden = NO;
                _daiShoubadgeView.badgeText = dsh;
            
            }
            
            
            
            //_daiPingbadgeView = [[JSBadgeView alloc]initWithParentView:self.secondBtnsView.daiPingButton alignment:JSBadgeViewAlignmentTopRight];
            NSString *dpj = _orderStatusNumDic[@"dpj"];
            if ([dpj isEqualToString:@"0"]) {
                _daiPingbadgeView.hidden = YES;
            }
            else{
                _daiPingbadgeView.hidden = NO;
                _daiPingbadgeView.badgeText = dpj;
            }
            
            
            
           // _tuiHuobadgeView = [[JSBadgeView alloc]initWithParentView:self.secondBtnsView.tuiHuoButton alignment:JSBadgeViewAlignmentTopRight];
            NSString *th = _orderStatusNumDic[@"th"];
            if ([th isEqualToString:@"0"]) {
                //_tuiHuobadgeView.hidden = YES;
            }
            else{
                //_tuiHuobadgeView.hidden = NO;
                //_tuiHuobadgeView.badgeText = th;
            }
            
            
            
            //_allOrderbadgeView = [[JSBadgeView alloc]initWithParentView:self.secondBtnsView.allOrderButton alignment:JSBadgeViewAlignmentTopRight];
            NSString *all = _orderStatusNumDic[@"all"];
            if ([all isEqualToString:@"0"]) {
                //_allOrderbadgeView.hidden = YES;
            }
            else{
                //_allOrderbadgeView.hidden = NO;
                //_allOrderbadgeView.badgeText = all;
            }
            
        }else if ([responseObject[@"code"]isEqual:@1002]){
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self showError];
        }
        else{
            
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"请求订单数目错误：%@",error);
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
    }];


}

- (void)loadSecondButtonsView{

    
    self.secondBtnsView = ({
        SecondBtnsView *headView =[SecondBtnsView personHeadView];
        _daiFubadgeView = [[JSBadgeView alloc]initWithParentView:headView.daiFuButton alignment:JSBadgeViewAlignmentTopRight];
        //NSLog(@"%@",orderStatusNumDic[@"dfh"]);
        
       // NSString *dfh = orderStatusNumDic[@"dfh"];
        //_daiFubadgeView.badgeText = @"10";
        
        
        
        _daiShoubadgeView = [[JSBadgeView alloc]initWithParentView:headView.daiShouButton alignment:JSBadgeViewAlignmentTopRight];
//        NSString *dsh = _orderStatusNumDic[@"dsh"];
//        _daiShoubadgeView.badgeText = dsh;
        
        
        _daiPingbadgeView = [[JSBadgeView alloc]initWithParentView:headView.daiPingButton alignment:JSBadgeViewAlignmentTopRight];
//        NSString *dpj = _orderStatusNumDic[@"dpj"];
//        _daiPingbadgeView.badgeText = dpj;
        
        
        //_tuiHuobadgeView = [[JSBadgeView alloc]initWithParentView:headView.tuiHuoButton alignment:JSBadgeViewAlignmentTopRight];
//        NSString *th = _orderStatusNumDic[@"th"];
//        _tuiHuobadgeView.badgeText = th;
        
        
        //_allOrderbadgeView = [[JSBadgeView alloc]initWithParentView:headView.allOrderButton alignment:JSBadgeViewAlignmentTopRight];
//        NSString *all = _orderStatusNumDic[@"all"];
//        _allOrderbadgeView.badgeText = all;
        
        
         __weak typeof(self)weakself = self;
        headView.frame = CGRectMake(0, 110, SIZE_WIDTH, 67);
        /*
        headView.view2CenterX.constant = -((SIZE_WIDTH/2)-56)/2;
        headView.view4CenterX.constant = ((SIZE_WIDTH/2)-56)/2;
        */
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
    
    UILabel * labels = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 15)];
    labels.text = @"我的资产";
    labels.font = [UIFont systemFontOfSize:14.0f];
    labels.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    [_thirdButtonBackView addSubview:labels];
    
    UIView * spLiner = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SIZE_WIDTH, 1)];
    spLiner.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [_thirdButtonBackView addSubview:spLiner];
    

    
    _xingYunXingValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 58, 50, 18)];
    _xingYunXingValueLabel.text = @"0";
     _xingYunXingValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _xingYunXingValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _xingYunXingValueLabel.textAlignment = NSTextAlignmentCenter;
    _xingYunXingValueLabel.adjustsFontSizeToFitWidth = YES;
    _xingYunXingValueLabel.minimumScaleFactor = 0.5f;
    
    
    
     UILabel * xingYunLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 74, 50, 18)];
    xingYunLabel.text = @"美钻";
    xingYunLabel.font = [UIFont systemFontOfSize:11.0f];
    xingYunLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    xingYunLabel.textAlignment = NSTextAlignmentCenter;
    xingYunLabel.adjustsFontSizeToFitWidth = YES;
    xingYunLabel.minimumScaleFactor = 0.5f;

    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiaoZhuanHuiYuanKa)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiaoZhuanYouHuiQuan)];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiaoZhuanHuiYuanKa)];
    
    _jiFenValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3+94), 58, 50, 18)];
    _jiFenValueLabel.text = @"0";
    _jiFenValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _jiFenValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _jiFenValueLabel.textAlignment = NSTextAlignmentCenter;
    _jiFenValueLabel.adjustsFontSizeToFitWidth = YES;
    _jiFenValueLabel.minimumScaleFactor = 0.5f;
    _jiFenValueLabel.userInteractionEnabled = YES;
    [_jiFenValueLabel addGestureRecognizer:tap3];
    
    UILabel * jiFenLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3.0f+94), 74, 50, 18)];
    jiFenLabel.text = @"积分";
    jiFenLabel.font = [UIFont systemFontOfSize:11.0f];
    jiFenLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    jiFenLabel.textAlignment = NSTextAlignmentCenter;
    jiFenLabel.adjustsFontSizeToFitWidth = YES;
    jiFenLabel.minimumScaleFactor = 0.5f;
    jiFenLabel.userInteractionEnabled = YES;
    [jiFenLabel addGestureRecognizer:tap3];
    
    _youhuiValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3.0f*2.0f+144), 58, 50, 18)];
    _youhuiValueLabel.text = @"0";
    _youhuiValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _youhuiValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _youhuiValueLabel.textAlignment = NSTextAlignmentCenter;
    _youhuiValueLabel.adjustsFontSizeToFitWidth = YES;
    _youhuiValueLabel.minimumScaleFactor = 0.5f;
    _youhuiValueLabel.userInteractionEnabled = YES;
    [_youhuiValueLabel addGestureRecognizer:tap2];
    
    
    UILabel * youhuiLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SIZE_WIDTH-200-88)/3.0f*2.0f+144), 74, 50, 18)];
    youhuiLabel.text = @"优惠券";
    youhuiLabel.font = [UIFont systemFontOfSize:11.0f];
    youhuiLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    youhuiLabel.textAlignment = NSTextAlignmentCenter;
    youhuiLabel.adjustsFontSizeToFitWidth = YES;
    youhuiLabel.minimumScaleFactor = 0.5f;
    youhuiLabel.userInteractionEnabled = YES;
    [youhuiLabel addGestureRecognizer:tap2];
    
    _yuEValueLabel = [[UILabel alloc]initWithFrame:CGRectMake((SIZE_WIDTH-44-50), 58, 50, 18)];
    _yuEValueLabel.text = @"0";
    _yuEValueLabel.font = [UIFont systemFontOfSize:11.0f];
    _yuEValueLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    _yuEValueLabel.textAlignment = NSTextAlignmentCenter;
    _yuEValueLabel.adjustsFontSizeToFitWidth = YES;
    _yuEValueLabel.minimumScaleFactor = 0.5f;
    _yuEValueLabel.userInteractionEnabled = YES;
    [_yuEValueLabel addGestureRecognizer:tap1];
    
    
    UILabel * yuElabel = [[UILabel alloc]initWithFrame:CGRectMake((SIZE_WIDTH-44-50), 74, 50, 18)];
    yuElabel.text = @"余额";
    yuElabel.font = [UIFont systemFontOfSize:11.0f];
    yuElabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    yuElabel.textAlignment = NSTextAlignmentCenter;
    yuElabel.adjustsFontSizeToFitWidth = YES;
    yuElabel.minimumScaleFactor = 0.5f;
    yuElabel.userInteractionEnabled = YES;
    [yuElabel addGestureRecognizer:tap1];
    
    [_thirdButtonBackView addSubview:xingYunLabel];
    [_thirdButtonBackView addSubview:_xingYunXingValueLabel];
    [_thirdButtonBackView addSubview:jiFenLabel];
    [_thirdButtonBackView addSubview:_jiFenValueLabel];
    [_thirdButtonBackView addSubview:youhuiLabel];
    [_thirdButtonBackView addSubview:_youhuiValueLabel];
    [_thirdButtonBackView addSubview:yuElabel];
    [_thirdButtonBackView addSubview:_yuEValueLabel];
    
    [self createDianWoButton];
}

- (void)createDianWoButton{
    _dianWOButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dianWOButton setFrame:CGRectMake(0, (310.0f/750.0f)*SIZE_WIDTH-(100.0f/750.0f)*SIZE_WIDTH, SIZE_WIDTH, (100.0f/750.0f)*SIZE_WIDTH)];
    [_dianWOButton setBackgroundImage:[UIImage imageNamed:@"bannarzl"] forState:UIControlStateNormal];
    //[dianWOButton setTitle:@"领取优惠券，请戳这里" forState:UIControlStateNormal];
    //[_dianWOButton setBackgroundColor:[UIColor blueColor]];
    [_dianWOButton addTarget:self action:@selector(bannarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_thirdButtonBackView addSubview:_dianWOButton];
    
    _thirderHeight = 182.0f+(310.0f/750.0f)*SIZE_WIDTH;

}


#pragma mark 我的资产
- (void)getMyZiChanAction{

    NSString * userPhone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERPHONE];
    if (userPhone && userPhone != nil && ![userPhone isEqualToString:@""]) {
        NSDictionary * ret = @{@"mobile":[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERPHONE]};
        
        NSString * cardNO = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERCARDNO];
        NSLog(@"请求我的资产的默认卡号为：%@",cardNO);
        if (cardNO && ![cardNO isEqualToString:@""]) {
            
            NSString  * accessTokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
            NSString * urlStr = [NSString stringWithFormat:@"%@&card=%@",ZiChan_URLString,cardNO];
            
            [MLHttpManager post:urlStr params:ret m:@"member" s:@"assets" success:^(id responseObject) {
                NSLog(@"请求我的资产的结果：%@",responseObject);
                if ([responseObject[@"code"]isEqual:@0]) {
                    NSDictionary * dataDic = responseObject[@"data"];
                    
                    //identity_list
                    NSDictionary * assets_dataDic = dataDic[@"assets_data"];
                    
                    if (assets_dataDic[@"xyx_num"] && ![assets_dataDic[@"xyx_num"] isEqualToString:@""]) {
                        NSString * xyx_numStr = assets_dataDic[@"xyx_num"];
                        _xingYunXingValueLabel.text = xyx_numStr;
                    }
                    else{
                        _xingYunXingValueLabel.text = @"0";
                    }
                    if (assets_dataDic[@"ye_num"]&& ![assets_dataDic[@"ye_num"] isEqualToString:@""]) {
                        NSString * yEStr = assets_dataDic[@"ye_num"];
                        _yuEValueLabel.text = yEStr;
                    }
                    else{
                        _yuEValueLabel.text = @"0";
                    }
                    if (assets_dataDic[@"jifen_num"]&&![assets_dataDic[@"jifen_num"] isEqualToString:@""]) {
                        NSString * jiFenStr = assets_dataDic[@"jifen_num"];
                        _jiFenValueLabel.text = jiFenStr;
                    }
                    else{
                        _jiFenValueLabel.text =@"0";
                    }
                    if (assets_dataDic[@"yhq_num"]&&![assets_dataDic[@"yhq_num"] isEqualToString:@""]) {
                        NSString * yhqStr = assets_dataDic[@"yhq_num"];
                        _youhuiValueLabel.text = yhqStr;
                    }
                    else{
                        _youhuiValueLabel.text = @"0";
                    }
                }else if ([responseObject[@"code"]isEqual:@1002]){
                    [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
                    [self showError];
                }
                
                
            } failure:^(NSError *error) {
                
                NSLog(@"请求我的资产失败：%@",error);
            }];
            
        }

    }
   
}



#pragma mark 第三组按钮跳转

- (void)tiaoZhuanHuiYuanKa{
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

- (void)tiaoZhuanYouHuiQuan{
    if (!loginid) {
        [self showError];
        return;
    }
    
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    NSString * str = [userdefault objectForKey:kUSERDEFAULT_USERCARDNO];
    if(![str isEqualToString:@""] && str ) {
        QuanListZLViewController *VC = [[QuanListZLViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        /*
        if (_youHuiQuanMuARR.count > 0) {
            VC.quanListARR  = nil;
            VC.quanListARR = _youHuiQuanMuARR;
        }
         */
        [self presentViewController:VC animated:YES completion:nil];
        //[memberVC loadData];
        //[self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma end mark


//领取优惠券视图
- (void)ctreateYOUHUIQuanView{

     __weak typeof (self) weakSelf = self;
    self.lingQuQuanView = [[LingQuYouHuiQuanView alloc]initWithFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
    self.lingQuQuanView.quanARR = [[NSMutableArray alloc]init];
    [self.lingQuQuanView createView];
    [self.lingQuQuanView setHideBlockAction:^(BOOL success) {
        //查询 用户已经领取的优惠券
        //[weakSelf chaXunYiLingQuQuanList];
        
        [weakSelf.tabBarController.tabBar setHidden:NO];
        [UIView animateWithDuration:0.4f animations:^{
            weakSelf.lingQuQuanView.frame = CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT);
        } completion:^(BOOL finished) {
            [weakSelf.lingQuQuanView.quanARR removeAllObjects];
        }];
        
    }];
    [self.lingQuQuanView selectQuanBlockAction:^(BOOL success, YouHuiQuanModel *ret) {
        if (ret) {
            [self getMyZiChanAction];
        }
    }];
    
    [self.view addSubview:self.lingQuQuanView];
    

}

- (void)bannarButtonAction:(UIButton *)sender{
    
    
    //self.navigationController.toolbar.hidden = YES;
     //self.hidesBottomBarWhenPushed = YES;

       // __weak typeof (self) weakSelf = self;
    sender.enabled = NO;
    [self qignQiuYouHuiQuan];
    
        NSLog(@"执行了加载了优惠圈视图");
    
}


#pragma mark  请求优惠券
- (void)qignQiuYouHuiQuan{

    
    
    [MLHttpManager get:LingQuYouHuiQuan_URLString params:nil m:@"member" s:@"admin_coupons" success:^(id responseObject) {
        NSLog(@"请求优惠券信息：%@",responseObject);
        _dianWOButton.enabled = YES;
        NSDictionary * result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary * dataDic = result[@"data"];
            
            if ([dataDic[@"b2c_coupons"] isKindOfClass:[NSArray class]]) {
                
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
                    [UIView animateWithDuration:0.4f animations:^{
                        self.lingQuQuanView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT);
                        
                    } completion:^(BOOL finished) {
                        [self.tabBarController.tabBar setHidden:YES];
                    }];
                    
                }
                [self.lingQuQuanView.tablieview reloadData];
                if (self.lingQuQuanView.quanARR.count == 0) {
                    _hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:_hud];
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"没有可以领取的优惠券";
                    [_hud hide:YES afterDelay:1];
                }
            }
        }else if ([responseObject[@"code"]isEqual:@1002]){
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self showError];
        }
        else{
        }
    } failure:^(NSError *error) {
        _dianWOButton.enabled = YES;
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
    }];
}
#pragma mark 查询已经领取的优惠券
- (void)chaXunYiLingQuQuanList{
//m=member&s=admin_coupons
    [MLHttpManager get:YOUHUIQUANLIST_YiLingQu_URLString params:nil m:@"member" s:@"admin_coupons" success:^(id responseObject) {
        _youHuiQuanMuARR = [[NSMutableArray alloc]init];
        NSLog(@"请求用户已领取的优惠券：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        if ([result[@"code"]isEqual:@0]) {
            NSDictionary * dataDic = result[@"data"];
            NSArray * allCouponsARR = dataDic[@"b2c_allcoupons"];
            if (allCouponsARR) {
                _youHuiQuanCount = [NSString stringWithFormat:@"%ld",allCouponsARR.count];
            }
            else{
                
                _youHuiQuanCount = @"0";
            }
            int yuE = 0;
            if (allCouponsARR.count > 0) {
                
                for (NSDictionary * dic in allCouponsARR) {
                    YouHuiQuanModel * model = [[YouHuiQuanModel alloc]init];
                    model.balance = [dic[@"Balance"] intValue];
                    model.mingChengStr = dic[@"CouponTypeName"];
                    model.endTime = dic[@"ValidDate"];
                    model.quanID = dic[@"CouponType"];
                    [_youHuiQuanMuARR addObject:model];
                    yuE = yuE + model.balance;
                }
                
            }
            _youHuiQuanYuE = [NSString stringWithFormat:@"%d",yuE];
            _yuEValueLabel.text = _youHuiQuanYuE;
            _youhuiValueLabel.text = _youHuiQuanCount;
        }else if ([responseObject[@"code"]isEqual:@1002]){
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self showError];
        }
       
        
        
    } failure:^(NSError *error) {
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
    }];
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
                imageview.image = [UIImage imageNamed:@"shangpinlu"];
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
                imageview.image = [UIImage imageNamed:@"dianpuzhou"];
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
                imageview.image = [UIImage imageNamed:@"huiyuankazhou"];
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
                imageview.image = [UIImage imageNamed:@"kefulu"];
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
                imageview.image = [UIImage imageNamed:@"zujilu"];
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
                imageview.image = [UIImage imageNamed:@"shimingrenzhegnzhou"];
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
        
        MLServiceViewController *vc = [[MLServiceViewController alloc]init];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];

        
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
            NSLog(@"是否认证：%d",_isRenZheng);
            shiMingVC.isRenZheng = _isRenZheng;
            if (_isRenZheng == YES) {
                shiMingVC.pay_id = _pay_id;
                shiMingVC.userPhone = _pay_mobile;
                shiMingVC.userName = _real_name;
                shiMingVC.userShenFenCardID = _identity_card;
                shiMingVC.shenFenImageURLStr = _identity_picurl;
                 NSLog(@"姓名为：%@,身份证号为：%@,图片地址：%@",shiMingVC.userName,shiMingVC.userShenFenCardID,shiMingVC.shenFenImageURLStr);
            }
            else{
                shiMingVC.pay_id = _pay_id;
                shiMingVC.userPhone = _pay_mobile;
                shiMingVC.userName = _real_name;
                shiMingVC.userShenFenCardID = _identity_card;
                shiMingVC.shenFenImageURLStr = _identity_picurl;
                NSLog(@"姓名为：%@,身份证号为：%@,图片地址：%@",shiMingVC.userName,shiMingVC.userShenFenCardID,shiMingVC.shenFenImageURLStr);
            }
            
            [self.navigationController pushViewController:shiMingVC animated:YES];
        }

    }

}


#pragma mark 查询实名认证
- (void)chaXunISshiMingRenZheng{
    
    NSString * userPhone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERPHONE];
    if (userPhone != nil && ![userPhone isEqualToString:@""] && userPhone) {
        NSDictionary * ret = @{@"pay_mobile":userPhone};
        
        [MLHttpManager post:CHAXUNRENZHENG_RENZHENG_URLStrign params:ret m:@"member" s:@"admin_member" success:^(id responseObject) {
            NSLog(@"查询实名认证：%@",responseObject);
            
            NSDictionary * result = (NSDictionary *)responseObject;
            if ([result[@"code"] isEqual:@0]) {
                
                NSDictionary * dataDic = responseObject[@"data"];
                //identity_list
                NSDictionary * identity_listDic = dataDic[@"identity_list"];
                NSString * trueStr = identity_listDic[@"identity_verify"];
                if ([trueStr isEqualToString:@"true"]) {
                    _iS_identity_verify = YES;
                }
                else{
                    _iS_identity_verify = NO;
                }
                
                if (_iS_identity_verify == YES) {
                    _headView.renZhengLabel.text = @"已认证";
                    _isRenZheng = YES;
                    _headView.biaoZhiImageView.hidden = NO;
                    _pay_id = identity_listDic[@"pay_id"];
                    _pay_mobile = identity_listDic[@"pay_mobile"];
                    _real_name = identity_listDic[@"real_name"];
                    _identity_card = identity_listDic[@"identity_card"];
                    if (![identity_listDic[@"identity_pic"] isEqual:[NSNull null]] && ![identity_listDic[@"identity_pic"] isKindOfClass:[NSNull class]]) {
                        _identity_picurl = identity_listDic[@"identity_pic"];
                    }
                }
                else{
                    _isRenZheng = NO;
                    _headView.biaoZhiImageView.hidden = YES;
                    _headView.renZhengLabel.text = @"";
                    
                    if (![identity_listDic[@"pay_id"] isEqual:[NSNull null]] && ![identity_listDic[@"pay_id"] isKindOfClass:[NSNull class]]) {
                        _pay_id = identity_listDic[@"pay_id"];
                    }
                    if (![identity_listDic[@"pay_mobile"]isEqual:[NSNull null]] && ![identity_listDic[@"pay_mobile"]isKindOfClass:[NSNull class]]) {
                        _pay_mobile = identity_listDic[@"pay_mobile"];
                    }
                    if (![identity_listDic[@"real_name"] isEqual:[NSNull null]] && ![identity_listDic[@"real_name"] isKindOfClass:[NSNull class]]) {
                        _real_name = identity_listDic[@"real_name"];
                    }
                    if (![identity_listDic[@"identity_card"] isEqual:[NSNull null]] && ![identity_listDic[@"identity_card"] isKindOfClass:[NSNull class]]) {
                        _identity_card = identity_listDic[@"identity_card"];
                    }
                    if (![identity_listDic[@"identity_pic"] isEqual:[NSNull null]] && ![identity_listDic[@"identity_pic"] isKindOfClass:[NSNull class]]) {
                        _identity_picurl = identity_listDic[@"identity_pic"];
                    }
                    
                }
                
                _isRenZhengQequestSuc = YES;
            }else if ([responseObject[@"code"]isEqual:@1002]){
                [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
                [self showError];
            }
            else{
                _pay_id = @"";
                _pay_mobile = @"";
                _real_name = @"";
                _identity_card = @"";
                _identity_picurl = @"";
            }
            
        } failure:^(NSError *error) {
            _pay_id = @"";
            _pay_mobile = @"";
            _real_name = @"";
            _identity_card = @"";
            _identity_picurl = @"";
            _headView.biaoZhiImageView.hidden = YES;
            _headView.renZhengLabel.text = @"";
            _isRenZhengQequestSuc = NO;
            NSLog(@"查询实名认证失败：%@",error);
            
            
        }];

    }
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
    
    [self.tabBarController.tabBar setHidden:NO];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //消息
    NSString * message_num = [userDefaults objectForKey:Message_badge_num];
    if ([message_num isEqualToString:@"1"]) {
        _messageBadgeView.badgeText = @"●";
    }
    else{
    
        _messageBadgeView.hidden = YES;
    }
    
    
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
        
        //请求我的资产
        [self getMyZiChanAction];
        [self loadNum];
        
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
        
        _daiFubadgeView.hidden  = YES;
        _daiShoubadgeView.hidden = YES;
        _daiPingbadgeView.hidden = YES;
        //_tuiHuobadgeView.hidden = YES;
        //_allOrderbadgeView.hidden =YES;
        
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
    

    
    
    if ([avatorurl hasSuffix:@"webp"]) {
        [self.headView.headBtn setZLWebPButton_ImageWithURLStr:avatorurl withPlaceHolderImage:PLACEHOLDER_IMAGE];
    } else {
        [self.headView.headBtn sd_setImageWithURL:[NSURL URLWithString:avatorurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
    }
    self.headView.biaoZhiImageView.hidden = YES;
    [self showZLMessageBtnAndSettingBtn];
    
    if ([userDefaults objectForKey:kUSERDEFAULT_USERPHONE]) {
        //查询实名认证
        [self chaXunISshiMingRenZheng];
        //查询 用户已经领取的优惠券
        //[self chaXunYiLingQuQuanList];
    }
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

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    if (loginid && ![@"" isEqualToString:loginid]) {
        
        _messageBadgeView.hidden = YES;
        [userDefaults setObject:@"0" forKey:Message_badge_num];
        MLMessagesViewController *vc = [[MLMessagesViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else{
        MLLoginViewController * loginVC = [[MLLoginViewController alloc]init];
        loginVC.isLogin = YES;
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }
    
   
}
//设置
- (void)actSettingAction{
    [self hideZLMessageBtnAndSetingBtn];
    APPSettingViewController *vc = [[APPSettingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

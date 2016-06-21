//
//  MLLoginViewController.m
//  Matro
//
//  Created by NN on 16/3/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLLoginViewController.h"
#import "UIColor+HeinQi.h"
#import "UIButton+HeinQi.h"
#import "UIView+HeinQi.h"

#import "MLVIPCardViewController.h"
#import "MLLoginTableViewCell.h"
#import "LoginHistory.h"

#import "HFSConstants.h"
#import "HFSUtility.h"
#import "HFSServiceClient.h"
#import <MagicalRecord/MagicalRecord.h>
#import "WXApi.h"
#import "UMSocial.h"
#import "MLTermViewController.h"
#import "MLBindPhoneController.h"
#import "MNNModifyPasswordViewController.h"
#import "YMNavigationController.h"

#define CODE_TIME_KEY @"CODE_TIME_KEY"



@interface MLLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSInteger _endTime;
    NSManagedObjectContext *_context;
    NSMutableArray *_accountArray;
    
    BOOL _isReadDelegate;
    NavTopCommonImage * _navTopCommoImages;
    UIButton * _rightBtn;
    
    NSString * _currentCardNOs;
    NSString * _currentCardTypeNames;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *showpasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *showmoreaccoutButton;

@property (strong, nonatomic) IBOutlet UIButton *registerTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *loginTypeButton;

@property (strong, nonatomic) IBOutlet UIView *registerTypeBgView;
@property (strong, nonatomic) IBOutlet UIView *loginTypeBgView;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

//页面没有textField的属性 通过 - (UITextField *)textField:(UIView *)view获取相应textField
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIView *accountView;
@property (strong, nonatomic) IBOutlet UIView *rphoneView;
@property (strong, nonatomic) IBOutlet UIView *rcodeView;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIView *rpasswordView;
@property (strong, nonatomic) IBOutlet UIView *rrpasswordView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@property (strong, nonatomic) IBOutlet UIView *qqLoginBgView;
@property (strong, nonatomic) IBOutlet UIView *wxLoginBgView;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginButton;


@end

@implementation MLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isReadDelegate = YES;
    self.vipCardArray = [[NSMutableArray alloc]init];
    [self loginVCUI];
    
//    _accountArray = [[NSMutableArray alloc]initWithArray:@[@"13218102399",@"13218102388"]];
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _context = [NSManagedObjectContext MR_defaultContext];
    
    //宋凯测试账号
//    [self textField:_accountView].text = @"18550396196";
//    [self textField:_passwordView].text =@"123123";
    [self.termBtn setSelected:YES];
    [self.termBtn addTarget:self action:@selector(termSel:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bindSuccess) name:kNOTIFICATIONBINDSUC object:nil];
    
    self.registerButton.enabled = NO;
    //获取验证码按钮
    //self.codeButton.enabled = NO;
    //[self.codeButton loginButtonType];
    
    
    //设置边框颜色
    [self setViewLayerBorderColor];
    
    //弹出视图
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    
    
}


- (void)setViewLayerBorderColor{
    /*zhoulu 20160613*//*
                        //1.边框
                        _currentIntLabel.layer.cornerRadius = CGRectGetHeight(_currentIntLabel.bounds)/2;
                        _currentIntLabel.layer.masksToBounds = YES;//设置边框可见
                        _currentIntLabel.layer.borderWidth = 1.0f;
                        _currentIntLabel.layer.borderColor = customColor.CGColor;
                        */
    
    UIColor * grayColors = [HFSUtility hexStringToColor:@"cccccc"];
    _passwordView.layer.borderColor = grayColors.CGColor;
    _passwordView.layer.cornerRadius = 4.0f;


    _rrpasswordView.layer.borderColor = grayColors.CGColor;
    _rrpasswordView.layer.cornerRadius = 4.0f;
    
    _rpasswordView.layer.borderColor = grayColors.CGColor;
    _rpasswordView.layer.cornerRadius = 4.0f;
    
    _accountView.layer.borderColor = grayColors.CGColor;
    _accountView.layer.cornerRadius = 4.0f;
    
    
    _rphoneView.layer.borderColor = grayColors.CGColor;
    _rphoneView.layer.cornerRadius = 4.0f;
    
    _rcodeView.layer.borderColor = grayColors.CGColor;
    _rcodeView.layer.cornerRadius = 4.0f;
    
    //[_codeButton setBackgroundColor:[HFSUtility hexStringToColor:@"b9b6b6"]];
    _codeButton.enabled = NO;
    _codeButton.layer.cornerRadius = 4.0f;
    
    self.registerButton.layer.cornerRadius = 4.0f;
    self.loginButton.layer.cornerRadius = 4.0f;
}

- (void)bindSuccess{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)termSel:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    if (!btn.selected) {
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = [UIColor colorWithHexString:Main_grayBackgroundColor];
        _isReadDelegate = NO;
    }
    else
    {
        _isReadDelegate = YES;
        if ([self checkRegisterButtonEnabledYESorNO]) {
             self.registerButton.enabled = YES;
            self.registerButton.backgroundColor = [UIColor colorWithHexString:Main_BackgroundColor];
        }
        else {
            self.registerButton.enabled = NO;
            self.registerButton.backgroundColor = [UIColor colorWithHexString:Main_grayBackgroundColor];
        }
       
    }
    
}

//检测按钮是否可以  用

- (BOOL)checkRegisterButtonEnabledYESorNO{
    BOOL isYes;
    UITextField * phoneText = [self textField:self.rphoneView];
    UITextField * codeText  = [self textField:self.rcodeView];
    UITextField * passText = [self textField:self.rpasswordView];
    UITextField * rePassText = [self textField:self.rrpasswordView];
    //NSLog(@"phoneText:%@,codeText:%@,passText:%@,rePassText:%@",phoneText.text,codeText.text,passText.text,rePassText.text);
    if ([phoneText.text isEqualToString:@""] || [codeText.text isEqualToString:@""] || [passText.text isEqualToString:@""] || [rePassText.text isEqualToString:@""]) {
        isYes = NO;
    }
    else{
        isYes = YES;
    }
    return isYes;
}

- (void)loginVCUI{
    //    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
//    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    /*
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    */
    
    [_registerTypeButton selButtonType];
    [_loginTypeButton selButtonType];
    
    _loginTypeButton.selected = _isLogin;
    _loginTypeBgView.hidden = !_isLogin;
    
    _registerTypeButton.selected = !_isLogin;
    _registerTypeBgView.hidden = _isLogin;
    
    [_accountView loginType];
    [_passwordView loginType];
    [_rphoneView loginType];
    [_rcodeView loginType];
    [_codeButton loginButtonType];
    [_rpasswordView loginType];
    [_rrpasswordView loginType];
    
    [_loginButton loginButtonType];
    [_registerButton loginButtonType];
    
    [_showmoreaccoutButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan"] forState:UIControlStateNormal];
    [_showpasswordButton setImage:[UIImage imageNamed:@"Eye"] forState:UIControlStateNormal];
    
    [_showmoreaccoutButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan2"] forState:UIControlStateSelected];
    [_showpasswordButton setImage:[UIImage imageNamed:@"Eye2"] forState:UIControlStateSelected];
    
    _tableView.layer.borderWidth = 1.0f;
    _tableView.layer.borderColor = [UIColor colorWithHexString:Main_bianGrayBackgroundColor].CGColor;
    _tableView.layer.cornerRadius = 4.0f;
    
    //不支持QQ
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        _qqLoginBgView.hidden = YES;
        _qqLoginButton.hidden = YES;
        //NSLog(@"不支持QQ");
    }
    
    //不支持微信
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        _wxLoginBgView.hidden = YES;
        //NSLog(@"不支持微信");
    }
    
    //加载头部
    [self setTopTltle];
}

//设置 头部标题 和按钮
- (void)setTopTltle{

    if (_isLogin) {
        _navTopCommoImages = [[NavTopCommonImage alloc]initWithTitle:@"登录"];
        [_navTopCommoImages loadLeftBackButtonwith:0];
        [_navTopCommoImages backButtonAction:^(BOOL succes) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self.view addSubview:_navTopCommoImages];
        
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightBtn setTitle:@"快速注册" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_rightBtn setFrame:CGRectMake(SIZE_WIDTH-80, 34, 60, 22)];
        [_rightBtn setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(quicklyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navTopCommoImages addSubview:_rightBtn];
        
        
        //self.thirdLoginViewTopC.constant = 100.0f;
    }
    else{
        
        _navTopCommoImages = [[NavTopCommonImage alloc]initWithTitle:@"注册"];
        [_navTopCommoImages loadLeftBackButtonwith:0];
        [_navTopCommoImages backButtonAction:^(BOOL succes) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self.view addSubview:_navTopCommoImages];
        
        //self.thirdLoginViewTopC.constant = 210.0f;
    }
    
    //_loginTypeBgView.hidden = YES;
    //_registerTypeBgView.hidden = NO;

}

- (void)quicklyBtnAction:(UIButton *)sender{

    NSLog(@"点击了快速注册");
    _loginTypeBgView.hidden = YES;
    _registerTypeBgView.hidden = NO;
    _navTopCommoImages.tittleLabel.text = @"注册";
    if (_rightBtn) {
        _rightBtn.hidden = YES;
    }
    //self.thirdLoginViewTopC.constant = 210.0f;
    
}

- (IBAction)goTerm:(id)sender {
    MLTermViewController *vc = [MLTermViewController new];
    [self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //历史
    [self loadLoginHistory];
    YMNavigationController *nav = (YMNavigationController *)self.navigationController;
    
    [nav hiddenNavBar];
    
//    //修改导航栏
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        //if iOS 5.0 and later
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forBarMetrics:UIBarMetricsDefault];
//    }
//    else
//    {
//        UIImageView *imageView = (UIImageView *)[self.navigationController.navigationBar  viewWithTag:10];
//        [imageView setBackgroundColor:[UIColor clearColor]];
//        if (imageView == nil)
//        {
//            imageView = [[UIImageView alloc] initWithImage:
//                         [UIImage imageNamed:@"TM.jpg"]];
//            [imageView setTag:10];
//            [self.navigationController.navigationBar  insertSubview:imageView atIndex:0];
//        }
//    }
//    
//    [self.navigationController.navigationBar setTranslucent:YES];
//    
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
//    {
//        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    }
//    
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //设置是否可以登录
    if ([[self textField:_accountView].text isEqualToString:@""] || [[self textField:_passwordView].text isEqualToString:@""]) {
        _loginButton.enabled = NO;
        /*
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.layer.borderWidth = 1.0f;
        _loginButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
         */
        [_loginButton setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
        
    }
    //设置是否可以注册
    if (!_isReadDelegate || ![self checkRegisterButtonEnabledYESorNO]) {
        
        _registerButton.enabled = NO;
        [_registerButton setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
    }
    
    

    
    if ([HFSUtility validateMobile:[self textField:_rphoneView].text]) {
        //短信倒计时
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
        if (timeSp) {
            _endTime = 60 - ([timeSp integerValue] - [tempTime integerValue]);
        }
        NSLog(@"tempTime值为：%@,_endTime的值为：%ld",tempTime,_endTime);
        if (!tempTime ||  _endTime> 60) {
            
            _codeButton.enabled = YES;
            
            _endTime = 0;
        }else{
            _codeButton.enabled = NO;
        }
        
        [self codeTimeCountdown];
    }
    else{
        _codeButton.enabled = NO;
        [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    YMNavigationController *nav = (YMNavigationController *)self.navigationController;
    [nav showNavBar];
}
-(void)loadLoginHistory{
    NSArray *historyLoginArray = [LoginHistory MR_findAllInContext:_context];
    _accountArray = [NSMutableArray array];
    for (LoginHistory *loginhHistory in historyLoginArray) {
        
        [_accountArray addObject:loginhHistory.loginkeyword];
        
    }
    [_tableView reloadData];
    _tableViewH.constant = _accountArray.count > 3 ? 3 * 30 : _accountArray.count * 30;
}

//倒计时
-(void)codeTimeCountdown{
    __block NSInteger timeout=_endTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _codeButton.enabled=YES;
                [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                /*
                [_codeButton setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                _codeButton.backgroundColor = [UIColor clearColor];
                _codeButton.layer.borderWidth = 1.0f;
                _codeButton.layer.borderColor = [UIColor clearColor].CGColor;
                 */
                [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_BackgroundColor]];
            });
        }else{
            int seconds;
            if (timeout==60) {
                seconds=60;
            }else{
                seconds = timeout % 60;
            }
            
            NSString *strTime = [NSString stringWithFormat:@"(%.2d)重新发送",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _codeButton.enabled=NO;
                [_codeButton setTitle:strTime forState:UIControlStateNormal];
                
                [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_grayBackgroundColor]];
                //_codeButton setbac
                /*
                [_codeButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
                _codeButton.backgroundColor = [UIColor clearColor];
                _codeButton.layer.borderWidth = 1.0f;
                _codeButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
                */
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//找回密码
#pragma mark 忘记密码
- (IBAction)findPassClick:(id)sender {
    MNNModifyPasswordViewController *vc = [[MNNModifyPasswordViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
}


//注册还是登录按钮
- (IBAction)typeButtonAction:(id)sender {
    UIButton * button = (UIButton *)sender;
    if (button.selected) {
        return;
    }
    button.selected = YES;
    if ([button isEqual:_registerTypeButton]) {
        _loginTypeButton.selected = NO;
        _loginTypeBgView.hidden = YES;
        _registerTypeBgView.hidden = NO;
    }else{
        _registerTypeButton.selected = NO;
        _registerTypeBgView.hidden = YES;
        _loginTypeBgView.hidden = NO;
    }
}

#pragma mark- 文本框相关

//当前view的输入框
- (UITextField *)textField:(UIView *)view{
    
    UITextField *textfield = nil;
    
    for (id tf in view.subviews) {
        if ([tf isKindOfClass:[UITextField class]]) {
            textfield = (UITextField *)tf;
            break;
        }
    }
    return textfield;
}

//当前的view的清除按钮
- (UIButton *)closeButton:(UITextField *)tf{
    UIButton * button = nil;
    
    for (id bt in tf.superview.subviews) {
        if ([bt isKindOfClass:[UIButton class]] && ((UIButton *)bt).tag == 99) {
            button =((UIButton *)bt);
            break;
        }
    }
    
    return button;
}

- (void)dimissViewControllerAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)toolButtonAction:(id)sender {
    
    UIButton *button = ((UIButton *)sender);
    button.selected = !button.selected;
    
    if ([button isEqual:_showpasswordButton]) {
        if (button.selected) {
            NSLog(@"显示密码");
            [self textField:button.superview].secureTextEntry = NO;
        }else{
            NSLog(@"不显示密码");
            [self textField:button.superview].secureTextEntry = YES;
        }
    }else if([button isEqual:_showmoreaccoutButton]){
        if (button.selected) {
            NSLog(@"展开");
            _tableView.hidden = NO;
        }else{
            NSLog(@"收回");
            _tableView.hidden = YES;
            [[self textField:_accountView] resignFirstResponder];
        }
    }
    
}

//清空文本框的X
- (IBAction)closeButtonAction:(id)sender {
    UIView *view = ((UIButton *)sender).superview;
    [self textField:view].text = @"";
    ((UIButton *)sender).hidden = YES;
}

#pragma mark- 注册
//注册按钮
- (IBAction)registerButton:(id)sender {
    
    //测试 选中 会员卡
    //[self loadSettingMoCardView];
    
    if ([self canRegister]) {
        //验证验证码有效性
        
     //[self checkSms];
        
        [self registerAction];
    }
    
}
//测试选中会员
- (void)loadSettingMoCardView{
    [self loadSettingMoCardViewWithCardARR:nil withPhone:nil withCardNo:nil withAccessToken:nil];

}

-(void)registerAction{
    
    __weak __typeof(&*self)weakSelf =self;
    /*
     NSDictionary *dic = @{@"appId":APP_ID,
     @"nonceStr":NONCE_STR,
     @"mphone":[self textField:_rphoneView].text,
     @"vcode":[self textField:_rcodeView].text,
     @"pwd":[self textField:_rpasswordView].text,
     };
     
     
     NSData *data = [HFSUtility RSADicToData:dic] ;
     NSString *ret = base64_encode_data(data);
     [[HFSServiceClient sharedClient]POST:@"vip/RegisterUserInfo" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     NSDictionary *result = (NSDictionary *)responseObject;
     NSLog(@"result %@",result);
     if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
     [_hud show:YES];
     _hud.mode = MBProgressHUDModeText;
     _hud.labelText = @"注册成功";
     [_hud hide:YES afterDelay:2];
     
     [weakSelf textField:_rrpasswordView].text = @"";
     [weakSelf textField:_rphoneView].text = @"";
     [weakSelf textField:_rcodeView].text = @"";
     [weakSelf textField:_rpasswordView].text = @"";
     
     _loginTypeButton.selected = YES;
     _loginTypeBgView.hidden = NO;
     _registerTypeBgView.hidden = YES;
     _registerTypeButton.selected = NO;
     NSLog(@"注册成功");
     
     }else{
     [_hud show:YES];
     _hud.mode = MBProgressHUDModeText;
     _hud.labelText = result[@"msg"];
     [_hud hide:YES afterDelay:2];
     NSLog(@"注册失败");
     }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [_hud show:YES];
     NSLog(@"error kkkk %@",error);
     _hud.mode = MBProgressHUDModeText;
     _hud.labelText = @"请求失败";
     [_hud hide:YES afterDelay:2];
     }];
     
     */
    
    
    ///////////---------------////////////注册START
    /*
     NSDictionary *dic = @{@"appId":APP_ID,
     @"nonceStr":NONCE_STR,
     @"account":[self textField:_accountView].text,
     @"pwd":[self textField:_passwordView].text
     };
     */
    // NSData *data = [HFSUtility RSADicToData:dic];
    
    //NSString *ret = base64_encode_data(data);
    //http://app-test.matrojp.com/member/ajax/app/login
    //{"appId": "test0002","userId":"00007906","password":"123456","sign":$sign}
    
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":[self textField:_rphoneView].text,@"vCode":[self textField:_rcodeView].text,@"password":[self textField:_rpasswordView].text}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"phone":[self textField:_rphoneView].text,
                            @"vCode":[self textField:_rcodeView].text,
                            @"password":[self textField:_rpasswordView].text,
                            @"sign":signDic[@"sign"]
                            };
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    //NSLog(@"加密后：%@",ret2);
    /*
     [[HFSServiceClient sharedClient] POST:Login_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *result = (NSDictionary *)responseObject;
     NSLog(@"%@",responseObject);
     
     NSLog(@"登录成功");
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"登录失败:%@",error);
     }];
     */
    /*
     [[HFSServiceClient sharedJSONClient] POST:@"http://app-test.matrojp.com/member/ajax/app/login" parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"登录成功:%@",responseObject);
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"登录失败：%@",error);
     }];
     */
    
    
    

    
    
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:Regist_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"注册信息：%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            
            // _hud.labelText = @"注册成功";
            // [_hud hide:YES afterDelay:2];
            
            // 存储用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * userDataDic = result[@"data"];
            
            
            if (userDataDic[@"img"] && ![@"" isEqualToString:userDataDic[@"img"]]) {
                [userDefaults setObject:userDataDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR ];
                
            }
            
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE ];
            [userDefaults setObject:userDataDic[@"accessToken"] forKey:kUSERDEFAULT_ACCCESSTOKEN];
            
            if ([userDataDic[@"nickName"] isEqualToString:@""] || !userDataDic[@"nickName"]) {
                [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERNAME ];
                //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值phone为：%@",userDataDic[@"phone"]);
            }
            else{
                [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME ];
                //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值nickname为：%@",userDataDic[@"nickname"]);
            }
            
            if (userDataDic[@"idcard"]) {
                [userDefaults setObject:userDataDic[@"idcard"] forKey:KUSERDEFAULT_IDCARD_SHENFEN];
            }
            else{
                [userDefaults setObject:@"" forKey:KUSERDEFAULT_IDCARD_SHENFEN];
            }
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERID ];
            
            BOOL isDefault = NO;
            if (userDataDic[@"vipCard"]) {
                NSArray * vipCardARR = userDataDic[@"vipCard"];
                if (vipCardARR.count == 1) {
                        //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                        //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
                        
                        for(NSDictionary * dics in vipCardARR) {
                            
                            if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                                NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                                [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                                 if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil) {
                                    NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                                    [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                }
                                else{
                                    [userDefaults setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];

                                }
                               
                                //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                                isDefault = YES;
                            }
                            else{
                                isDefault = NO;
                            }
                        }
                    
                }
                else if(vipCardARR.count > 1){
                    
                    for(NSDictionary * dics in vipCardARR) {
                        
                        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                            NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                            [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                            NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                            //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                            
                             if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil) {
                                [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                            }
                            else{
                                [userDefaults setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                            }
                            
                            isDefault = YES;
                        }
                        
                    }
                    
                    if (!isDefault) {
                        //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                        //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
                        //self.vipCardArray = vipCardARR;
                        
                        for(NSDictionary * dics in vipCardARR) {
                            
                            /*
                             if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                             NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                             [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                             //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                             }
                             */
                            VipCardModel * cardModel = [[VipCardModel alloc]init];
                            cardModel.cardNo = dics[@"cardNo"];
                            cardModel.cardTypeIdString = dics[@"cardTypeId"];
                            cardModel.cardTypeName = dics[@"cardTypeName"];
                            cardModel.cardImg = dics[@"cardImg"];
                            [self.vipCardArray addObject:cardModel];
                            
                        }
                        
                        
                        
                        //绑定会员卡
                        [weakSelf loadSettingMoCardViewWithCardARR:self.vipCardArray withPhone:[self textField:_rphoneView].text withCardNo:nil withAccessToken:userDataDic[@"accessToken"]];
                    }

                }
                else if (vipCardARR.count < 1){
                        isDefault = NO;
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"您还没有会员卡";
                    [_hud hide:YES afterDelay:2];
                    
                }
                
            }
            
            [userDefaults synchronize];
            
            //保存登录账号下次使用
            LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:userDataDic[@"phone"] inContext:_context];
            if (!loginHistory) {
                LoginHistory *loginHistory = [LoginHistory MR_createEntityInContext:_context];
                loginHistory.loginkeyword = userDataDic[@"phone"];
                [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    [self loadLoginHistory];
                }];
            }
            
            /*
             [_hud show:YES];
             _hud.mode = MBProgressHUDModeText;
             _hud.labelText = @"注册成功";
             [_hud hide:YES afterDelay:2];
             */
            [weakSelf textField:_rrpasswordView].text = @"";
            [weakSelf textField:_rphoneView].text = @"";
            [weakSelf textField:_rcodeView].text = @"";
            [weakSelf textField:_rpasswordView].text = @"";
            
            _loginTypeButton.selected = YES;
            _loginTypeBgView.hidden = NO;
            _registerTypeBgView.hidden = YES;
            _registerTypeButton.selected = NO;
            NSLog(@"注册成功");
            if (isDefault) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }else{
            /*
             _hud.labelText = result[@"errMsg"];
             [_hud hide:YES afterDelay:2];
             */
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    ///////////---------------////////////注册END
}

#pragma mark 注册后 显示选卡视图

- (void)loadSettingMoCardViewWithCardARR:(NSArray *)cardARR withPhone:(NSString *)phoneString withCardNo:(NSString *)cardNO withAccessToken:(NSString *)accessTokenString{
    /*
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"注册成功";
    [_hud hide:YES afterDelay:2];
    
    _loginTypeButton.selected = YES;
    _loginTypeBgView.hidden = NO;
    _registerTypeBgView.hidden = YES;
    _registerTypeButton.selected = NO;
    */
    /*
    [GlobalQueue executeAsyncTask:^{
        

        
        [MainQueue executeAsyncTask:^{
            
            // update UI
            NSLog(@"回到主线程  跟新UI");
        }];
    }];
    */
    __weak typeof(self) weakSelf = self;
    //NSLog(@"点击了注册按钮");
    self.settingMoCardView = [[SettingMoCardView alloc]initWithFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
    self.settingMoCardView.cardARR = cardARR;
    [self.settingMoCardView loadViews];
    [self.settingMoCardView bindButtonBlockAction:^(BOOL success) {
        if (self.settingMoCardView.cardNoString != nil && ![self.settingMoCardView.cardNoString isEqualToString:@""]) {
            
            _currentCardTypeNames = self.settingMoCardView.cardTypeName;
            _currentCardNOs = self.settingMoCardView.cardNoString;
            

            [weakSelf loadBindCardViewwithPhone:phoneString withCardNo:self.settingMoCardView.cardNoString withAccessToken:accessTokenString];
        }
        else{

            
            VipCardModel * cardModel = (VipCardModel *)[cardARR objectAtIndex:0];
            _currentCardNOs = cardModel.cardNo;
            _currentCardTypeNames = cardModel.cardTypeName;
            /*NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:cardModel.cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            [userDefault synchronize];
            */
            [weakSelf loadBindCardViewwithPhone:phoneString withCardNo:cardModel.cardNo withAccessToken:accessTokenString];
        }
        
        
    }];
    [self.view addSubview:self.settingMoCardView];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.settingMoCardView setFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT)];
        
    } completion:^(BOOL finished) {
        
    }];

    /*
    // 使用GCD的线程组
    // init group
    GCDGroup *group = [GCDGroup new];
    
    // add to group
    [GlobalQueue executeTask:^{
        
        // task one
        NSLog(@"任务一的线程为：");
        
        
        
        
    } inGroup:group];
    */
    
    //[self.view insertSubview:self.settingMoCardView atIndex:0];
     
   
}

#pragma mark 注册后 绑定会员卡
- (void)loadBindCardViewwithPhone:(NSString *)phone withCardNo:(NSString *)cardNo withAccessToken:(NSString *)accessToken{
    if (accessToken == nil) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"AccessToken已过期";
        [_hud hide:YES afterDelay:2.0f];
        return;
    }
    else{
        //{"appId": "test0002","phone":"18020260894","cardNo":"70016227","sign":$sign,"accessToken":$accessToken}
        //BindCard_URLString
        NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":phone,@"cardNo":cardNo}];
        NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                @"phone":phone,
                                @"cardNo":cardNo,
                                @"sign":signDic[@"sign"],
                                @"accessToken":accessToken
                                };
        
        NSData *data2 = [HFSUtility RSADicToData:dic2];
        NSString *ret2 = base64_encode_data(data2);
        //@"vip/AuthUserInfo"
        [[HFSServiceClient sharedClient] POST:BindCard_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *result = (NSDictionary *)responseObject;
            //NSLog(@"设置默认卡%@",result);
            if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                
                [UIView animateWithDuration:0.5f animations:^{
                    [self.settingMoCardView setFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
                    
                    
                } completion:^(BOOL finished) {
                    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:_currentCardTypeNames forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                    [userDefault setObject:_currentCardNOs forKey:kUSERDEFAULT_USERCARDNO];
                    [userDefault synchronize];
                }];
            
                [self dismissViewControllerAnimated:NO completion:nil];
                
            }else{
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = result[@"errMsg"];
                [_hud hide:YES afterDelay:2];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];

    
    }
    
    
}



#pragma end mark


-(void)checkSms
{
    
    NSDictionary *dic = @{
                          @"mphone":[self textField:_rphoneView].text,
                          @"vcode":[self textField:_rcodeView].text
                          };
    
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    [[HFSServiceClient sharedClient]POST:@"common/checksms" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"result %@",result);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}



- (void)bindCardAction{
    //{"appId": "test0002","phone":"18020260894","cardNo":"70016227","sign":$sign,"accessToken":$accessToken}
    
    
    /*
    //http://app-test.matrojp.com/member/ajax/app/sso/forgetPsw  忘记密码
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"userId":phoneString,@"password":passWordString}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"userId":phoneString,
                            @"password":passWordString,
                            @"sign":signDic[@"sign"]
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:ForgetPassword_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            
            _hud.labelText = @"登录成功";
            [_hud hide:YES afterDelay:2];
            
            // 存储用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * userDataDic = result[@"data"];
            NSArray * vipCardDic = userDataDic[@"vipCard"];
            
            if (vipCardDic.count > 0) {
                //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
                
                for(NSDictionary * dics in vipCardDic) {
                    
                    if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                        NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                        [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                        //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                    }
                }
            }
            if (userDataDic[@"img"] && ![@"" isEqualToString:userDataDic[@"img"]]) {
                [userDefaults setObject:userDataDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR ];
                
            }
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE ];
            [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME];
            [userDefaults setObject:userDataDic[@"accessToken"] forKey:kUSERDEFAULT_ACCCESSTOKEN];
            
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERID ];
            
            
            [userDefaults synchronize];
            
            //保存登录账号下次使用
            LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:userDataDic[@"phone"] inContext:_context];
            if (!loginHistory) {
                LoginHistory *loginHistory = [LoginHistory MR_createEntityInContext:_context];
                loginHistory.loginkeyword = [self textField:_accountView].text;
                [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    [self loadLoginHistory];
                }];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

    */

}

//注册后  直接登录
#pragma mark 注册后直接登录
- (void)loginAfterRegisterActionwithPhone:(NSString *)phoneString withPassword:(NSString *)passWordString{

    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"userId":phoneString,@"password":passWordString}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"userId":phoneString,
                            @"password":passWordString,
                            @"sign":signDic[@"sign"]
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    
    

    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:Login_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            
            _hud.labelText = @"登录成功";
            [_hud hide:YES afterDelay:2];
            
            // 存储用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * userDataDic = result[@"data"];
            NSArray * vipCardDic = userDataDic[@"vipCard"];
            
            if (vipCardDic.count > 0) {
                //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
                
                for(NSDictionary * dics in vipCardDic) {
                    
                    if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                        NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                        [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                        //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                    }
                }
            }
            if (userDataDic[@"img"] && ![@"" isEqualToString:userDataDic[@"img"]]) {
                [userDefaults setObject:userDataDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR ];
                
            }
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE ];
            [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME];
            [userDefaults setObject:userDataDic[@"accessToken"] forKey:kUSERDEFAULT_ACCCESSTOKEN];
            
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERID ];
            
            
            [userDefaults synchronize];
            
            //保存登录账号下次使用
            LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:userDataDic[@"phone"] inContext:_context];
            if (!loginHistory) {
                LoginHistory *loginHistory = [LoginHistory MR_createEntityInContext:_context];
                loginHistory.loginkeyword = [self textField:_accountView].text;
                [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    [self loadLoginHistory];
                }];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
 

}
#pragma end mark

-(void)requestPostHttp:(NSString*)url params:(NSData*)params{
    NSURL * URL = [NSURL URLWithString:url];
    
    
//    NSData * postData = [params dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:params];  //设置请求的参数}
//    [request mutableSetValueForKeyPath:<#(nonnull NSString *)#>]
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"error %@",result);
                                  }];
    
    [task resume];
}


-(BOOL)canRegister{
    NSString *errStr = nil;
    
    if (!([self textField:_rphoneView].text.length >0)) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"手机号格式错误，请确认。";
        [_hud hide:YES afterDelay:2];
        
        return NO;
    }
    if (!([self textField:_rpasswordView].text.length >0) ||!([self textField:_rrpasswordView].text.length >0)  ) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请使用6-20位字母或数字。";
        [_hud hide:YES afterDelay:2];
        
        return NO;
    }
    if (!([self textField:_rcodeView].text.length >0)) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"验证码错误，请确认。";
        [_hud hide:YES afterDelay:2];
        
        return NO;
    }
    
    
    if (![HFSUtility validateMobile:[self textField:_rphoneView].text]) {
        errStr = @"手机号格式错误，请确认。";
    }else if ([self textField:_rcodeView].text.length != 4){
        errStr = @"验证码错误，请确认。";
    }
    else if ([self textField:_rpasswordView].text.length < 6 || [self textField:_rpasswordView].text.length > 20){
        errStr = @"请使用6-20位字母或数字。";
    }else if (![[self textField:_rpasswordView].text isEqualToString:[self textField:_rrpasswordView].text]){
        errStr = @"两次密码输入不一致，请确认。";
    }
    else if (![ZhengZePanDuan checkPasswordMeiLuo:[self textField:_rpasswordView].text]){
        errStr = @"请使用6-20位字母或数字。";
    }
    else{
        errStr = nil;
    }
    
    if (errStr) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = errStr;
        [_hud hide:YES afterDelay:2];
        
        return NO;
    }
    return YES;
}

#pragma mark- 登录
//登录按钮
- (IBAction)loginButtonAction:(id)sender {
    if ([self textField:_accountView].text.length == 0) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入手机号";
        [_hud hide:YES afterDelay:2];
        return;
        
    }
    if ([self textField:_passwordView].text.length == 0) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入密码";
        [_hud hide:YES afterDelay:2];
        return;
        
        
    }
    
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"正在登录...";
    
    __weak typeof(self) weakSelf = self;
//
//    NSDictionary *dic = @{@"appId":APP_ID,
//                          @"nonceStr":NONCE_STR,
//                          @"account":[self textField:_accountView].text,
//                          @"pwd":[self textField:_passwordView].text
//                          };
    
   // NSData *data = [HFSUtility RSADicToData:dic];
    
    //NSString *ret = base64_encode_data(data);
    //http://app-test.matrojp.com/member/ajax/app/login
    //{"appId": "test0002","userId":"00007906","password":"123456","sign":$sign}

    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"userId":[self textField:_accountView].text,@"password":[self textField:_passwordView].text}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"userId":[self textField:_accountView].text,
                            @"password":[self textField:_passwordView].text,
                            @"sign":signDic[@"sign"]
                            };
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    //NSLog(@"加密后：%@",ret2);
    /*
    [[HFSServiceClient sharedClient] POST:Login_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",responseObject);
        
        NSLog(@"登录成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登录失败:%@",error);
    }];
    */
    /*
    [[HFSServiceClient sharedJSONClient] POST:@"http://app-test.matrojp.com/member/ajax/app/login" parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录成功:%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登录失败：%@",error);
    }];
    */
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@",Login_URLString];
//    NSURL * URL = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
//    [request setHTTPMethod:@"post"]; //指定请求方式
//    NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data3];
//    [request setURL:URL]; //设置请求的地址
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
//                                            completionHandler:
//                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
//                                      //NSData 转NSString
//                                      if (data && data.length>0) {
//                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                          NSLog(@"error %@",result);
//                                          if ([@"true" isEqualToString:result]) {
//                                              
//                                              
//                                          }
//                                          else
//                                          {
//                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                  
//                                                  [_hud show:YES];
//                                                  _hud.mode = MBProgressHUDModeText;
//                                                  _hud.labelText = result;
//                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
//                                                  [_hud hide:YES afterDelay:2];
//                                              });
//                                              
//                                          }
//                                      }
//                                      
//                                  }];
//    
//    [task resume];

    
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:Login_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            
            _hud.labelText = @"登录成功";
            [_hud hide:YES afterDelay:2];
            
            // 存储用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * userDataDic = result[@"data"];
            NSArray * vipCardDic = userDataDic[@"vipCard"];
            BOOL isDefault = NO;
            
            if (vipCardDic.count > 0) {
                //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
              
                for(NSDictionary * dics in vipCardDic) {

                if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                    NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                    [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                    NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                    NSLog(@"会员卡类型++++++：%@",cardTypeName);
                    if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil) {
                        [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                    }
                    else{
                        [userDefaults setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                    }
                    
                    //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                    isDefault = YES;
                }
                }
            }
            
            if (userDataDic[@"img"] && ![@"" isEqualToString:userDataDic[@"img"]]) {
                [userDefaults setObject:userDataDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR ];

            }
            
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE];
            NSLog(@"登录方法中的nickName值为：%@",userDataDic[@"nickName"]);
            if ([userDataDic[@"nickName"] isEqualToString:@""] || !userDataDic[@"nickName"]) {
                [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERNAME ];
                 //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值phone为：%@",userDataDic[@"phone"]);
            }
            else{
                [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME ];
                //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值nickname为：%@",userDataDic[@"nickname"]);
            }
           
            
            [userDefaults setObject:userDataDic[@"accessToken"] forKey:kUSERDEFAULT_ACCCESSTOKEN];
            
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERID ];
            NSLog(@"userDataDic-----:%@",userDataDic[@"idcard"]);
            if (userDataDic[@"idcard"]) {
                [userDefaults setObject:userDataDic[@"idcard"] forKey:KUSERDEFAULT_IDCARD_SHENFEN];
            }
            else{
                [userDefaults setObject:@"" forKey:KUSERDEFAULT_IDCARD_SHENFEN];
            }
            
            
            
            [userDefaults synchronize];
            
            //保存登录账号下次使用
            LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:userDataDic[@"phone"] inContext:_context];
            if (!loginHistory) {
                LoginHistory *loginHistory = [LoginHistory MR_createEntityInContext:_context];
                loginHistory.loginkeyword = userDataDic[@"phone"];
                [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    [self loadLoginHistory];
                }];
            }
            
            if (isDefault) {
                 [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                if (vipCardDic.count > 0) {
                    NSDictionary * dics = [vipCardDic objectAtIndex:0];

                            NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                            [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                            NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                            if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil) {
                                    [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                            }
                            else{
                                [userDefaults setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                            }

                            //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]  forKey:kUSERDEFAULT_USERCARDNO];
                    
                    //绑定会员卡
                    [weakSelf loadBindCardViewwithPhone:userDataDic[@"phone"] withCardNo:cardno withAccessToken:userDataDic[@"accessToken"]];

                }else{
                
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = @"您还没有会员卡";
                        [_hud hide:YES afterDelay:1];
                    }];
                    //[weakSelf dismissViewControllerAnimated:YES completion:nil];
                
                    
                }
                
            }
            
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

    
    
}

//快速注册按钮
- (IBAction)fresisterButtonAction:(id)sender {
    _loginTypeButton.selected = NO;
    _loginTypeBgView.hidden = YES;
    _registerTypeBgView.hidden = NO;
    _registerTypeButton.selected = YES;
}
- (IBAction)vipLoginButtonAction:(id)sender {
    
#warning 直接登录还是跳VIP界面
    
    MLVIPCardViewController *vc = [[MLVIPCardViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    //    [_hud show:YES];
    //    _hud.mode = MBProgressHUDModeText;
    //    _hud.labelText = @"VIP登录";
    //    [_hud hide:YES afterDelay:2];
    //
    //    [self performSelector:@selector(dimissViewControllerAction) withObject:nil afterDelay:2.0f];
}

- (IBAction)qqLoginBtnAction:(UIButton *)sender {

    NSLog(@"点击了QQ");
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"QQ登录信息：\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
           // NSDictionary *dict = @{@"nickname":snsAccount.userName?:@"",@"headPicUrl":snsAccount.iconURL?:@"",@"source":@"WECHAT",@"partnerId":snsAccount.openId,@"appId":APP_ID};
            
            /*zhoulu*/
            NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"openId":snsAccount.openId,@"type":@"01"}];
            NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                    @"openId":snsAccount.openId,
                                    @"type":@"01",
                                    @"sign":signDic[@"sign"]
                                    };
            NSLog(@"+++username:%@",snsAccount.userName);
            NSDictionary * bindDic = @{@"nickname":snsAccount.userName,
                                       @"imgUrl":snsAccount.iconURL,
                                       @"type":@"01"
                                       };
            [self loginWxAndQQWithParams:dic2 withSignDic:signDic bindPoneDic:bindDic];
            
        }});
    
}


- (IBAction)wxLoginButtonAction:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            
            NSLog(@"微信\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@\n,openId:%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message,snsAccount.openId);
            
           // NSDictionary *dict = @{@"nickname":snsAccount.userName?:@"",@"headPicUrl":snsAccount.iconURL?:@"",@"source":@"WECHAT",@"partnerId":snsAccount.openId,@"appId":APP_ID};
            /*zhoulu*/
            NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"openId":snsAccount.openId,@"type":@"02"}];
            NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                    @"openId":snsAccount.openId,
                                    @"type":@"02",
                                    @"sign":signDic[@"sign"]
                                    };
            
            NSDictionary * bindDic = @{ @"nickname":snsAccount.userName,
                                        @"imgUrl":snsAccount.iconURL,
                                       @"type":@"02"
                                       };
            
            [self loginWxAndQQWithParams:dic2 withSignDic:signDic bindPoneDic:bindDic];
            
            
        }
    });

}


- (void)loginWxAndQQWithParams:(NSDictionary *)params withSignDic:(NSDictionary * )signDic bindPoneDic:(NSDictionary *)bindDic{
    
    __weak typeof(self) weakSelf = self;
    
    NSData *data = [HFSUtility RSADicToData:params] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient] POST:ThirdLogin_URLString parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"第三方登录信息：%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary * userDataDic = result[@"data"];
         NSString * succString = [NSString stringWithFormat:@"%@",[result objectForKey:@"succ"]];
        if ([succString isEqualToString:@"1"]) {
            
            NSString * statusString = [NSString stringWithFormat:@"%@",[userDataDic objectForKey:@"status"]];
            if ([statusString isEqualToString:@"0"]) {//如果有userId说明第三方登录成功  并且绑定过 手机号
                
                
                // 存储用户信息
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
                if (userDataDic[@"img"] && ![@"" isEqualToString:userDataDic[@"img"]]) {
                    [userDefaults setObject:userDataDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR];
                }
                
                //[userDefaults setObject:result[@"nickname"] forKey:kUSERDEFAULT_USERNAME ];
                
                if ([userDataDic[@"nickName"] isEqualToString:@""] || !userDataDic[@"nickName"]) {
                    [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERNAME ];
                    //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值phone为：%@",userDataDic[@"phone"]);
                }
                else{
                    [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME ];
                    //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值nickname为：%@",userDataDic[@"nickname"]);
                }
                if (userDataDic[@"idcard"]) {
                    [userDefaults setObject:userDataDic[@"idcard"] forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                }
                else{
                    [userDefaults setObject:@"" forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                }
                [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERID ];
                [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE];
                NSArray * vipCardDic = userDataDic[@"vipCard"];
                BOOL isDefault = NO;
                
                if (vipCardDic.count > 0) {
                    for(NSDictionary * dics in vipCardDic) {
                        
                        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                            NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                            [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                            NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                             if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil) {
                                [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                            }
                            else{
                                [userDefaults setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                            }
                            //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                            isDefault = YES;
                        }
                    }
                }
                
                
                [userDefaults setObject:userDataDic[@"accessToken"] forKey:kUSERDEFAULT_ACCCESSTOKEN];

                [userDefaults synchronize];
                
                
                if (isDefault) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                }
                else{
                    if (vipCardDic.count > 0) {
                        NSDictionary * dics = [vipCardDic objectAtIndex:0];
                        
                        NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                        [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                        NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                         if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil) {
                            [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                        }
                        else{
                            [userDefaults setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                        }
                        //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]  forKey:kUSERDEFAULT_USERCARDNO];
                        
                        //绑定会员卡
                        [weakSelf loadBindCardViewwithPhone:userDataDic[@"phone"] withCardNo:cardno withAccessToken:userDataDic[@"accessToken"]];
                        
                    }else{
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = @"您还没有会员卡";
                        [_hud hide:YES afterDelay:2];
                        
                    }
                    
                }
                
                
                
            }
            else{//如果没有调到绑定页面
                NSLog(@"登录到绑定页");
                MLBindPhoneController *vc = [[MLBindPhoneController alloc]init];
                [vc backBlocksAction:^(BOOL success) {
                    if (success) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                //vc.hidesBottomBarWhenPushed = YES;
                vc.open_id = params[@"openId"];
                NSLog(@"++++openId为：%@",vc.open_id);
                vc.nickname = bindDic[@"nickname"];
                vc.imgUrl = bindDic[@"imgUrl"];
                vc.type = bindDic[@"type"];
                [weakSelf presentViewController:vc animated:YES completion:nil];
                //[self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        NSLog(@"error %@",error);
        [_hud hide:YES afterDelay:2];
    }];
}

#pragma mark- 验证码
//验证码按钮
- (IBAction)codeButtonAction:(id)sender {
    //http://app.matrojp.com/P2MLinkCenter/common/sendsms
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"";
    
    if ([HFSUtility validateMobile:[self textField:_rphoneView].text]) {
        
        NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,
                                                       @"phone":[self textField:_rphoneView].text
                                                       }];
        NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                @"phone":[self textField:_rphoneView].text,
                                @"sign":signDic[@"sign"]
                                };
        NSData *data2 = [HFSUtility RSADicToData:dic2];
        NSString *ret2 = base64_encode_data(data2);
        
        [[HFSServiceClient sharedClient]POST:PhoneIsRegisted_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"检测手机是否注册过：%@",result);
            NSDictionary * phoneDicIs = result[@"data"];
            if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",phoneDicIs[@"phoneIsRegister"]]]){//这不是我们的会员，可以用来注册
                [self getValidateCode];//发验证码
            }else{
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"手机号已注册";
                [_hud hide:YES afterDelay:2];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
           // NSLog(@"验证码错误信息：%@",error);
        }];
        
    }else{
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入正确的手机号码";
        [_hud hide:YES afterDelay:2];
    }
    
    /*
    
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,
                                                   @"phone":[self textField:_rphoneView].text
                                                   }];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"phone":[self textField:_rphoneView].text,
                            @"sign":signDic[@"sign"]
                            };
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:PhoneIsRegisted_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            
            _hud.labelText = @"注册成功";
            [_hud hide:YES afterDelay:2];
            
            // 存储用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * userDataDic = result[@"data"];
            NSArray * vipCardDic = userDataDic[@"vipCard"];
            
            if (vipCardDic.count > 0) {
                //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
                
                for(NSDictionary * dics in vipCardDic) {
                    
                    if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                        NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                        [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                        //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
                    }
                }
            }
            if (userDataDic[@"img"] && ![@"" isEqualToString:userDataDic[@"img"]]) {
                [userDefaults setObject:userDataDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR ];
                
            }
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE ];
            [userDefaults setObject:userDataDic[@"nickname"] forKey:kUSERDEFAULT_USERNAME ];
            
            
            [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERID ];
            
            
            [userDefaults synchronize];
            
            //保存登录账号下次使用
            LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:userDataDic[@"phone"] inContext:_context];
            if (!loginHistory) {
                LoginHistory *loginHistory = [LoginHistory MR_createEntityInContext:_context];
                loginHistory.loginkeyword = [self textField:_accountView].text;
                [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    [self loadLoginHistory];
                }];
            }
            
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"注册成功";
            [_hud hide:YES afterDelay:2];
            
            
            _loginTypeButton.selected = YES;
            _loginTypeBgView.hidden = NO;
            _registerTypeBgView.hidden = YES;
            _registerTypeButton.selected = NO;
            NSLog(@"注册成功");
            
            
            //[self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
*/
    
}
//发送验证码
-(void)getValidateCode{
    
    
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":[self textField:_rphoneView].text,@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
                                                                                
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"验证码已发送，请注意查收";
            [_hud hide:YES afterDelay:2];
            _endTime = 60;
            [self codeTimeCountdown];
                                                                                    
        }else{
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = result[@"msg"];
                [_hud hide:YES afterDelay:2];
        }
                                                                                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}

#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    
    if ([textField isEqual:[self textField:_accountView]]) {
        _tableView.hidden = NO;
        _showmoreaccoutButton.selected = YES;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    
    if ([textField isEqual:[self textField:_accountView]] || [textField isEqual:[self textField:_passwordView]]) {
        if ([[self textField:_accountView].text isEqualToString:@""] || [[self textField:_passwordView].text isEqualToString:@""]) {
            _loginButton.enabled = NO;
            
            //[_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
            _loginButton.backgroundColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
            //_loginButton.layer.borderWidth = 1.0f;
            //_loginButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
        }else{
            _loginButton.enabled = YES;
            
            //[_loginButton setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
            _loginButton.backgroundColor = [HFSUtility hexStringToColor:Main_BackgroundColor];
            //_loginButton.layer.borderWidth = 1.0f;
            //_loginButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    if ([textField isEqual:[self textField:_rphoneView]] || [textField isEqual:[self textField:_rcodeView]] || [textField isEqual:[self textField:_rpasswordView]] || [textField isEqual:[self textField:_rrpasswordView]]) {
        if (_isReadDelegate && [self checkRegisterButtonEnabledYESorNO]) {
            
            
            self.registerButton.enabled = YES;
            [self.registerButton setBackgroundColor:[UIColor colorWithHexString:Main_BackgroundColor]];
            
        }
        else{
            self.registerButton.enabled = NO;
             [self.registerButton setBackgroundColor:[UIColor colorWithHexString:Main_grayBackgroundColor]];
        }

    }
    if([textField isEqual:[self textField:_rphoneView]]){
        if ([textField.text isEqualToString:@""] || !textField.text) {
            _codeButton.enabled = NO;
            [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
        }
        else{
            _codeButton.enabled = YES;
            [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_BackgroundColor]];
        }
    }
    NSLog(@"手机号的变化：%@+++%@",string,textField.text);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    [self closeButton:textField].hidden = YES;
    
    if ([textField isEqual:[self textField:_accountView]]) {
        _tableView.hidden = YES;
        _showmoreaccoutButton.selected = NO;
    }
    if([textField isEqual:[self textField:_rphoneView]]){
        if ([textField.text isEqualToString:@""] || !textField.text) {
            _codeButton.enabled = NO;
            [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
        }
        else{
            _codeButton.enabled = YES;
            [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_BackgroundColor]];
        }
    }
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLLoginTableViewCell" ;
    MLLoginTableViewCell *cell = (MLLoginTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    
    cell.deleteBlcok = ^(){
        LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:_accountArray[indexPath.row] inContext:_context];
        [_context MR_deleteObjects:@[loginHistory]];
        [self loadLoginHistory];
    };
    cell.logininfoLabel.text = _accountArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self textField:_accountView].text = _accountArray[indexPath.row];
    NSLog(@"%@",_accountArray[indexPath.row]);
    [[self textField:_accountView] resignFirstResponder];
    [self textField:_passwordView].text = @"";
    _tableView.hidden = YES;
    _showmoreaccoutButton.selected = NO;
    
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //SkyRadiusView 是一个圆角的类的View，在这里使用是为了防止手势冲突
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SkyRadiusView"]) {
        return NO;
    }
    return  YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

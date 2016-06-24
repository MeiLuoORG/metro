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
#import "JPUSHService.h"

#define CODE_TIME_KEY @"CODE_TIME_KEY"



@interface MLLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
  
    NSManagedObjectContext *_context;
    NSMutableArray *_accountArray;
    
    BOOL _isReadDelegate;
    NavTopCommonImage * _navTopCommoImages;
    UIButton * _rightBtn;
    
    NSString * _currentCardNOs;
    NSString * _currentCardTypeNames;
    
    BOOL _isFaSonging;//是否验证码正在发送
    int residualTime;//设定每次获取验证码的时间间隔
    NSInteger _endTime;
    
    
    BOOL _isQuickly_Register;
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
    //_isFaSonging = NO;
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
    
    
    //UiTextField变化通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:nil];
 
    
    //
    [self textField:_accountView].keyboardType = UIKeyboardTypeNumberPad;
}

- (void)textChangeAction:(id)sender{

    NSLog(@"变化后的值为：------%@",[self textField:_passwordView].text);
    if (_isLogin) {
        if ([[self textField:_accountView].text isEqualToString:@""] || [[self textField:_passwordView].text isEqualToString:@""]) {
            _loginButton.enabled = NO;
            
            //[_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
            _loginButton.backgroundColor = [HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor];
            //_loginButton.layer.borderWidth = 1.0f;
            //_loginButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
        }else{
            _loginButton.enabled = YES;
            
            //[_loginButton setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
            _loginButton.backgroundColor = [HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor];
            //_loginButton.layer.borderWidth = 1.0f;
            //_loginButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
    }
    else{
        if (_isReadDelegate && [self checkRegisterButtonEnabledYESorNO]) {
            
            
            self.registerButton.enabled = YES;
            [self.registerButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonNormel_backgroundColor]];
            
        }
        else{
            
            self.registerButton.enabled = NO;
            [self.registerButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonGray_backgroundColor]];
        }
        if (!_isFaSonging) {
            if ([[self textField:_rphoneView].text isEqualToString:@""] || ![self textField:_rphoneView].text || ![HFSUtility validateMobile:[self textField:_rphoneView].text]) {
                _codeButton.enabled = NO;
                [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
            }
            else{
                _codeButton.enabled = YES;
                [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
            }
        }
    }
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
    
    
    
    //_rcodeView.layer.cornerRadius = 4.0f;
    _rcodeView.layer.cornerRadius = 4.0f;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_rcodeView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.0,4.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _rcodeView.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = grayColors.CGColor;
    maskLayer.strokeColor = grayColors.CGColor;

    _rcodeView.layer.borderColor = grayColors.CGColor;
    _rcodeView.layer.mask = maskLayer;
    //_rcodeView.layer.masksToBounds = YES;
    /*
     self.layer.masksToBounds = YES; // 裁剪
     self.layer.shouldRasterize = YES; // 缓存
     self.layer.rasterizationScale = [UIScreen mainScreen].scale;
     */
    
    
    //[_codeButton setBackgroundColor:[HFSUtility hexStringToColor:@"b9b6b6"]];
    _codeButton.enabled = NO;
    //_codeButton.layer.cornerRadius = 4.0f;
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_codeButton.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0,4.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _codeButton.bounds;
    maskLayer2.path = maskPath2.CGPath;
    //maskLayer2.fillColor = grayColors.CGColor;
    //maskLayer.strokeColor = grayColors.CGColor;
    
    _codeButton.layer.borderColor = grayColors.CGColor;
    _codeButton.layer.mask = maskLayer2;
    //_codeButton.layer.masksToBounds = YES;

    
    
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
        self.registerButton.backgroundColor = [UIColor colorWithHexString:Main_ButtonGray_backgroundColor];
        _isReadDelegate = NO;
    }
    else
    {
        _isReadDelegate = YES;
        if ([self checkRegisterButtonEnabledYESorNO]) {
             self.registerButton.enabled = YES;
            self.registerButton.backgroundColor = [UIColor colorWithHexString:Main_ButtonNormel_backgroundColor];
        }
        else {
            self.registerButton.enabled = NO;
            self.registerButton.backgroundColor = [UIColor colorWithHexString:Main_ButtonGray_backgroundColor];
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
    if ([phoneText.text isEqualToString:@""] || [codeText.text isEqualToString:@""] || [passText.text isEqualToString:@""] || [rePassText.text isEqualToString:@""] || ![HFSUtility validateMobile:phoneText.text] ) {
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
    [_showpasswordButton setImage:[UIImage imageNamed:@"xianshizl"] forState:UIControlStateSelected];
    _showmoreaccoutButton.hidden = YES;
    
    /*
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0,4.0)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _tableView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    //maskLayer2.fillColor = grayColors.CGColor;
    //maskLayer.strokeColor = grayColors.CGColor;
    _tableView.layer.mask = maskLayer2;
    */
    _tableView.layer.borderWidth = 1.0f;
    _tableView.layer.borderColor = [UIColor colorWithHexString:Main_bianGrayBackgroundColor].CGColor;
    _tableView.layer.cornerRadius = 4.0f;
    
        /*
    //不支持QQ
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        _qqLoginBgView.hidden = YES;
        _qqLoginButton.hidden = YES;
        //NSLog(@"不支持QQ");
    }
    */
    /*
    //不支持微信
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        _wxLoginBgView.hidden = YES;
        //NSLog(@"不支持微信");
    }
    */
    //加载头部
    [self setTopTltle];
}

//设置 头部标题 和按钮
- (void)setTopTltle{

    if (_isLogin) {
        _navTopCommoImages = [[NavTopCommonImage alloc]initWithTitle:@"登录"];
        [_navTopCommoImages loadLeftBackButtonwith:0];
        [_navTopCommoImages backButtonAction:^(BOOL succes) {
            
            if (_isQuickly_Register) {
                _loginTypeBgView.hidden = NO;
                _registerTypeBgView.hidden = YES;
                _navTopCommoImages.tittleLabel.text = @"登录";
                _isLogin = YES;
                if (_rightBtn) {
                    _rightBtn.hidden = NO;
                }
                _isQuickly_Register = NO;
            }
            else{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }

        }];
        
        [self.view addSubview:_navTopCommoImages];
        
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightBtn setTitle:@"快速注册" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_rightBtn setFrame:CGRectMake(SIZE_WIDTH-80, 34, 60, 22)];
        [_rightBtn setTitleColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor] forState:UIControlStateNormal];
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

    _isQuickly_Register = YES;
    NSLog(@"点击了快速注册");
    _loginTypeBgView.hidden = YES;
    _registerTypeBgView.hidden = NO;
    _navTopCommoImages.tittleLabel.text = @"注册";
    _isLogin = NO;
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString * currentPhone = [userDefault objectForKey:ZHAOHUIPASSWORD_CURRENT_PHONE];
    
    if (![currentPhone isEqualToString:@""] && currentPhone != nil) {
        [self textField:_accountView].text = currentPhone;
    }
    
    //设置是否可以登录
    if ([[self textField:_accountView].text isEqualToString:@""] || [[self textField:_passwordView].text isEqualToString:@""]) {
        _loginButton.enabled = NO;
        /*
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.layer.borderWidth = 1.0f;
        _loginButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
         */
        [_loginButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
        
    }
    //设置是否可以注册
    if (!_isReadDelegate || ![self checkRegisterButtonEnabledYESorNO]) {
        
        _registerButton.enabled = NO;
        [_registerButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    }
    
    

    
    //if ([HFSUtility validateMobile:[self textField:_rphoneView].text]) {
        //短信倒计时
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
        if (timeSp) {
            _endTime = 60 - ([timeSp integerValue] - [tempTime integerValue]);
        }
        NSLog(@"tempTime值为：%@,_endTime的值为：%ld",tempTime,_endTime);
        if (!tempTime ||  _endTime> 60) {
            
            //_codeButton.enabled = YES;
            _isFaSonging = NO;
            _endTime = 0;
        }else{
            _codeButton.enabled = NO;
            _isFaSonging = YES;
        }
        
        [self codeTimeCountdown];

    /*
     if (![userPhone isEqualToString:@""]) {
     _phoneTextField.text = userPhone;
     }
     */
    [self codeTimeCountdown];
    
    //}
    //else{
       // _codeButton.enabled = NO;
       // [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    //}
    
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
    //[_tableView reloadData];
    //_tableViewH.constant = _accountArray.count > 3 ? 3 * 40 : _accountArray.count * 40;
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
                
                if ([HFSUtility validateMobile:[self textField:self.rphoneView].text]) {
                    //设置界面的按钮显示 根据自己需求设置
                    _codeButton.enabled=YES;
                    _isFaSonging = NO;
                    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonNormel_backgroundColor]];
                }
                else{
                    
                    //设置界面的按钮显示 根据自己需求设置
                    _codeButton.enabled=NO;
                    _isFaSonging = NO;
                    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonGray_backgroundColor]];
                }

                
                /*
                [_codeButton setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                _codeButton.backgroundColor = [UIColor clearColor];
                _codeButton.layer.borderWidth = 1.0f;
                _codeButton.layer.borderColor = [UIColor clearColor].CGColor;
                 */

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
                [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonGray_backgroundColor]];
                _isFaSonging = YES;
                [_codeButton setTitle:strTime forState:UIControlStateNormal];
                
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
            _tableView.hidden = YES;
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
    
    if (_isLogin) {
        _loginButton.enabled = NO;
        
        //[_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
        _loginButton.backgroundColor = [HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor];
    }
    else{
        self.registerButton.enabled = NO;
        [self.registerButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonGray_backgroundColor]];
        
        if (![HFSUtility validateMobile:[self textField:_rphoneView].text]) {
            _codeButton.enabled = NO;
            [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
        }

    
    }
    
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
    
  
    __weak typeof(self) weakSelf =self;
    
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
    //调用原生注册方法
    [self yuanShengRegisterAcrionWithRet2:ret2];

    

    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:Regist_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"注册信息：%@",result);
        
        
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}
#pragma mark 原生注册方法 开始
- (void) yuanShengRegisterAcrionWithRet2:(NSString *)ret2{
    __weak typeof(self) weakSelf =self;
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",Regist_URLString];
        NSURL * URL = [NSURL URLWithString:urlStr];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"post"]; //指定请求方式
        NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data3];
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSLog(@"原生注册错误data:%@,error:%@",data,error);
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  
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
                                                              /*
                                                              [_hud show:YES];
                                                              _hud.mode = MBProgressHUDModeText;
                                                              _hud.labelText = @"您还没有会员卡";
                                                              [_hud hide:YES afterDelay:2];
                                                              */
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
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = result[@"errMsg"];
                                                      [_hud hide:YES afterDelay:2];
                                                      });
                                                  }
                                                  
                                                  
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                                  
                                              }
                                          }
                                          else{
                                              //请求有错误
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = REQUEST_ERROR_ZL;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:1];
                                              
                                              });
                                              
                                        }
                                      }];
    
        [task resume];
    //});
}
#pragma end mark 原生注册方法  结束


#pragma mark 注册后 显示选卡视图

- (void)loadSettingMoCardViewWithCardARR:(NSArray *)cardARR withPhone:(NSString *)phoneString withCardNo:(NSString *)cardNO withAccessToken:(NSString *)accessTokenString{
    dispatch_async(dispatch_get_main_queue(), ^{
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
    });
   
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
        //调用原生绑卡请求
        [self yuanShengBingCardAcrionWithRet2:ret2];
        /*
        //@"vip/AuthUserInfo"
        [[HFSServiceClient sharedClient] POST:BindCard_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
            NSDictionary *result = (NSDictionary *)responseObject;

         
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = REQUEST_ERROR_ZL;
            [_hud hide:YES afterDelay:2];
        }];
         */
    }
}

#pragma end mark
#pragma mark 注册后绑定原生方法 开始
- (void) yuanShengBingCardAcrionWithRet2:(NSString *)ret2{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    //static dispatch_once_t predicate = 0;
    //dispatch_once(&predicate, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",BindCard_URLString];
        NSURL * URL = [NSURL URLWithString:urlStr];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"post"]; //指定请求方式
        NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data3];
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSLog(@"原生错误error:%@",error);
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                                  //NSLog(@"设置默认卡%@",result);
                                                  if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                      
                                                      
                                                      
                                                      //dispatch_async(dispatch_get_main_queue(), ^{
                                                          [UIView animateWithDuration:0.5f animations:^{
                                                              [self.settingMoCardView setFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
                                                              
                                                              
                                                          } completion:^(BOOL finished) {
                                                              NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                                                              [userDefault setObject:_currentCardTypeNames forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                              [userDefault setObject:_currentCardNOs forKey:kUSERDEFAULT_USERCARDNO];
                                                              [userDefault synchronize];
                                                          }];
                                                          
                                                          [self dismissViewControllerAnimated:NO completion:nil];
                                                         
                                                      //});
                                                      
                                                      
                                                      
                                                  }else{
                                                      
                                                       //dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [_hud show:YES];
                                                          _hud.mode = MBProgressHUDModeText;
                                                          _hud.labelText = result[@"errMsg"];
                                                          _hud.labelFont = [UIFont systemFontOfSize:13];
                                                          [_hud hide:YES afterDelay:1];
                                                      //});
                                                  }
                                                  
                                              }
                                          }
                                          else{
                                              //请求有错误
                                              //dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = REQUEST_ERROR_ZL;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:1];
                                              //});
                                              
                                          }
                                          
                                      }];
        
        [task resume];
    
    //});
}
#pragma end mark 注册后绑定会员卡 册方法  结束
#pragma 原生绑定会员卡 开始



#pragma end mark 原生绑定会员卡结束


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
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
    }];
}



- (void)bindCardAction{
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
        _hud.labelText = REQUEST_ERROR_ZL;
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
        _hud.labelText = @"手机号格式错误，请确认。";
        [_hud hide:YES afterDelay:2];
        return;
        
    }
    if ([self textField:_passwordView].text.length == 0) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请使用6-20个字母或数字。";
        [_hud hide:YES afterDelay:2];
        return;
        
        
    }

    
    __weak typeof(self) weakSelf = self;

    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"userId":[self textField:_accountView].text,@"password":[self textField:_passwordView].text}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"userId":[self textField:_accountView].text,
                            @"password":[self textField:_passwordView].text,
                            @"sign":signDic[@"sign"]
                            };
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    NSLog(@"加密后----：%@",ret2);
    //调用原生登录方法
    [self yuanShengLoginAcrionWithRet2:ret2];

}

#pragma mark 原生登录方法 开始

- (void) yuanShengLoginAcrionWithRet2:(NSString *)ret2{
    __weak typeof(self) weakSelf = self;
    //- (id)initWithTimeInterval:(NSTimeInterval)secs sinceDate:(NSDate *)refDate;
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",Login_URLString];
        NSURL * URL = [NSURL URLWithString:urlStr];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"post"]; //指定请求方式
        NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data3];
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSLog(@"原生错误error:%@",error);
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                   NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                                  if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                      
  
                                                      
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
                                                      
                                                      
                                                          [JPUSHService setTags:nil aliasInbackground:userDataDic[@"phone"]];
                                                      NSLog(@"登录方法中的nickName值为：%@",userDataDic[@"nickName"]);
                                                      if ([userDataDic[@"nickName"] isEqualToString:@""] || !userDataDic[@"nickName"]) {
                                                          [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERNAME ];
                                                          //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值phone为：%@",userDataDic[@"phone"]);
                                                      }
                                                      else{
                                                          [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME ];
                                                          //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值nickname为：%@",userDataDic[@"nickname"]);
                                                      }
                                                      
                                                      NSLog(@"accessToken====：%@",userDataDic[@"accessToken"]);
                                                      [userDefaults setObject:userDataDic[@"accessToken"] forKey:kUSERDEFAULT_ACCCESSTOKEN];
                                                      
                                                      [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERID ];
                                                      NSLog(@"userDataDic-----:%@",userDataDic[@"idcard"]);
                                                      if (userDataDic[@"idcard"]) {
                                                          [userDefaults setObject:userDataDic[@"idcard"] forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                                                      }
                                                      else{
                                                          [userDefaults setObject:@"" forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                                                      }
                                                      
                                                      //调用李佳认证接口
                                                      [self renZhengLiJiaWithPhone:userDataDic[@"phone"] withAccessToken:userDataDic[@"accessToken"]];
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

                                                              }];
                                                              //[weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                              
                                                          }
                                                          
                                                      }
                                                      
                                                  }else{
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [_hud show:YES];
                                                          _hud.mode = MBProgressHUDModeText;
                                                          _hud.labelText = result[@"errMsg"];
                                                          _hud.labelFont = [UIFont systemFontOfSize:13];
                                                          [_hud hide:YES afterDelay:1];
                                                      });
                                                  }
                                                  
                                              }
                                          }
                                          else{
                                          //请求有错误
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = REQUEST_ERROR_ZL;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:1];
                                              });
                                          
                                          }
                                          
                                      }];
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

        [task resume];

}
//调用 李佳重新认证接口
- (void)renZhengLiJiaWithPhone:(NSString *)phoneString withAccessToken:(NSString *) accessTokenStr{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSLog(@"accessToken编码前为：%@",accessTokenStr);
        NSString * accessTokenEncodeStr = [accessTokenStr URLEncodedString];
        NSString * urlPinJie = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=member&s=check_token&phone=%@&accessToken=%@",phoneString,accessTokenEncodeStr];
        //NSString *urlStr = [urlPinJie stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * urlStr = urlPinJie;
        NSLog(@"李佳的认证接口：%@",urlStr);
        NSURL * URL = [NSURL URLWithString:urlStr];
      
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"get"]; //指定请求方式
        //NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
        //[request setHTTPBody:data3];
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSString *resultString  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"李佳认证:%@,错误信息：%@",resultString,error);

                                          NSDate * date1 = [NSDate dateWithTimeIntervalSinceReferenceDate:1334322098];
                                          NSDate * date3 = [NSDate dateWithTimeIntervalSinceNow:1334322098];
                                          NSDate * date4 = [NSDate dateWithTimeIntervalSince1970:1334322098];
                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                                          [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                                          NSString * fuWuStirng1 = [dateFormatter stringFromDate:date1];
                                          NSString * fuWuStirng3 = [dateFormatter stringFromDate:date3];
                                          NSString * fuWuStirng4 = [dateFormatter stringFromDate:date4];
                                          NSLog(@"服务器的时间为;1---%@,3---%@,4----%@",fuWuStirng1,fuWuStirng3,fuWuStirng4);
                                          
                                          
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  
                                                  if (result && [result isKindOfClass:[NSDictionary class]]) {
                                                      if ([result[@"code"] isEqual:@0]) {
                                                          NSDictionary *data = result[@"data"];
                                                          
                                                          NSString *bbc_token = [data objectForKey:@"bbc_token"];
                                                          NSString *timestamp = data[@"timestamp"];
                                                          
                                                          NSDatezlModel * model1 = [NSDatezlModel shareDate];
                                                          model1.timeInterval =[timestamp integerValue];
                                                          model1.firstDate = [NSDate date];
                                                          [[NSUserDefaults standardUserDefaults]setObject:bbc_token forKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
                                                          
                                                      }
                                                  }
                                                  NSLog(@"%@",result);
                                                  
                                                  
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);

                                                  NSLog(@"李佳原生数据登录：++： %@",result);
                                                  NSDictionary * dataDic = result[@"data"];
                                                  
                                                  //单例方法获取 时间戳
                                                  NSDatezlModel * model1 = [NSDatezlModel sharedInstance];
                                                  //NSLog(@"model1地址：%p",model1);
                                                  //model1.timeInterval =1334322098;
                                                  //model1.firstDate = [NSDate date];
                                                  
                                                  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                                                  if (dataDic[@"bbc_token"]) {
                                                      [userDefaults setObject:dataDic[@"bbc_token"] forKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
                                                  }
                                                  if (dataDic[@"timestamp"]) {
                                                      //NSString * timeStr = [dataDic[@"timestamp"] doubleValue];
                                                      model1.timeInterval = (NSTimeInterval)[dataDic[@"timestamp"] doubleValue];
                                                      model1.firstDate = [NSDate date];
                                                      [userDefaults setObject:dataDic[@"timestamp"] forKey:KUSERDEFAULT_TIMEINTERVAR_LIJIA];
                                                  }

                                                  
                                                  
                                              }
                                          }
                                          else{
                                              //请求有错误
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = REQUEST_ERROR_ZL;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:1];
                                              });
                                              
                                          }
                                          
                                      }];
        [task resume];
}


#pragma end mark 原生登录方法  结束
#pragma mark 原生请求方法
/*
#pragma mark 原生注册方法 开始
- (void) yuanShengRegisterAcrionWithRet2:(NSString *)ret2{
    //GCD异步实现
    dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",Login_URLString];
        NSURL * URL = [NSURL URLWithString:urlStr];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"post"]; //指定请求方式
        NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data3];
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSLog(@"原生错误error:%@",error);
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                                  
                                                  
                                              }
                                          }
                                          else{
                                              //请求有错误
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = REQUEST_ERROR_ZL;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:1];
                                              });
                                              
                                          }
                                          
                                      }];
        
        [task resume];
    });
}
#pragma end mark 原生注册方法  结束
*/
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

    //不支持QQ
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        //_qqLoginBgView.hidden = YES;
        //_qqLoginButton.hidden = YES;
        
       // dispatch_async(dispatch_get_main_queue(), ^{
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"您还没有安装QQ";
            [_hud hide:YES afterDelay:2];
        //});
        
        //NSLog(@"不支持QQ");
        return;
    }
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
    
    //不支持微信
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        //_wxLoginBgView.hidden = YES;
        //NSLog(@"不支持微信");
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"您还没有安装微信";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
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
    
    //[self yuanShengThirdLoginAcrionWithRet2:ret];
    /*
    [[HFSServiceClient sharedClient] POST:ThirdLogin_URLString parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"第三方登录信息：%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        NSLog(@"error %@",error);
        [_hud hide:YES afterDelay:2];
    }];
    */
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSString *urlStr = [NSString stringWithFormat:@"%@",ThirdLogin_URLString];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    NSData *data3 = [ret dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data3];
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSLog(@"原生错误error:%@",error);
                                      
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              //JSON解析
                                              // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              //NSLog(@"error原生数据登录：++： %@",yuanDic);
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
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                              [_hud show:YES];
                                                              _hud.mode = MBProgressHUDModeText;
                                                              _hud.labelText = @"您还没有会员卡";
                                                              [_hud hide:YES afterDelay:2];
                                                              });
                                                          }
                                                          
                                                      }
                                                      
                                                      
                                                      
                                                  }
                                                  else{//如果没有调到绑定页面
                                                      NSLog(@"登录到绑定页");
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      BingPhoneZlViewController *vc = [[BingPhoneZlViewController alloc]init];
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
                                                      });
                                                  }
                                                  
                                              }
                                              else{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = result[@"errMsg"];
                                                  [_hud hide:YES afterDelay:2];
                                                  });
                                              }
                                              
                                          }
                                      }
                                      else{
                                          //请求有错误
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [_hud show:YES];
                                              _hud.mode = MBProgressHUDModeText;
                                              _hud.labelText = REQUEST_ERROR_ZL;
                                              _hud.labelFont = [UIFont systemFontOfSize:13];
                                              [_hud hide:YES afterDelay:1];
                                          });
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    //});

}

#pragma mark 第三方登录 原生
- (void) yuanShengThirdLoginAcrionWithRet2:(NSString *)ret2{
}

#pragma end mark 结束


#pragma mark- 发送验证码
//验证码按钮
- (IBAction)codeButtonAction:(id)sender {
    //http://app.matrojp.com/P2MLinkCenter/common/sendsms
    /*
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"";
    */
    _codeButton.enabled=NO;
    [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonGray_backgroundColor]];
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
        
        [self yuanShengYanZhengMaWithRet2:ret2];
        /*
        [[HFSServiceClient sharedClient]POST:PhoneIsRegisted_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"检测手机是否注册过：%@",result);
            */
        
    }else{
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"手机号格式错误，请确认。";
        [_hud hide:YES afterDelay:2];
    }

}
//发送验证码
-(void)getValidateCode{
    
    
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":[self textField:_rphoneView].text,@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
                                                                                
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            dispatch_async(dispatch_get_main_queue(), ^{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"验证码已发送";
            [_hud hide:YES afterDelay:2];
            });
            _endTime = 60;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
            _isFaSonging = YES;
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
            [userDefaults setObject:timeSp forKey:CODE_TIME_KEY];
            [self codeTimeCountdown];
                                                                                    
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = result[@"msg"];
                [_hud hide:YES afterDelay:2];
            });
        }
                                                                                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
        });
    }];
    
}
#pragma mark 原生发送验证码
- (void) yuanShengYanZhengMaWithRet2:(NSString *)ret2{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",PhoneIsRegisted_URLString];
        NSURL * URL = [NSURL URLWithString:urlStr];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"post"]; //指定请求方式
        NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data3];
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSLog(@"原生错误error:%@",error);
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                                  NSDictionary * phoneDicIs = result[@"data"];
                                                  if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",phoneDicIs[@"phoneIsRegister"]]]){//这不是我们的会员，可以用来注册
                                                      [self getValidateCode];//发验证码
                                                  }else{
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          _codeButton.enabled=YES;
                                                          [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonNormel_backgroundColor]];
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = @"您的手机号已注册，请登录。";
                                                      [_hud hide:YES afterDelay:2];
                                                      });
                                                  }
                                                  
                                                  
                                          }
                                          }
                                          else{
                                              //请求有错误
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  _codeButton.enabled=YES;
                                                  [_codeButton setBackgroundColor:[UIColor colorWithHexString:Main_ButtonNormel_backgroundColor]];
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = REQUEST_ERROR_ZL;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:1];
                                              });
                                              
                                          }
                                          
                                      }];
        
        [task resume];
    //});
}
#pragma end mark 原生发送验证码结束


#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    
    if ([textField isEqual:[self textField:_accountView]]) {
        _tableView.hidden = YES;
        _showmoreaccoutButton.selected = YES;
    }
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    /*
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    */
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
            [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
        }
        else{
            _codeButton.enabled = YES;
            [_codeButton setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
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
    cell.logininfoLabel.text = _accountArray[(_accountArray.count-1-indexPath.row)];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self textField:_accountView].text = _accountArray[(_accountArray.count-1-indexPath.row)];
    NSLog(@"点击了选择手机号单元格%@",_accountArray[(_accountArray.count-1-indexPath.row)]);
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

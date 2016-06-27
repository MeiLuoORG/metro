//
//  MNNModifyPasswordViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNModifyPasswordViewController.h"
#import "MNNNextStepViewController.h"
#import "HFSUtility.h"
#import "UIColor+HeinQi.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"

#define CODE_TIME_KEY @"CODE_TIME_KEY"
#define Phone_YANZHENGMA @"PHONE_YANGZHENGMA"

#define  kScreenWidth self.view.frame.size.width

@interface MNNModifyPasswordViewController () {
    UITextField *_phoneTextField;//手机号输入框
    UITextField *_verificationNumberTextField;//验证码输入框
    UIButton *_getVerificationCode;//获取验证码
    UIButton *_nextStep;//下一步
//    NSTimer *_timer;//定时器 控制再次获取验证码
    int residualTime;//设定每次获取验证码的时间间隔
    NSInteger _endTime;
    BOOL _isFaSonging;
    
    UIView *_promplabelview;//提示框
    
    UIView * _bkView;
    BOOL _isYESSms;
    UIButton * _closeButton;
}

@end

static NSString *phoneNum = @"";

@implementation MNNModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    residualTime = 6;
    _isFaSonging = NO;

    [self loadTopView];
    [self createView];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_bkView addGestureRecognizer:gesture];
    
    //UiTextField变化通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}
//Lock_xiugaimima锁     Profile_xiugaimima人    golden_button
- (void)textChangeAction:(id)sender{
    

        
        if (![_phoneTextField.text isEqualToString:@""] && [HFSUtility validateMobile:_phoneTextField.text]) {
            if (!_isFaSonging) {
                _getVerificationCode.enabled = YES;
                [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
            }

        }
        else{
            
            _getVerificationCode.enabled = NO;
            [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
        }
        
    
    NSLog(@"phoneTextField值为;%@+++verificationNumber值为：%@",_phoneTextField.text,_verificationNumberTextField.text);
    if (![_phoneTextField.text isEqualToString:@""] &&[HFSUtility validateMobile:_phoneTextField.text] && ![_verificationNumberTextField.text isEqualToString:@""]) {
        _nextStep.enabled = YES;
        [_nextStep setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
    }
    else{
        _nextStep.enabled = NO;
        [_nextStep setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    }

}


- (void)loadTopView{
    NavTopCommonImage * img = [[NavTopCommonImage alloc]initWithTitle:@"重置密码"];
    [img loadLeftBackButtonwith:0];
    [img backButtonAction:^(BOOL succes) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:img];
    
    _bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SIZE_WIDTH, SIZE_HEIGHT)];
    [self.view addSubview:_bkView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //短信倒计时
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
    NSString * userPhone = [userDefaults stringForKey:Phone_YANZHENGMA];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
    if (timeSp) {
        _endTime = 60 - ([timeSp integerValue] - [tempTime integerValue]);
    }
    if (!tempTime || _endTime> 60) {
        
        //if (![userPhone isEqualToString:@""]) {
            //_getVerificationCode.enabled = YES;
            _endTime = 0;
        //}
        //_getVerificationCode.enabled = NO;
    }else{
        _getVerificationCode.enabled = NO;
    }
    /*
    if (![userPhone isEqualToString:@""]) {
        _phoneTextField.text = userPhone;
    }
*/
    [self codeTimeCountdown];
}

- (void)tap {
    [_phoneTextField resignFirstResponder];
    [_verificationNumberTextField resignFirstResponder];
}

#pragma mark 创建视图
- (void)createView {
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, (kScreenWidth-120)/2, 20)];
    lable1.text = @"验证身份";
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
    lable1.font = [UIFont systemFontOfSize:15];
    //[_bkView addSubview:lable1];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+80, 30, (kScreenWidth-120)/2, 20)];
    lable2.text = @"修改密码";
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor lightGrayColor];
    lable2.font = [UIFont systemFontOfSize:12];
    //[_bkView addSubview:lable2];
    //圆圈数字
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 20, 20)];
    label3.layer.cornerRadius = 10;
    label3.layer.masksToBounds = YES;
    label3.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label3.font = [UIFont systemFontOfSize:20];
    label3.text = @"1";
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
   // [_bkView addSubview:label3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+90, 32, 15, 15)];
    label4.layer.cornerRadius = 7.5;
    label4.layer.masksToBounds = YES;
    label4.backgroundColor = [UIColor lightGrayColor];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = @"2";
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentCenter;
    //[_bkView addSubview:label4];
    
    
    //[self createlableWithRect:CGRectMake(10, 79, kScreenWidth-20, 1)];
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(22, 42, kScreenWidth-44, 41)];
    _phoneTextField.placeholder = @"手机号";
    _phoneTextField.delegate = self;
    _phoneTextField.borderStyle = UITextBorderStyleNone;
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"Profile_xiugaimima"];
    //[_bkView addSubview:imageView1];
    //_phoneTextField.clearsOnBeginEditing = YES;
    _phoneTextField.font = [UIFont systemFontOfSize:15.0f];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.layer.cornerRadius = 4.0f;
    _phoneTextField.layer.borderWidth = 1.0f;
    _phoneTextField.layer.masksToBounds = YES;
    _phoneTextField.delegate = self;
    _phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //_phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 0)];
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    //[_phoneTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_bkView addSubview:_phoneTextField];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setFrame:CGRectMake(SIZE_WIDTH-55, CGRectGetMinY(_phoneTextField.frame), 30, 22)];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"close-2"] forState:UIControlStateNormal];
    //[_closeButton setImage:[UIImage imageNamed:@"close-2"] forState:UIControlStateNormal];
    [_bkView addSubview:_closeButton];
    _closeButton.hidden = YES;
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_phoneTextField);
        make.centerX.mas_equalTo(_bkView.mas_right).offset(-45);
    }];
    
    //[self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_phoneTextField.frame), kScreenWidth-20, 1)];
    _verificationNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_phoneTextField.frame)+29, kScreenWidth-160, 41)];
    _verificationNumberTextField.layer.cornerRadius = 4.0f;
    _verificationNumberTextField.layer.borderWidth = 1.0f;
    _verificationNumberTextField.layer.masksToBounds = YES;
    _verificationNumberTextField.delegate = self;
    _verificationNumberTextField.font = [UIFont systemFontOfSize:15.0f];
    _verificationNumberTextField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    _verificationNumberTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 0)];
    _verificationNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _verificationNumberTextField.placeholder = @"验证码";
    _verificationNumberTextField.borderStyle = UITextBorderStyleNone;
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_phoneTextField.frame)+15, 20, 20)];
    imageView2.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    //[_bkView addSubview:imageView2];
    _verificationNumberTextField.clearsOnBeginEditing = YES;
    _verificationNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    //[_verificationNumberTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_bkView addSubview:_verificationNumberTextField];
   
    
    _getVerificationCode = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-144, CGRectGetMaxY(_phoneTextField.frame)+29, 122, 41)];
    _getVerificationCode.tag = 10000;
    //_getVerificationCode.layer.cornerRadius = 4.0f;
    //_getVerificationCode.layer.borderWidth = 1.0f;
    _getVerificationCode.layer.masksToBounds = YES;
    //_getVerificationCode.font = [UIFont systemFontOfSize:12.0f];
   // _getVerificationCode.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    //[_getVerificationCode setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    _getVerificationCode.enabled = NO;
    [_getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerificationCode.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_getVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getVerificationCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_getVerificationCode.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0,4.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _getVerificationCode.bounds;
    maskLayer2.path = maskPath2.CGPath;
    //maskLayer2.fillColor = grayColors.CGColor;
    //maskLayer.strokeColor = grayColors.CGColor;
    
    //_getVerificationCode.layer.borderColor = grayColors.CGColor;
    _getVerificationCode.layer.mask = maskLayer2;
    
    [_bkView addSubview:_getVerificationCode];
    
    //[self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_verificationNumberTextField.frame)+5, kScreenWidth-20, 1)];
    
    _nextStep = [[UIButton alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_verificationNumberTextField.frame)+60, kScreenWidth-44, 42)];
    _nextStep.tag = 10001;
    _nextStep.layer.cornerRadius = 4.0f;
    //_getVerificationCode.layer.borderWidth = 1.0f;
    _nextStep.layer.masksToBounds = YES;
    //[_nextStep setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStep setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    _nextStep.enabled = NO;
    [_nextStep addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bkView addSubview:_nextStep];
}
- (void)createlableWithRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0.4;
    [_bkView addSubview:label];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{


    
    
    return YES;
}

- (void)closeButtonAction:(UIButton *)sender{
    _phoneTextField.text = @"";

    if (![_phoneTextField.text isEqualToString:@""] && [HFSUtility validateMobile:_phoneTextField.text]) {
        _getVerificationCode.enabled = YES;
        [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
    }
    else{
        
        _getVerificationCode.enabled = NO;
        [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    }
    
    
    NSLog(@"phoneTextField值为;%@+++verificationNumber值为：%@",_phoneTextField.text,_verificationNumberTextField.text);
    if (![_phoneTextField.text isEqualToString:@""] &&[HFSUtility validateMobile:_phoneTextField.text] && ![_verificationNumberTextField.text isEqualToString:@""]) {
        _nextStep.enabled = YES;
        [_nextStep setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
    }
    else{
        _nextStep.enabled = NO;
        [_nextStep setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    }
}

#pragma mark  验证码倒计时
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
                
                if ([HFSUtility validateMobile:_phoneTextField.text]) {
                    _getVerificationCode.enabled=YES;
                    [_getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [_getVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _isFaSonging = NO;
                    
                    
                    
                    if (_getVerificationCode.isEnabled) {
                        [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
                    }
                    else{
                        [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
                    }
                    //[_getVerificationCode setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                    //_getVerificationCode.backgroundColor = [UIColor clearColor];
                    _getVerificationCode.layer.borderWidth = 1.0f;
                    _getVerificationCode.layer.borderColor = [UIColor clearColor].CGColor;
                }
                else{
                    _getVerificationCode.enabled=NO;
                    [_getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [_getVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _isFaSonging = NO;
                    
                    
                    
                    if (_getVerificationCode.isEnabled) {
                        [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
                    }
                    else{
                        [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
                    }
                    //[_getVerificationCode setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                    //_getVerificationCode.backgroundColor = [UIColor clearColor];
                    _getVerificationCode.layer.borderWidth = 1.0f;
                    _getVerificationCode.layer.borderColor = [UIColor clearColor].CGColor;
                
                
                }
               
                
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                //NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
                [userDefaults removeObjectForKey:CODE_TIME_KEY];
                [userDefaults removeObjectForKey:Phone_YANZHENGMA];
                /*
                [userDefaults setObject:timeSp forKey:CODE_TIME_KEY];
                [userDefaults setObject:phoneNum forKey:Phone_YANZHENGMA];
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
                _isFaSonging = YES;
                //设置界面的按钮显示 根据自己需求设置
                _getVerificationCode.enabled=NO;
                [_getVerificationCode setTitle:strTime forState:UIControlStateNormal];
                [_getVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
                //[_getVerificationCode setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
                //_getVerificationCode.backgroundColor = [UIColor clearColor];
               // _getVerificationCode.layer.borderWidth = 1.0f;
               // _getVerificationCode.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)buttonAction:(UIButton *)button {
    //收回键盘
    [_phoneTextField resignFirstResponder];
    [_verificationNumberTextField resignFirstResponder];

#pragma mark 获取验证码
    if (button.tag == 10000) {
        phoneNum = _phoneTextField.text;
        if ([@"" isEqualToString: _phoneTextField.text]) {
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            NSString  *errStr = @"手机号格式错误，请确认";
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = errStr;
            [_hud hide:YES afterDelay:2];
            return;
        }
        if (![HFSUtility validateMobile:_phoneTextField.text]) {
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
           NSString  *errStr = @"手机号格式错误，请确认";
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = errStr;
            [_hud hide:YES afterDelay:2];
            return;
        }
        _getVerificationCode.enabled = NO;
        [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
        
        [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":phoneNum,@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"发送验证码：%@",result);
            if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
                _hud = [[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:_hud];
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"验证码已发送";
                [_hud hide:YES afterDelay:1];
                _endTime = 60;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
                
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
                [userDefaults setObject:timeSp forKey:CODE_TIME_KEY];
                [userDefaults setObject:phoneNum forKey:Phone_YANZHENGMA];
                
                [self codeTimeCountdown];
                
            }else{
                _getVerificationCode.enabled = YES;
                [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
                _hud = [[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:_hud];
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = result[@"msg"];
                [_hud hide:YES afterDelay:2];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _getVerificationCode.enabled = YES;
            [_getVerificationCode setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = REQUEST_ERROR_ZL;
            [_hud hide:YES afterDelay:2];
        }];
    
    }
    //下一步
    if (button.tag == 10001) {
#pragma mark 校验验证码
        if (![self canRegister]) {
            return;
        }
       
        if(_verificationNumberTextField.text.length != 4 || !(phoneNum.length>0)){
           NSString   *errStr = @"验证码错误,请确认";
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = errStr;
            [_hud hide:YES afterDelay:2];
            return;
        }
        //校验验证码
         [self checkSMS];

        //[self.navigationController pushViewController:nextStepVC animated:YES];
    }
}


-(BOOL)canRegister{
    NSString *errStr = nil;
    if ([@"" isEqualToString: _phoneTextField.text]) {
        errStr = @"手机号格式错误，请确认。";
    }
    else if (![HFSUtility validateMobile:_phoneTextField.text]) {
        errStr = @"手机号格式错误，请确认。";
    }else if (_verificationNumberTextField.text.length != 4){
        errStr = @"验证码错误,请确认";
    }
    else{
        errStr = nil;
    }
    
    if (errStr) {
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = errStr;
        [_hud hide:YES afterDelay:2];
        
        return NO;
    }
    return YES;
}

- (NSString* )checkSMS{
    NSString *  errStr;
    __weak __typeof(&*self)weakSelf =self;
    //http://app.matrojp.com/P2MLinkCenter/common/checksms
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/checksms" parameters:@{@"mphone":phoneNum,@"vcode":_verificationNumberTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            /*
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"验证码已发送，请注意查收";
            [_hud hide:YES afterDelay:2];
            _endTime = 60;
            [self codeTimeCountdown];
            */
            _isYESSms = YES;
            
            self.hidesBottomBarWhenPushed = YES;
            
            MNNNextStepViewController *nextStepVC = [MNNNextStepViewController new];
            [nextStepVC backDismissBlockAction:^(BOOL success) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            nextStepVC.vcode = _verificationNumberTextField.text;
            nextStepVC.phoneNum = phoneNum;
            [weakSelf presentViewController:nextStepVC animated:NO completion:nil];
            
        }else{
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            _isYESSms = NO;
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"msg"];
            [_hud hide:YES afterDelay:2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        _isYESSms = NO;
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        
        _hud.labelText = REQUEST_ERROR_ZL;
        
        [_hud hide:YES afterDelay:2];
    }];

    
    
    
    return errStr;
}

- (void)popView {
    self.hidesBottomBarWhenPushed = YES;
    MNNNextStepViewController *nextStepVC = [MNNNextStepViewController new];
    nextStepVC.vcode = _verificationNumberTextField.text;
    [self.navigationController pushViewController:nextStepVC animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if ([textField isEqual:_phoneTextField]) {
        _closeButton.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if ([textField isEqual:_phoneTextField]) {
        _closeButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

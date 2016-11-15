//
//  BingPhoneZlViewController.m
//  Matro
//
//  Created by lang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "BingPhoneZlViewController.h"
#import "YMLeftImageField.h"
#import "Masonry.h"
#import "HFSServiceClient.h"
#import "YMPhoneCondeButton.h"
#import "HFSUtility.h"
#import <MagicalRecord/MagicalRecord.h>
#import "JPUSHService.h"


@interface BingPhoneZlViewController ()
@property (strong, nonatomic) YMLeftImageField *phoneField;
@property (strong, nonatomic) YMLeftImageField *codeField;
@property (strong, nonatomic) UIButton *subCodeBtn;
@property (strong, nonatomic) UIButton *bindBtn;
@property (nonatomic,strong)YMLeftImageField *passField;
@property (nonatomic,strong)YMLeftImageField *rPassField;

@property (strong, nonatomic) NSLayoutConstraint *bindConstraint;



@end


static BOOL isPass = NO;
#define CODE_TIME_KEY @"CODE_TIME_KEY"


@implementation BingPhoneZlViewController{
    
    NSManagedObjectContext *_context;
    int residualTime;//设定每次获取验证码的时间间隔
    NSInteger _endTime;
    BOOL _isFaSonging;
    NSString * _currentCardNOs;
    
    NSString * _loginPasswordString;
    NSString * _registerPasswordString;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.vipCardArray = [NSMutableArray new];
    //短信倒计时
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
    //NSString * userPhone = [userDefaults stringForKey:Phone_YANZHENGMA];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
    if (timeSp) {
        _endTime = 60 - ([timeSp integerValue] - [tempTime integerValue]);
    }
    if (!tempTime || _endTime> 60) {
        
        //if (![userPhone isEqualToString:@""]) {
        //self.subCodeBtn.enabled = YES;
        _endTime = 0;
        //}
        //self.subCodeBtn.enabled = NO;
    }else{
        self.subCodeBtn.enabled = NO;
    }
    /*
     if (![userPhone isEqualToString:@""]) {
     _phoneTextField.text = userPhone;
     }
     */
    [self codeTimeCountdown];
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
                
                if ([HFSUtility validateMobile:self.phoneField.text]) {
                    self.subCodeBtn.enabled=YES;
                    [self.subCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [self.subCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _isFaSonging = NO;
                    
                    
                    
                    if (self.subCodeBtn.isEnabled) {
                        [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
                    }
                    else{
                        [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
                    }
                    //[self.subCodeBtn setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                    //self.subCodeBtn.backgroundColor = [UIColor clearColor];
                    self.subCodeBtn.layer.borderWidth = 1.0f;
                    self.subCodeBtn.layer.borderColor = [UIColor clearColor].CGColor;
                }
                else{
                    self.subCodeBtn.enabled=NO;
                    [self.subCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [self.subCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _isFaSonging = NO;
                    
                    
                    
                    if (self.subCodeBtn.isEnabled) {
                        [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
                    }
                    else{
                        [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
                    }
                    //[self.subCodeBtn setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                    //self.subCodeBtn.backgroundColor = [UIColor clearColor];
                    self.subCodeBtn.layer.borderWidth = 1.0f;
                    self.subCodeBtn.layer.borderColor = [UIColor clearColor].CGColor;
                    
                    
                }
                
                
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                //NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
                [userDefaults removeObjectForKey:CODE_TIME_KEY];
                //[userDefaults removeObjectForKey:Phone_YANZHENGMA];
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
                self.subCodeBtn.enabled=NO;
                [self.subCodeBtn setTitle:strTime forState:UIControlStateNormal];
                [self.subCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
                //[self.subCodeBtn setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
                //self.subCodeBtn.backgroundColor = [UIColor clearColor];
                // self.subCodeBtn.layer.borderWidth = 1.0f;
                // self.subCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NavTopCommonImage * topImage = [[NavTopCommonImage alloc]initWithTitle:@"账号绑定"];
    [topImage loadLeftBackButtonwith:0];
    [topImage backButtonAction:^(BOOL succes) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:topImage];
    //
    //self.bkView.backgroundColor = [HFSUtility hexStringToColor:Main_BackgroundColor];
    self.title = @"账号绑定";
    self.view.backgroundColor = [UIColor whiteColor];
    self.bkView = [[UIView alloc]init];
    [self.bkView setFrame:CGRectMake(0, 64, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64)];
    [self.view insertSubview:self.bkView atIndex:0];
    self.bkView.backgroundColor = [UIColor whiteColor];
    /*
     [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
     
     make.top.offset(-40.0f);
     
     }];
     */
    _context = [NSManagedObjectContext MR_defaultContext];
    
    NSLog(@"self.phoneField.frame.orign.x.y分别为：%g----%g",self.phoneField.frame.origin.x,self.phoneField.frame.origin.y);
    /*
     [self.view bringSubviewToFront:self.bkView];
     [self.bkView addSubview:self.phoneField];
     [self.bkView addSubview:self.codeField];
     [self.bkView addSubview:self.subCodeBtn];
     */
    self.phoneField = [[YMLeftImageField alloc]initWithFrame:CGRectMake(22, 29+64, SIZE_WIDTH-44, 41)];
    
    self.phoneField.placeholder = @"手机号";
    self.phoneField.delegate = self;
    self.phoneField.layer.borderWidth = 1.f;
    self.phoneField.layer.cornerRadius = 4.0f;
    self.phoneField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.phoneField.layer.masksToBounds = YES;
    self.phoneField.font = [UIFont systemFontOfSize:15.0f];
    //self.phoneField.leftImgName = @"Profile_gray";
    self.phoneField.leftOffset = -10.f;
    self.phoneField.rightOffset = 5.f;
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneField];
    
    
    self.codeField = [[YMLeftImageField alloc]initWithFrame:CGRectMake(22, 99+64, SIZE_WIDTH-44-85, 41)];
    self.codeField.layer.borderWidth = 1.f;
    self.codeField.delegate = self;
    self.codeField.layer.cornerRadius = 4.0f;
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.codeField.layer.masksToBounds = YES;
    self.codeField.placeholder = @"验证码";
    self.codeField.leftOffset = -10.f;
    self.codeField.rightOffset = 5.f;
    self.codeField.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:self.codeField];
    // self.codeField.leftImgName = @"Lock_gray";
    //self.subCodeBtn.layer.borderWidth = 1.f;
    //self.subCodeBtn.layer.cornerRadius = 4.0f;
    
    self.subCodeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subCodeBtn setFrame:CGRectMake(SIZE_WIDTH-22-89, 99+64, 89, 41)];
    [self.subCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //self.subCodeBtn.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.subCodeBtn.layer.masksToBounds = YES;
    
    [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    self.subCodeBtn.enabled = NO;
    self.subCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.subCodeBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0,4.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.subCodeBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    //maskLayer2.fillColor = grayColors.CGColor;
    //maskLayer.strokeColor = grayColors.CGColor;
    UIColor * grayColors = [HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor];
    self.subCodeBtn.layer.borderColor = grayColors.CGColor;
    self.subCodeBtn.layer.mask = maskLayer2;
    [self.subCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.subCodeBtn addTarget:self action:@selector(subCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.subCodeBtn];
    
 
    self.bindBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bindBtn.enabled = NO;
    self.bindBtn.layer.cornerRadius = 4.0f;
    self.bindBtn.layer.masksToBounds = YES;
    [self.bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bindBtn setTitle:@"绑 定" forState:UIControlStateNormal];
    [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    [self.bindBtn addTarget:self action:@selector(bindClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bindBtn];
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(42.0f);
        make.width.mas_equalTo(SIZE_WIDTH-44);
        make.top.mas_equalTo(self.subCodeBtn.mas_bottom).offset(49.0f);
    }];
    
    
    _passField = ({
        YMLeftImageField *filed = [[YMLeftImageField alloc]initWithFrame:CGRectMake(22, 0, SIZE_WIDTH-44, 41)];
        filed.delegate = self;
        filed.secureTextEntry = YES;
        filed.placeholder = @"密码(6-20位字母或数字)";
        filed.leftOffset = -10.f;
        filed.rightOffset = 5.f;
        //filed.leftImgName = @"Lock_gray";
        filed.font = [UIFont systemFontOfSize:15];
        filed.layer.borderWidth = 1.f;
        filed.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
        filed.layer.masksToBounds = YES;
        filed.layer.cornerRadius = 4.0f;
        filed;
    });
    
    _rPassField = ({
        YMLeftImageField *filed = [[YMLeftImageField alloc]initWithFrame:CGRectMake(22, 0, SIZE_WIDTH-44, 41)];
        filed.delegate = self;
        filed.secureTextEntry = YES;
        filed.placeholder = @"确认密码";
        filed.leftOffset = -10.f;
        filed.rightOffset = 5.f;
        //filed.leftImgName = @"Lock_gray";
        filed.font = [UIFont systemFontOfSize:15];
        filed.layer.borderWidth = 1.f;
        filed.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
        filed.layer.masksToBounds = YES;
        filed.layer.cornerRadius = 4.0f;
        filed;
    });
    [self.view addSubview:self.passField];
    [self.view addSubview:self.rPassField];
    self.passField.hidden = YES;
    self.rPassField.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)textChangeAction:(id)sender{
    
    
    
    
    if (self.phoneField.text.length > 0 && [HFSUtility validateMobile:self.phoneField.text]) {
        if (!_isFaSonging) {
            self.subCodeBtn.enabled = YES;
            [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
        }
        else{
        
        
        }

        
    }else{
        self.subCodeBtn.enabled = NO;
        [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
        
    }
    
    if (isPass) {
        if (self.phoneField.text.length > 0 && self.codeField.text.length>0 && self.passField.text.length > 0 &&self.rPassField.text.length > 0 && [HFSUtility validateMobile:self.phoneField.text]) {
            self.bindBtn.enabled = YES;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
        }
        else{
            self.bindBtn.enabled = NO;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
            
        }
        
    }
    else {
        if (self.phoneField.text.length > 0 && self.codeField.text.length>0 && [HFSUtility validateMobile:self.phoneField.text]) {
            self.bindBtn.enabled = YES;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
        }
        else{
            self.bindBtn.enabled = NO;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
            
        }
        
    }
    
}

- (void)subCodeClick:(UIButton *)sender {
    self.subCodeBtn.enabled=NO;
    [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    [self.subCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.subCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":_phoneField.text?:@"",@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            
             [_hud show:YES];
             _hud.mode = MBProgressHUDModeText;
             _hud.labelText = @"验证码已发送";
             [_hud hide:YES afterDelay:1];
            //YMPhoneCondeButton *btn = (UIButton *)sender;
            
            _endTime = 60;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
            
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
            [userDefaults setObject:timeSp forKey:CODE_TIME_KEY];
            
            [self codeTimeCountdown];
            
            //[btn startUpTimer];
            
        }else{
            self.subCodeBtn.enabled=YES;
            [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"msg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.subCodeBtn.enabled=YES;
        [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
    }];
    
    /*zhoulu*/
    [self panDuanIsRegistered];
    
}

- (void)panDuanIsRegistered{
    
    if ([HFSUtility validateMobile:_phoneField.text]) {
        
        NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,
                                                       @"phone":_phoneField.text
                                                       }];
        NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                @"phone":_phoneField.text,
                                @"sign":signDic[@"sign"]
                                };
        NSData *data2 = [HFSUtility RSADicToData:dic2];
        NSString *ret2 = base64_encode_data(data2);
        
        [self yuanShengYanZhengMaWithRet2:ret2];
        /*
         [[HFSServiceClient sharedClient]POST:PhoneIsRegisted_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *result = (NSDictionary *)responseObject;
         NSLog(@"检测手机是否注册过：%@",result);
         NSDictionary * phoneDicIs = result[@"data"];
         if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",phoneDicIs[@"phoneIsRegister"]]]){//这不是我们的会员，可以用来注册
         isPass = YES;
         [self showPassfield];
         }else{
         /*
         [_hud show:YES];
         _hud.mode = MBProgressHUDModeText;
         _hud.labelText = @"已经是我们的会员";
         [_hud hide:YES afterDelay:2];
         *//*
            isPass = NO;
            }
            
            /*
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = REQUEST_ERROR_ZL;
            [_hud hide:YES afterDelay:2];
            // NSLog(@"验证码错误信息：%@",error);
            }];
            */
    }else{
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"手机号格式错误，请确认。";
        [_hud hide:YES afterDelay:2];
    }
    
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
                                                  //[self getValidateCode];//发验证码
                                                  isPass = YES;
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [self showPassfield];
                                                  });
                                              }else{
                                                  isPass = NO;
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
#pragma end mark 原生发送验证码结束



- (void)showPassfield{

    self.passField.hidden = NO;
    self.rPassField.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        //self.bindConstraint.constant = 191;
        [self.passField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeField.mas_bottom).offset(29);
            make.left.right.mas_equalTo(self.phoneField);
            make.height.mas_equalTo(41);
        }];
        [self.rPassField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.passField.mas_bottom).offset(29);
            make.left.right.mas_equalTo(self.phoneField);
            make.height.mas_equalTo(41);
        }];
        [self.bindBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(42.0f);
            make.width.mas_equalTo(SIZE_WIDTH-44);
            make.top.mas_equalTo(self.subCodeBtn.mas_bottom).offset(169.0f);
        }];

        
    }];
}



- (void)bindClick:(id)sender {
    
    __weak typeof(self)  weakSelf = self;
    if (self.phoneField.text.length == 0 ||
        self.codeField.text.length == 0) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入完整信息";
        [_hud hide:YES afterDelay:2];
        return;
        
    }
    if (isPass) {
        if (self.passField.text.length < 6 || self.passField.text.length >20 ) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请使用6-20位字母或数字。";
            [_hud hide:YES afterDelay:2];
            return;
        }
        
        if (![self.passField.text isEqualToString:self.rPassField.text]) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"两次密码输入不一致，请确认。";
            [_hud hide:YES afterDelay:2];
            return;
        }
        if (![ZhengZePanDuan checkPasswordMeiLuo:self.passField.text]) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请使用6-20位字母或数字。";
            [_hud hide:YES afterDelay:2];
            return;
        }
    }
    //是否已经是线上用户
    NSString * isRegister;
    NSDictionary * dicInfo = [[NSDictionary alloc]init];
    NSDictionary * dicInfo2 = [[NSDictionary alloc]init];
    if (isPass) {
        //不是线上用户 新用户
        isRegister = @"1";
        
        dicInfo = @{@"appSecret":APP_Secrect_ZHOU,
                    @"openId":self.open_id,
                    @"phone":self.phoneField.text,
                    @"nickName":self.nickname,
                    @"imgUrl":self.imgUrl,
                    @"type":self.type,
                    @"vCode":self.codeField.text,
                    @"phoneIsRegister":isRegister,
                    @"password":self.passField.text
                    };
        NSDictionary * signDic = [HFSUtility SIGNDic:dicInfo];
        dicInfo2 = @{@"appId":APP_ID_ZHOU,
                     @"openId":self.open_id,
                     @"phone":self.phoneField.text,
                     @"nickName":self.nickname,
                     @"imgUrl":self.imgUrl,
                     @"type":self.type,
                     @"vCode":self.codeField.text,
                     @"phoneIsRegister":isRegister,
                     @"password":self.passField.text,
                     @"sign":signDic[@"sign"]
                     };
        _registerPasswordString = self.passField.text;
        
    }else{
        //老用户
        isRegister = @"0";
        NSLog(@"-----openId--%@,phone:%@,nickName:%@,imgUrl:%@,type:%@,vCode:%@",self.open_id,self.phoneField.text,self.nickname,self.imgUrl,self.type,self.codeField.text);
        dicInfo =@{@"appSecret":APP_Secrect_ZHOU,
                   @"openId":self.open_id,
                   @"phone":self.phoneField.text,
                   @"nickName":self.nickname,
                   @"imgUrl":self.imgUrl,
                   @"type":self.type,
                   @"vCode":self.codeField.text,
                   @"phoneIsRegister":isRegister
                   };
        NSDictionary * signDic = [HFSUtility SIGNDic:dicInfo];
        dicInfo2 = @{@"appId":APP_ID_ZHOU,
                     @"openId":self.open_id,
                     @"phone":self.phoneField.text,
                     @"nickName":self.nickname,
                     @"imgUrl":self.imgUrl,
                     @"type":self.type,
                     @"vCode":self.codeField.text,
                     @"phoneIsRegister":isRegister,
                     @"sign":signDic[@"sign"]
                     };
    }
    
    
    // NSDictionary * signDic = [HFSUtility SIGNDic:dicInfo];
    /*
     NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
     @"phone":_phoneField.text,
     @"sign":signDic[@"sign"]
     };
     */
    //[dicInfo2 setValue:signDic[@"sign"] forKey:@"sign"];
    
    NSData *data2 = [HFSUtility RSADicToData:dicInfo2];
    NSString *ret2 = base64_encode_data(data2);
    [self yuanShengBingPhoneAcrionWithRet2:ret2];
    /*
     [[HFSServiceClient sharedClient]POST:ThirdLogin_BindPhone_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSDictionary *result = (NSDictionary *)responseObject;
     NSLog(@"绑定手机号：%@",result);
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [_hud show:YES];
     _hud.mode = MBProgressHUDModeText;
     _hud.labelText = REQUEST_ERROR_ZL;
     [_hud hide:YES afterDelay:2];
     // NSLog(@"验证码错误信息：%@",error);
     }];
     */
}

#pragma 绑定手机号 原生
#pragma mark 原生注册方法 开始
- (void) yuanShengBingPhoneAcrionWithRet2:(NSString *)ret2{
    __weak typeof(self)  weakSelf = self;
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSString *urlStr = [NSString stringWithFormat:@"%@",ThirdLogin_BindPhone_URLString];
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
                                              NSLog(@"error第三方登录绑定手机号登录：++： %@",result);
                                              NSDictionary * userDic = result[@"data"];
                                              
                                              if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){//绑定成功
                                                  
                                                  
                                                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                  //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                                                  [userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO];
                                                  if (userDic[@"img"] && ![@"" isEqualToString:userDic[@"img"]]) {
                                                      [userDefaults setObject:userDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR];
                                                      
                                                  }
                                                  if (userDic[@"idcard"]) {
                                                      [userDefaults setObject:userDic[@"idcard"] forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                                                  }
                                                  else{
                                                      [userDefaults setObject:@"" forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                                                  }
                                                  [userDefaults setObject:userDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE];
                                                  [userDefaults setObject:userDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME];
                                                  if (userDic[@"nickName"]) {
                                                      [userDefaults setObject:userDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME];
                                                  }
                                                  else{
                                                      [userDefaults setObject:userDic[@"phone"] forKey:kUSERDEFAULT_USERNAME];
                                                  }
                                                  
                                                  [userDefaults setObject:userDic[@"phone"] forKey:kUSERDEFAULT_USERID];
                                                  
                                                  [userDefaults setObject:_registerPasswordString forKey:KUSERDEFAULT_PASSWORD_ZL];
                                                  
                                                  
                                                  [userDefaults setObject:userDic[@"accessToken"] forKey:kUSERDEFAULT_ACCCESSTOKEN];
                                                  
                                                  BOOL isDefault = NO;
                                                  if (userDic[@"vipCard"]) {
                                                      NSArray * vipCardARR = userDic[@"vipCard"];
                                                      if (vipCardARR.count == 1) {
                                                          //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                                                          //[userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
                                                          
                                                          for(NSDictionary * dics in vipCardARR) {
                                                              
                                                              if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",dics[@"isDefault"]]]){
                                                                  NSString * cardno = [NSString stringWithFormat:@"%@",dics[@"cardNo"]];
                                                                  [userDefaults setObject:cardno forKey:kUSERDEFAULT_USERCARDNO];
                                                                  if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil){
                                                                      NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                                                                      [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                                  }
                                                                  else{
                                                                      [userDefaults setObject:@"B2C会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                                      
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
                                                                  if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil){
                                                                      
                                                                      NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                                                                      [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                                  }
                                                                  else{
                                                                      [userDefaults setObject:@"B2C会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                                  }
                                                                  //[[userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"isDefault"]] forKey:kUSERDEFAULT_USERCARDNO];
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
                                                              
                                                                  NSLog(@"绑定会员卡的会员卡个数为：%ld",self.vipCardArray.count);
                                                              //dispatch_async(dispatch_get_main_queue(), ^{
                                                              //绑定会员卡
                                                                   [weakSelf loadSettingMoCardViewWithCardARR:self.vipCardArray withPhone:self.phoneField.text withCardNo:nil withAccessToken:userDic[@"accessToken"]];
                                                               //});
                                                          }
                                                      }
                                                      else if(vipCardARR.count < 1){
                                                          
                                                          [weakSelf dismissViewControllerAnimated:NO completion:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [_hud show:YES];
                                                                  _hud.mode = MBProgressHUDModeText;
                                                                  _hud.labelText = @"您还没有会员卡";
                                                                  [_hud hide:YES afterDelay:1];
                                                              });
                                                              [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
                                                              //weakSelf.backBlock(YES);
                                                          }];
                                                          
                                                      }
                                                      
                                                  }
                                                  else{
                                                      isDefault = YES;
                                                  }
                                                  
                                                  
                                                  //调用李佳认证接口
                                                  [self renZhengLiJiaWithPhone:userDic[@"phone"] withAccessToken:userDic[@"accessToken"]];
                                                  [userDefaults synchronize];
                                                  
                                                  /*
                                                   //保存登录账号下次使用
                                                   LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:userDic[@"phone"] inContext:_context];
                                                   if (!loginHistory) {
                                                   LoginHistory *loginHistory = [LoginHistory MR_createEntityInContext:_context];
                                                   loginHistory.loginkeyword = [self textField:_accountView].text;
                                                   [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                                                   //[self loadLoginHistory];
                                                   }];
                                                   }
                                                   */
                                                  /*
                                                   [_hud show:YES];
                                                   _hud.mode = MBProgressHUDModeText;
                                                   _hud.labelText = @"注册成功";
                                                   [_hud hide:YES afterDelay:2];
                                                   */
                                                  
                                                  if (isDefault) {
                                                      //[weakSelf dismissViewControllerAnimated:NO completion:nil];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                      [weakSelf dismissViewControllerAnimated:NO completion:^{
                                                          [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
                                                          //weakSelf.backBlock(YES);
                                                      }];
                                                       });
                                                  }
                                                  
                                                  
                                                  //[[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
                                                  
                                              }else{
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
#pragma end mark 原生注册方法  结束

#pragma end mark  绑定手机号 结束
- (void)renZhengLiJiaWithPhone:(NSString *)phoneString withAccessToken:(NSString *) accessTokenStr{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    //获取设备ID
    NSString *identifierForVendor = [JPUSHService registrationID];
    
    //NSString *identifierForAdvertising = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    NSLog(@"accessToken编码前为：%@",accessTokenStr);
    NSString * accessTokenEncodeStr = [accessTokenStr URLEncodedString];
    NSString *device_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemVer"];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"result"];
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    NSString *device_model = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicemodel"];
    NSString *screen = [[NSUserDefaults standardUserDefaults] objectForKey:@"bounds"];
   // NSString * urlPinJie = [NSString stringWithFormat:@"%@/api.php?m=member&s=check_token&phone=%@&accessToken=%@&device_id=%@&device_source=ios",ZHOULU_ML_BASE_URLString,phoneString,accessTokenEncodeStr,identifierForVendor];
    NSString * urlPinJie = [NSString stringWithFormat:@"%@/api.php?m=member&s=check_token&phone=%@&accessToken=%@&client_type=ios&device_id=%@&device_source=ios&device_version=%@&uuid=%@&device_network=%d&device_model=%@&device_screen=%@",ZHOULU_ML_BASE_URLString,phoneString,accessTokenEncodeStr,identifierForVendor,device_version,uuid,network.intValue,device_model,screen];
    
    NSString * urlStr = urlPinJie;
    //NSLog(@"李佳的认证接口：%@",urlStr);
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
                                              
                                              //NSLog(@"李佳原生数据登录：++： %@",result);
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
    
    //});
    
}

#pragma 返回Block
- (void)backBlocksAction:(BackBlocks)block{
    self.backBlock = block;
}

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
    NSLog(@"绑定手机号中绑定会员卡的会员卡数组个数为：%ld",cardARR.count);
    [self.settingMoCardView loadViews];
    [self.settingMoCardView bindButtonBlockAction:^(BOOL success) {
        if (self.settingMoCardView.cardNoString != nil && ![self.settingMoCardView.cardNoString isEqualToString:@""]) {
            
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            
            
            if (self.settingMoCardView.cardTypeName && ![self.settingMoCardView.cardTypeName isEqualToString:@""]) {
                [userDefault setObject:self.settingMoCardView.cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            }
            else{
                
                [userDefault setObject:@"B2C会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            }
            _currentCardNOs = self.settingMoCardView.cardNoString;
            
            [userDefault synchronize];
            
            [weakSelf loadBindCardViewwithPhone:phoneString withCardNo:self.settingMoCardView.cardNoString withAccessToken:accessTokenString];
        }
        else{
            VipCardModel * cardModel = (VipCardModel *)[cardARR objectAtIndex:0];
            
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            
            if (cardModel.cardTypeName && ![cardModel.cardTypeName isEqualToString:@""]) {
                [userDefault setObject:cardModel.cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            }
            else{
                
                [userDefault setObject:@"B2C会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            }
            _currentCardNOs = cardModel.cardNo;
            [userDefault synchronize];
            
            [weakSelf loadBindCardViewwithPhone:phoneString withCardNo:cardModel.cardNo withAccessToken:accessTokenString];
        }
        
        
    }];
    [self.view addSubview:self.settingMoCardView];
    
    [UIView animateWithDuration:0.50f animations:^{
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
#pragma mark TextField 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    
    
    return YES;
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
        
        [self yuanShengBingCardAcrionWithRet2:ret2];
        /*
        //@"vip/AuthUserInfo"
        [[HFSServiceClient sharedClient] POST:BindCard_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"设置默认卡%@",result);
            if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                
                [UIView animateWithDuration:0.50f animations:^{
                    [self.settingMoCardView setFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
                [self dismissViewControllerAnimated:NO completion:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
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
        */
        
    }
    
    
}

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
                                                  
                                                  
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                  [UIView animateWithDuration:0.5f animations:^{
                                                      [self.settingMoCardView setFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
                                                      
                                                      
                                                  } completion:^(BOOL finished) {
                                                      NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                                                      //[userDefault setObject:_currentCardTypeNames forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                      [userDefault setObject:_currentCardNOs forKey:kUSERDEFAULT_USERCARDNO];
                                                      [userDefault synchronize];
                                                  }];
                                                  
                                                  [self dismissViewControllerAnimated:NO completion:nil];
                                                  [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
                                                  });
                                                  
                                                  
                                                  
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
    
    [task resume];
    
    //});
}
#pragma end mark 注册后绑定会员卡 册方法  结束

#pragma end mark


@end

//
//  MNNNextStepViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNNextStepViewController.h"
#import "MNNManagementViewController.h"
#import "UIColor+HeinQi.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "HFSServiceClient.h"


#define kScreenWidth self.view.frame.size.width


@interface MNNNextStepViewController () {
    UITextField *_newPassword;
    UITextField *_confirmPassword;
    UIButton *_determine;
    UIView * _bkView;
}

@end

@implementation MNNNextStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_bkView addGestureRecognizer:gesture];

    [self loadTopView];
    [self createView];
    // Do any additional setup after loading the view.
    
}
//Lock_xiugaimima锁     Profile_xiugaimima人    golden_button
- (void)loadTopView{
    
    NavTopCommonImage * img = [[NavTopCommonImage alloc]initWithTitle:@"修改密码"];
    [img loadLeftBackButtonwith:0];
    [img backButtonAction:^(BOOL succes) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.view addSubview:img];
    
    _bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SIZE_WIDTH, SIZE_HEIGHT)];
    //_bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bkView];
}


//收回键盘
- (void)tap {
    [_newPassword resignFirstResponder];
    [_confirmPassword resignFirstResponder];
}

#pragma mark 创建视图
- (void)createView {
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, (kScreenWidth-120)/2, 20)];
    lable1.text = @"验证身份";
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
    lable1.font = [UIFont systemFontOfSize:15];
    [_bkView addSubview:lable1];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+80, 30, (kScreenWidth-120)/2, 20)];
    lable2.text = @"修改密码";
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
    lable2.font = [UIFont systemFontOfSize:15];
    [_bkView addSubview:lable2];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 20, 20)];
    label3.layer.cornerRadius = 10;
    label3.layer.masksToBounds = YES;
    label3.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label3.font = [UIFont systemFontOfSize:20];
    label3.text = @"1";
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    [_bkView addSubview:label3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+80, 30, 20, 20)];
    label4.layer.cornerRadius = 10;
    label4.layer.masksToBounds = YES;
    label4.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label4.font = [UIFont systemFontOfSize:20];
    label4.text = @"2";
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentCenter;
    [_bkView addSubview:label4];
    [self createlableWithRect:CGRectMake(10, 79, kScreenWidth-20, 1)];
    _newPassword = [[UITextField alloc] initWithFrame:CGRectMake(40, 90, kScreenWidth-50, 30)];
    _newPassword.placeholder = @"新密码";
    _newPassword.borderStyle = UITextBorderStyleNone;
    _newPassword.secureTextEntry = YES;
    [_newPassword setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 15, 20)];
    imageView1.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    [_bkView addSubview:imageView1];
    _newPassword.clearsOnBeginEditing = YES;
    _newPassword.keyboardType = UIKeyboardAppearanceDefault;
    [_bkView addSubview:_newPassword];
    [self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_newPassword.frame), kScreenWidth-20, 1)];
  
    _confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_newPassword.frame)+10, kScreenWidth-160, 30)];
    _confirmPassword.placeholder = @"确认新密码";
    _confirmPassword.borderStyle = UITextBorderStyleNone;
    _confirmPassword.secureTextEntry = YES;
    [_confirmPassword setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_newPassword.frame)+10, 15, 20)];
    imageView2.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    [_bkView addSubview:imageView2];
    _confirmPassword.clearsOnBeginEditing = YES;
    _confirmPassword.keyboardType = UIKeyboardAppearanceDefault;
    [_bkView addSubview:_confirmPassword];
    [self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_confirmPassword.frame), kScreenWidth-20, 1)];
    _determine = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-230, kScreenWidth-100, 30)];
    [_determine setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_determine setTitle:@"确定" forState:UIControlStateNormal];
    [_determine addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bkView addSubview:_determine];
}
- (void)createlableWithRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0.7;
    [_bkView addSubview:label];
}

#pragma mark 修改密码
- (void)buttonAction {
    __weak __typeof(&*self)weakSelf =self;
    [_newPassword resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    if ([_newPassword.text isEqualToString:@""]||[_confirmPassword.text isEqualToString:@""]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请将信息填写完整";
        [_hud hide:YES afterDelay:2];
    }
    else {
        if ([_newPassword.text isEqualToString:_confirmPassword.text]) {
            //{"appId": "test0002","phone":"18020260894","password":"654321","sign":$sign,"accessToken":$accessToken}
        /*zhoulu*/
            
        // 存储用户信息
        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
        NSString * accessToken = [userDefaults1 objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
        
            if (accessToken) {
                //accessToken存在
                //修改密码
                NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":_phoneNum?:@"",@"password":_newPassword.text}];
                NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                        @"phone":_phoneNum?:@"",
                                        @"password":_newPassword.text,
                                        @"sign":signDic[@"sign"],
                                        @"accessToken":accessToken
                                        };
                NSData *data2 = [HFSUtility RSADicToData:dic2];
                NSString *ret2 = base64_encode_data(data2);
                //@"vip/AuthUserInfo"
                [[HFSServiceClient sharedClient] POST:ForgetPassword_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *result = (NSDictionary *)responseObject;
                    NSLog(@"修改密码：%@",result);
                    if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = @"修改成功";
                        [_hud hide:YES afterDelay:2];
                        /*
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
                         
                         
                         if ([userDataDic[@"nickName"] isEqualToString:@""] || !userDataDic[@"nickName"]) {
                         [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERNAME ];
                         //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值phone为：%@",userDataDic[@"phone"]);
                         }
                         else{
                         [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME ];
                         //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值nickname为：%@",userDataDic[@"nickname"]);
                         }
                         
                         
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
                         
                         [weakSelf textField:_rrpasswordView].text = @"";
                         [weakSelf textField:_rphoneView].text = @"";
                         [weakSelf textField:_rcodeView].text = @"";
                         [weakSelf textField:_rpasswordView].text = @"";
                         
                         _loginTypeButton.selected = YES;
                         _loginTypeBgView.hidden = NO;
                         _registerTypeBgView.hidden = YES;
                         _registerTypeButton.selected = NO;
                         NSLog(@"注册成功");
                         */
                        [weakSelf dismissViewControllerAnimated:NO completion:^{
                            weakSelf.backBlock(YES);
                        }];
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
            

                
            }
            else{
                //accessToken 不存在
                //找回密码
                NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":_phoneNum?:@"",@"password":_newPassword.text}];
                NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                        @"phone":_phoneNum?:@"",
                                        @"password":_newPassword.text,
                                        @"sign":signDic[@"sign"]
                                        };
                NSData *data2 = [HFSUtility RSADicToData:dic2];
                NSString *ret2 = base64_encode_data(data2);
                //@"vip/AuthUserInfo"
                [[HFSServiceClient sharedClient] POST:ForgetPassword_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *result = (NSDictionary *)responseObject;
                    NSLog(@"忘记密码：%@",result);
                    if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = @"修改成功";
                        [_hud hide:YES afterDelay:2];
                        /*
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
                         
                         
                         if ([userDataDic[@"nickName"] isEqualToString:@""] || !userDataDic[@"nickName"]) {
                         [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERNAME ];
                         //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值phone为：%@",userDataDic[@"phone"]);
                         }
                         else{
                         [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME ];
                         //NSLog(@"登录方法中kUSERDEFAULT_USERNAME值nickname为：%@",userDataDic[@"nickname"]);
                         }
                         
                         
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
                         
                         [weakSelf textField:_rrpasswordView].text = @"";
                         [weakSelf textField:_rphoneView].text = @"";
                         [weakSelf textField:_rcodeView].text = @"";
                         [weakSelf textField:_rpasswordView].text = @"";
                         
                         _loginTypeButton.selected = YES;
                         _loginTypeBgView.hidden = NO;
                         _registerTypeBgView.hidden = YES;
                         _registerTypeButton.selected = NO;
                         NSLog(@"注册成功");
                         */
                        [weakSelf dismissViewControllerAnimated:NO completion:^{
                            weakSelf.backBlock(YES);
                        }];
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
            }
            

        
        /*
        if ([_newPassword.text isEqualToString:_confirmPassword.text]) {
            //{"appId": "test0002","phone":"18020260894","password":"654321","sign":$sign,"accessToken":$accessToken}
           
            
            
            //没有登录账号无法获得验证码
            NSDictionary *dic = @{@"appId":APP_ID,@"nonceStr":NONCE_STR,@"pwd":_newPassword.text,@"mphone":_phoneNum?:@"",@"vcode":self.vcode?:@""};
            NSLog(@"%@",dic);
            NSData *data = [HFSUtility RSADicToData:dic] ;
            NSString *ret = base64_encode_data(data);
            
            [[HFSServiceClient sharedClient] POST:@"vip/ResetPassword" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *result = (NSDictionary *)responseObject;
                NSLog(@"返回编码:%@",result[@"status"]);
                NSLog(@"%@",result[@"msg"]);
                if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
                    
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"密码修改成功";
                    [_hud hide:YES afterDelay:2];
                    [self performSelector:@selector(popView) withObject:nil afterDelay:2];
                }
                else{
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = result[@"msg"];
                    [_hud hide:YES afterDelay:2];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败");
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
        }
         */
        }
        else {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"两次输入密码不同";
            [_hud hide:YES afterDelay:2];
        }
    }
}
- (void)popView {
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *management = [viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:management animated:YES];
}
- (void)backDismissBlockAction:(BackDismissBlock)block{
    self.backBlock = block;
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

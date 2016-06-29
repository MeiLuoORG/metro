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
    
    NSString * _zhaoHuiPasswordString;
}

@end

@implementation MNNNextStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_bkView addGestureRecognizer:gesture];

    [self loadTopView];
    [self createView];
    // Do any additional setup after loading the view.
    //UiTextField变化通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChangeAction:(id)sender{
    
    
    
    if (![_newPassword.text isEqualToString:@""] && ![_confirmPassword.text isEqualToString:@""]) {
        _determine.enabled = YES;
        [_determine setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonNormel_backgroundColor]];
        
        
    }
    else{
        _determine.enabled = NO;
        [_determine setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    }
    
    
}


//Lock_xiugaimima锁     Profile_xiugaimima人    golden_button
- (void)loadTopView{
    
    NavTopCommonImage * img = [[NavTopCommonImage alloc]initWithTitle:@"重置密码"];
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
    //[_bkView addSubview:lable1];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+80, 30, (kScreenWidth-120)/2, 20)];
    lable2.text = @"修改密码";
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
    lable2.font = [UIFont systemFontOfSize:15];
    //[_bkView addSubview:lable2];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 20, 20)];
    label3.layer.cornerRadius = 10;
    label3.layer.masksToBounds = YES;
    label3.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label3.font = [UIFont systemFontOfSize:20];
    label3.text = @"1";
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    //[_bkView addSubview:label3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+80, 30, 20, 20)];
    label4.layer.cornerRadius = 10;
    label4.layer.masksToBounds = YES;
    label4.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label4.font = [UIFont systemFontOfSize:20];
    label4.text = @"2";
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentCenter;
    //[_bkView addSubview:label4];
    
    
    //[self createlableWithRect:CGRectMake(10, 79, kScreenWidth-20, 1)];
    _newPassword = [[UITextField alloc] initWithFrame:CGRectMake(22, 42, kScreenWidth-44, 41)];
    _newPassword.placeholder = @"新密码";
    _newPassword.delegate = self;
    //_newPassword.borderStyle = UITextBorderStyleNone;
    _newPassword.secureTextEntry = YES;
    _newPassword.font = [UIFont systemFontOfSize:15.0f];
    //[_newPassword setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    _newPassword.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    _newPassword.layer.cornerRadius = 4.0f;
    _newPassword.layer.borderWidth = 1.0f;
    _newPassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 0)];
    _newPassword.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 15, 20)];
    imageView1.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    //[_bkView addSubview:imageView1];
    _newPassword.clearsOnBeginEditing = YES;
    _newPassword.keyboardType = UIKeyboardAppearanceDefault;
    [_bkView addSubview:_newPassword];
    //[self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_newPassword.frame), kScreenWidth-20, 1)];
  
    _confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_newPassword.frame)+29, kScreenWidth-44, 41)];
    _confirmPassword.delegate = self;
    _confirmPassword.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    _confirmPassword.layer.cornerRadius = 4.0f;
    _confirmPassword.layer.borderWidth = 1.0f;
    _confirmPassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 0)];
    _confirmPassword.leftViewMode = UITextFieldViewModeAlways;
    _confirmPassword.placeholder = @"确认新密码";
    
    //_confirmPassword.borderStyle = UITextBorderStyleNone;
    _confirmPassword.secureTextEntry = YES;
    _confirmPassword.font = [UIFont systemFontOfSize:15.0f];
    //[_confirmPassword setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_newPassword.frame)+10, 15, 20)];
    imageView2.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    //[_bkView addSubview:imageView2];
    _confirmPassword.clearsOnBeginEditing = YES;
    _confirmPassword.keyboardType = UIKeyboardAppearanceDefault;
    [_bkView addSubview:_confirmPassword];
    
    //[self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_confirmPassword.frame), kScreenWidth-20, 1)];
    _determine = [[UIButton alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_confirmPassword.frame)+60, kScreenWidth-44, 42)];
    [_determine setBackgroundColor:[HFSUtility hexStringToColor:Main_ButtonGray_backgroundColor]];
    _determine.enabled = NO;
    //[_determine setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_determine setTitle:@"确定" forState:UIControlStateNormal];
    _determine.layer.cornerRadius = 4.0f;
    _determine.layer.masksToBounds = YES;
    [_determine addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bkView addSubview:_determine];
}
- (void)createlableWithRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0.7;
    [_bkView addSubview:label];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{


    return YES;
}

#pragma mark 修改密码
- (void)buttonAction {
    __weak __typeof(&*self)weakSelf =self;
    [_newPassword resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    
    if ([self canRegister]) {
        
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
                
                [self yuanShengXiuGgainWithRet2:ret2];
                /*
                //@"vip/AuthUserInfo"
                [[HFSServiceClient sharedClient] POST:ForgetPassword_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *result = (NSDictionary *)responseObject;
                    NSLog(@"修改密码：%@",result);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    _hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:_hud];
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"请求失败";
                    [_hud hide:YES afterDelay:2];
                }];
                */
                
                
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
                _zhaoHuiPasswordString = _newPassword.text;
                NSUserDefaults * userDafaults = [NSUserDefaults standardUserDefaults];
                
                [userDafaults setObject:_phoneNum forKey:ZHAOHUIPASSWORD_CURRENT_PHONE];
                [userDafaults synchronize];
                
                [self yuanShengZhaoHuinWithRet2:ret2];
                
                
                /*
                //@"vip/AuthUserInfo"
                [[HFSServiceClient sharedClient] POST:ForgetPassword_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *result = (NSDictionary *)responseObject;
                    NSLog(@"忘记密码：%@",result);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    _hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:_hud];
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"请求失败";
                    [_hud hide:YES afterDelay:2];
                }];
                 */
            }
            
        }
        else {
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"两次输入密码不同";
            [_hud hide:YES afterDelay:1];
        }
    }

    
}

#pragma mark 原生修改密码

- (void) yuanShengXiuGgainWithRet2:(NSString *)ret2{
    __weak __typeof(&*self)weakSelf =self;
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",ForgetPassword_URLString];
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
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      _hud = [[MBProgressHUD alloc]initWithView:self.view];
                                                      [self.view addSubview:_hud];
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = @"重置成功";
                                                      [_hud hide:YES afterDelay:1];
                                                      });
                                                      [weakSelf dismissViewControllerAnimated:NO completion:^{
                                                          weakSelf.backBlock(YES);
                                                      }];
                                                  }else{
                                                      /*
                                                       _hud.labelText = result[@"errMsg"];
                                                       [_hud hide:YES afterDelay:2];
                                                       */
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                      _hud = [[MBProgressHUD alloc]initWithView:self.view];
                                                      [self.view addSubview:_hud];
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


#pragma end mark

#pragma mark 原生找回密码
- (void) yuanShengZhaoHuinWithRet2:(NSString *)ret2{
    __weak __typeof(&*self)weakSelf =self;
    //GCD异步实现
    dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",ForgetPassword_URLString];
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
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      _hud = [[MBProgressHUD alloc]initWithView:self.view];
                                                      [self.view addSubview:_hud];
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = @"找回成功";
                                                      [_hud hide:YES afterDelay:2];
                                                      });
                                                      
                                                      
                                                      [weakSelf dismissViewControllerAnimated:NO completion:^{
                                                          weakSelf.backBlock(YES);
                                                      }];
                                                  }else{
                                                      /*
                                                       _hud.labelText = result[@"errMsg"];
                                                       [_hud hide:YES afterDelay:2];
                                                       */
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      _hud = [[MBProgressHUD alloc]initWithView:self.view];
                                                      [self.view addSubview:_hud];
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
    });
}


#pragma end mark


-(BOOL)canRegister{
    NSString *errStr = nil;
    
    if ([_newPassword.text isEqualToString:@""]||[_confirmPassword.text isEqualToString:@""]) {
         errStr = @"请输入密码";
    }else if (![_newPassword.text isEqualToString:_confirmPassword.text]){
        errStr = @"两次密码输入不一致，请确认。";
    } else if (_newPassword.text.length < 6 || _newPassword.text.length > 20){
        errStr = @"请使用6-20位字母或数字。";
    }
    else if (![ZhengZePanDuan checkPasswordMeiLuo:_newPassword.text]){
        errStr = @"请使用6-20位字母或数字。";
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
        [_hud hide:YES afterDelay:1];
        
        return NO;
    }
    return YES;
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

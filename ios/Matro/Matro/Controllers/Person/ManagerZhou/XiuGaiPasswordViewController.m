//
//  XiuGaiPasswordViewController.m
//  Matro
//
//  Created by lang on 16/6/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "XiuGaiPasswordViewController.h"
#import "HFSUtility.h"
#import "CommonHeader.h"
#import "HFSConstants.h"

@interface XiuGaiPasswordViewController ()

@end

@implementation XiuGaiPasswordViewController{


    NSString * _xiugaiPasswordString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    self.oldField.layer.cornerRadius = 4.0f;
    self.oldField.layer.masksToBounds = YES;
    self.oldField.layer.borderWidth = 1.0f;
    self.oldField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.oldField.placeholder = @"原密码";
    UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    self.oldField.leftView  =kongView;
    self.oldField.leftViewMode = UITextFieldViewModeAlways;
    self.oldField.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    
    self.SecondField.layer.cornerRadius = 4.0f;
    self.SecondField.layer.masksToBounds = YES;
    self.SecondField.layer.borderWidth = 1.0f;
    self.SecondField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.SecondField.placeholder = @"新密码";
    UIView * kongView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    self.SecondField.leftView  =kongView2;
    self.SecondField.leftViewMode = UITextFieldViewModeAlways;
    self.SecondField.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    
    self.ThirdField.layer.cornerRadius = 4.0f;
    self.ThirdField.layer.masksToBounds = YES;
    self.ThirdField.layer.borderWidth = 1.0f;
    self.ThirdField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.ThirdField.placeholder = @"确认新密码";
    UIView * kongView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    self.ThirdField.leftView  =kongView3;
    self.ThirdField.leftViewMode = UITextFieldViewModeAlways;
    self.ThirdField.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction3:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
-(BOOL)canRegister{
    NSString *errStr = nil;
    
    if ([self.oldField.text isEqualToString:@""]) {
        errStr = @"请输入原密码";
        
    }else if(![self.oldField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUSERDEFAULT_PASSWORD_ZL]]){
        errStr = @"原密码输入错误";
    }
    else if ([self.SecondField.text isEqualToString:@""]||[self.ThirdField.text isEqualToString:@""]) {
        errStr = @"请输入新密码";
    }else if (![self.SecondField.text isEqualToString:self.ThirdField.text]){
        errStr = @"两次密码输入不一致，请确认。";
    } else if (self.SecondField.text.length < 6 || self.ThirdField.text.length > 20){
        errStr = @"请使用6-20位字母或数字。";
    }
    else if (![ZhengZePanDuan checkPasswordMeiLuo:self.SecondField.text]){
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


- (void)buttonAction3:(id)sender{

    [self.oldField resignFirstResponder];
    [self.SecondField resignFirstResponder];
    [self.ThirdField resignFirstResponder];
    if ([self canRegister]) {
        if ([self.SecondField.text isEqualToString:self.ThirdField.text]) {
            //{"appId": "test0002","phone":"18020260894","password":"654321","sign":$sign,"accessToken":$accessToken}
            /*zhoulu*/
            
            // 存储用户信息
            NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
            NSString * accessToken = [userDefaults1 objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
            NSString * phoneStr = [userDefaults1 objectForKey:kUSERDEFAULT_USERPHONE];
            if (accessToken) {
                //accessToken存在
                //修改密码
                NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,
                                                               @"oldPassword":self.oldField.text,
                                                               @"phone":phoneStr?:@"",
                                                               @"password":self.SecondField.text}];
                NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                        @"phone":phoneStr?:@"",
                                        @"oldPassword":self.oldField.text,
                                        @"password":self.SecondField.text,
                                        @"sign":signDic[@"sign"],
                                        @"accessToken":accessToken
                                        };
                NSData *data2 = [HFSUtility RSADicToData:dic2];
                NSString *ret2 = base64_encode_data(data2);
                _xiugaiPasswordString = self.SecondField.text;
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
                                                      _hud.labelText = @"修改成功";
                                                      [_hud hide:YES afterDelay:1];
                                                      
                                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                                      
                                                      NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                                                      [userDefault setObject:_xiugaiPasswordString forKey:KUSERDEFAULT_PASSWORD_ZL];
                                                      
                                                  });
                                                 
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

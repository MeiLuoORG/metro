//
//  MNNModifyNameViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNModifyNameViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "CommonHeader.h"

@interface MNNModifyNameViewController () {
    UITextField *_textField;
    UIButton *_preservationButton;
}

@end

@implementation MNNModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:gesture];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 22)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [rightBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createView];
    // Do any additional setup after loading the view.
}



- (void)tap {
    [_textField resignFirstResponder];
}

//创建修改试图golden_button
- (void)createView {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(22, 40, self.view.frame.size.width-44, 41)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"请输入新的昵称";
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.text = self.currentName;
    [self.view addSubview:_textField];
    _preservationButton = [[UIButton alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_textField.frame)+40, self.view.frame.size.width-44, 42)];
    [_preservationButton setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_preservationButton setTitle:@"保存" forState:UIControlStateNormal];
    [_preservationButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:_preservationButton];
}
#pragma mark 保存修改后的昵称
- (void)buttonAction {
    
    [_textField resignFirstResponder];
    if ([_textField.text isEqualToString:@""] || _textField.text.length <2 || _textField.text.length > 20) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"昵称格式不正确，请确认。";
        [_hud hide:YES afterDelay:2];
    }
    else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
        NSString *mphone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
        NSString *cardno = [userDefaults objectForKey:kUSERDEFAULT_USERCARDNO];
         NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
        NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":mphone,@"nickName":_textField.text}];
        NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                @"phone":mphone,
                                @"nickName":_textField.text,
                                @"sign":signDic[@"sign"],
                                @"accessToken":accessToken
                                };
        
        NSData *data = [HFSUtility RSADicToData:dic2] ;
        NSString *ret = base64_encode_data(data);
        [self yuanShengRegisterAcrionWithRet2:ret];
        /*
        [[HFSServiceClient sharedClient]POST:XiuGaiInfo_URLString parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *result = (NSDictionary *)responseObject;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];
         */
    }
}

- (void) yuanShengRegisterAcrionWithRet2:(NSString *)ret2{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",XiuGaiInfo_URLString];
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
                                                  NSLog(@"修改昵称信息：%@",result);
                                                  if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = @"昵称修改成功";
                                                      [_hud hide:YES afterDelay:2];
                                                      });
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                      [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:kUSERDEFAULT_USERNAME];
                                                      
                                                      
                                                      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGEUSERINFO object:nil];
                                                      
                                                      [self popView];
                                                       });
                                                      
                                                  }else{
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = result[@"msg"];
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
   // });
}

/*
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
}*/

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
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

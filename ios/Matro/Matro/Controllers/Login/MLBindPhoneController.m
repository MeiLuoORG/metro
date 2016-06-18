//
//  MLBindPhoneController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBindPhoneController.h"
#import "YMLeftImageField.h"
#import "Masonry.h"
#import "HFSServiceClient.h"
#import "YMPhoneCondeButton.h"
#import "HFSUtility.h"
#import <MagicalRecord/MagicalRecord.h>

@interface MLBindPhoneController ()
@property (weak, nonatomic) IBOutlet YMLeftImageField *phoneField;
@property (weak, nonatomic) IBOutlet YMLeftImageField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *subCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (nonatomic,strong)YMLeftImageField *passField;
@property (nonatomic,strong)YMLeftImageField *rPassField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindConstraint;

@end


static BOOL isPass = NO;

@implementation MLBindPhoneController{

    NSManagedObjectContext *_context;

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    self.phoneField.placeholder = @"手机号";
    self.phoneField.delegate = self;
    self.phoneField.layer.borderWidth = 1.f;
    self.phoneField.layer.cornerRadius = 4.0f;
    self.phoneField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.phoneField.layer.masksToBounds = YES;
    self.phoneField.font = [UIFont systemFontOfSize:12.0f];
    //self.phoneField.leftImgName = @"Profile_gray";
    self.phoneField.leftOffset = 5.f;
    self.phoneField.rightOffset = 5.f;
    self.codeField.layer.borderWidth = 1.f;
    self.codeField.delegate = self;
    self.codeField.layer.cornerRadius = 4.0f;
    self.codeField.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.codeField.layer.masksToBounds = YES;
    self.codeField.placeholder = @"验证码";
    self.codeField.leftOffset = 5.f;
    self.codeField.rightOffset = 5.f;
    self.codeField.font = [UIFont systemFontOfSize:12.0f];
   // self.codeField.leftImgName = @"Lock_gray";
    //self.subCodeBtn.layer.borderWidth = 1.f;
    self.subCodeBtn.layer.cornerRadius = 4.0f;
    [self.subCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //self.subCodeBtn.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    self.subCodeBtn.layer.masksToBounds = YES;
    [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
    self.subCodeBtn.enabled = NO;
    
    [self.subCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.bindBtn.enabled = NO;
    [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
    
    _passField = ({
       YMLeftImageField *filed = [[YMLeftImageField alloc]initWithFrame:self.bindBtn.frame];
        filed.delegate = self;
        filed.secureTextEntry = YES;
        filed.placeholder = @"密码(6-20位字母或数字)";
        filed.leftOffset = 5.f;
        filed.rightOffset = 5.f;
        //filed.leftImgName = @"Lock_gray";
        filed.font = [UIFont systemFontOfSize:12];
        filed.layer.borderWidth = 1.f;
        filed.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
        filed.layer.masksToBounds = YES;
        filed.layer.cornerRadius = 4.0f;
        filed;
    });
    
    _rPassField = ({
        YMLeftImageField *filed = [[YMLeftImageField alloc]initWithFrame:self.bindBtn.frame];
        filed.delegate = self;
        filed.secureTextEntry = YES;
        filed.placeholder = @"确认密码";
        filed.leftOffset = 5.f;
        filed.rightOffset = 5.f;
        //filed.leftImgName = @"Lock_gray";
        filed.font = [UIFont systemFontOfSize:12];
        filed.layer.borderWidth = 1.f;
        filed.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
        filed.layer.masksToBounds = YES;
        filed.layer.cornerRadius = 4.0f;
        filed;
    });
    
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)subCodeClick:(id)sender {
    
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":_phoneField.text?:@"",@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            /*
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"验证码已发送，请注意查收";
            [_hud hide:YES afterDelay:2];
             */
            YMPhoneCondeButton *btn = (YMPhoneCondeButton *)sender;
            
            [btn startUpTimer];
            
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
    
    /*zhoulu*/
    [self panDuanIsRegistered];
    /*
    NSDictionary *dic = @{@"appId":APP_ID,
                          @"nonceStr":NONCE_STR,
                          @"account":self.phoneField.text,
                          };
    
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient]POST:@"vip/CheckAccountExist" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *status = [responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {//直接输入密码
            [self showPassfield];
            isPass = YES;
            
        }
        else{
            NSArray *result = [responseObject objectForKey:@"cardlist"];
            BOOL isReady = NO;
            for (NSDictionary *dic in result) {
                if ([dic[@"act"] isEqualToString:@"1"]) {
                    isReady = YES;
                }
            }
            if (isReady) { //需要输入密码
                isPass = YES;
                [self showPassfield];
            }
            else{//不需要输入密码
                isPass = NO;
            }

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
*/

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
                 */
                isPass = NO;
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
    
}

- (void)showPassfield{
    [self.view addSubview:self.passField];
    [self.view addSubview:self.rPassField];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bindConstraint.constant = 191;
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
        
    }];
}



- (IBAction)bindClick:(id)sender {
    
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
        
        [[HFSServiceClient sharedClient]POST:ThirdLogin_BindPhone_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"绑定手机号：%@",result);
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
                                if (dics[@"cardTypeName"] && ![dics[@"cardTypeName"] isEqualToString:@""] && dics[@"cardTypeName"] != nil){
                                
                                NSString * cardTypeName = [NSString stringWithFormat:@"%@",dics[@"cardTypeName"]];
                                [userDefaults setObject:cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                }
                                else{
                                    [userDefaults setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
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
                            
                            
                            
                            //绑定会员卡
                            [weakSelf loadSettingMoCardViewWithCardARR:self.vipCardArray withPhone:self.phoneField.text withCardNo:nil withAccessToken:userDic[@"accessToken"]];
                        }
                    }
                    else if(vipCardARR.count < 1){
                        
                        [weakSelf dismissViewControllerAnimated:NO completion:^{
                            [_hud show:YES];
                            _hud.mode = MBProgressHUDModeText;
                            _hud.labelText = @"您还没有会员卡";
                            [_hud hide:YES afterDelay:1];
                            [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
                            //weakSelf.backBlock(YES);
                        }];

                    }
                    
                }
                else{
                    isDefault = YES;
                }
                
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
                    [weakSelf dismissViewControllerAnimated:NO completion:^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
                        //weakSelf.backBlock(YES);
                    }];
                }

                
                [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
                
            }else{
                 [_hud show:YES];
                 _hud.mode = MBProgressHUDModeText;
                 _hud.labelText = @"绑定失败";
                 [_hud hide:YES afterDelay:2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
            // NSLog(@"验证码错误信息：%@",error);
        }];
        
    
    
    
    /*
     zhoulu
     */
    /*
    NSMutableDictionary *dic = [@{@"appId":APP_ID,
                          @"vcode":self.codeField.text,
                          @"mphone":self.phoneField.text,
                          @"partnerId":self.open_id
                          } mutableCopy];
    if(isPass){
        [dic setObject:self.passField.text forKey:@"pwd"];
    }

    
    
    NSData *data = [HFSUtility RSADicToData:[dic copy]] ;
    NSString *ret = base64_encode_data(data);
    
    
    
    
    [[HFSServiceClient sharedClient]POST:@"vip/ThirdPartyLoginInBindMphone" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result objectForKey:@"userId"]) {//绑定成功
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
            [userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
            if (result[@"headPicUrl"] && ![@"" isEqualToString:result[@"headPicUrl"]]) {
                [userDefaults setObject:result[@"headPicUrl"] forKey:kUSERDEFAULT_USERAVATOR ];
                
            }
            [userDefaults setObject:result[@"mphone"] forKey:kUSERDEFAULT_USERPHONE ];
            [userDefaults setObject:result[@"nickname"] forKey:kUSERDEFAULT_USERNAME ];
            [userDefaults setObject:result[@"userId"] forKey:kUSERDEFAULT_USERID ];
            [userDefaults synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONBINDSUC object:nil];
    

        }
        else{
            NSString *msg = [responseObject objectForKey:@"msg"];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = msg;
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
#pragma 返回Block
- (void)backBlocksAction:(BackBlocks)block{
    self.backBlock = block;
}

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
            
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            
            
            if (self.settingMoCardView.cardTypeName && ![self.settingMoCardView.cardTypeName isEqualToString:@""]) {
                [userDefault setObject:self.settingMoCardView.cardTypeName forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            }
            else{
            
                [userDefault setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            }
            
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
                
                [userDefault setObject:@"普通会员" forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
            }
            
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
    
    
}
#pragma mark TextField 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([textField isEqual:self.phoneField]) {
        if (self.phoneField.text.length > 0) {
            self.subCodeBtn.enabled = YES;
            [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_BackgroundColor]];
            
        }else{
            self.subCodeBtn.enabled = NO;
            [self.subCodeBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
        
        }
    }
    if (isPass) {
        if (self.phoneField.text.length > 0 && self.codeField.text.length>0 && self.passField.text.length > 0 &&self.rPassField.text.length > 0) {
            self.bindBtn.enabled = YES;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_BackgroundColor]];
        }
        else{
            self.bindBtn.enabled = NO;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
        
        }
        
    }
    else {
        if (self.phoneField.text.length > 0 && self.codeField.text.length>0) {
            self.bindBtn.enabled = YES;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_BackgroundColor]];
        }
        else{
            self.bindBtn.enabled = NO;
            [self.bindBtn setBackgroundColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor]];
            
        }
    
    }
    
    
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
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];
        
        
    }
    
    
}



#pragma end mark


@end

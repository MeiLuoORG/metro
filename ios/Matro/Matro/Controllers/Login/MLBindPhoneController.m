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

@implementation MLBindPhoneController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    self.phoneField.layer.borderWidth = 1.f;
    self.phoneField.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.phoneField.layer.masksToBounds = YES;
    self.phoneField.leftImgName = @"Profile_gray";
    self.phoneField.leftOffset = 5.f;
    self.phoneField.rightOffset = 5.f;
    self.codeField.layer.borderWidth = 1.f;
    self.codeField.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.codeField.layer.masksToBounds = YES;
    self.codeField.leftOffset = 5.f;
    self.codeField.rightOffset = 5.f;
    self.codeField.leftImgName = @"Lock_gray";
    self.subCodeBtn.layer.borderWidth = 1.f;
    self.subCodeBtn.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.subCodeBtn.layer.masksToBounds = YES;
    
    _passField = ({
       YMLeftImageField *filed = [[YMLeftImageField alloc]initWithFrame:self.bindBtn.frame];
        filed.secureTextEntry = YES;
        filed.placeholder = @"请输入密码";
        filed.leftOffset = 5.f;
        filed.rightOffset = 5.f;
        filed.leftImgName = @"Lock_gray";
        filed.font = [UIFont systemFontOfSize:14];
        filed.layer.borderWidth = 1.f;
        filed.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
        filed.layer.masksToBounds = YES;
        filed;
    });
    
    _rPassField = ({
        YMLeftImageField *filed = [[YMLeftImageField alloc]initWithFrame:self.bindBtn.frame];
        filed.secureTextEntry = YES;
        filed.placeholder = @"请输入确认密码";
        filed.leftOffset = 5.f;
        filed.rightOffset = 5.f;
        filed.leftImgName = @"Lock_gray";
        filed.font = [UIFont systemFontOfSize:14];
        filed.layer.borderWidth = 1.f;
        filed.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
        filed.layer.masksToBounds = YES;
        filed;
    });
    
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)subCodeClick:(id)sender {
    
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":_phoneField.text?:@"",@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"验证码已发送，请注意查收";
            [_hud hide:YES afterDelay:2];
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


}

- (void)showPassfield{
    [self.view addSubview:self.passField];
    [self.view addSubview:self.rPassField];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bindConstraint.constant = 110;
        [self.passField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeField.mas_bottom).offset(10);
            make.left.right.mas_equalTo(self.phoneField);
            make.height.mas_equalTo(40);
        }];
        [self.rPassField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.passField.mas_bottom).offset(10);
            make.left.right.mas_equalTo(self.phoneField);
            make.height.mas_equalTo(40);
        }];
        
    }];
}



- (IBAction)bindClick:(id)sender {
    
    
    if (self.phoneField.text.length == 0 ||
        self.codeField.text.length == 0) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入完整信息";
        [_hud hide:YES afterDelay:2];
        return;
        
    }
    if (isPass) {
        if (self.passField.text.length < 6) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"输入的密码格式不正确";
            [_hud hide:YES afterDelay:2];
            return;
        }
        if (![self.passField.text isEqualToString:self.rPassField.text]) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"两次密码输入不一致";
            [_hud hide:YES afterDelay:2];
            return;
        }
    }
    
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


}

@end

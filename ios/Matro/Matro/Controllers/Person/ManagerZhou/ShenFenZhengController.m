//
//  ShenFenZhengController.m
//  Matro
//
//  Created by lang on 16/6/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ShenFenZhengController.h"

@interface ShenFenZhengController (){
    UITextField *_textField;
    UIButton *_preservationButton;
}
@end

@implementation ShenFenZhengController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:gesture];
    [self createView];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)buttonAction:(UIButton *)sender{

    
    
    [_textField resignFirstResponder];
    if ([_textField.text isEqualToString:@""] || _textField.text.length != 18) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入您的身份证号码";
        [_hud hide:YES afterDelay:2];
    }
    else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
        NSString *mphone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
        NSString *cardno = [userDefaults objectForKey:kUSERDEFAULT_USERCARDNO];
        NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
        
        NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":mphone,@"idcard":_textField.text}];
        NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                @"phone":mphone,
                                @"idcard":_textField.text,
                                @"sign":signDic[@"sign"],
                                @"accessToken":accessToken
                                };

        NSData *data = [HFSUtility RSADicToData:dic2] ;
        NSString *ret = base64_encode_data(data);
        
        [[HFSServiceClient sharedClient]POST:XiuGaiInfo_URLString parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"修改账户信息：%@",result);
            if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                /*
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"昵称修改成功";
                [_hud hide:YES afterDelay:2];
                */
                
                [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                self.block(YES);
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGEUSERINFO object:nil];
                [self popView];
                
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
}

- (void)tap {
    [_textField resignFirstResponder];
}

- (void)shenFenZhengBlockAction:(ShenFenZhengBlock)block{
    self.block = block;
}

//创建修改试图golden_button
- (void)createView {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.text = self.shenFenStr;
    _textField.placeholder = @"请输入身份证号码";
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_textField];
    /*
    _preservationButton = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_textField.frame)+40, self.view.frame.size.width-100, 30)];
    [_preservationButton setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_preservationButton setTitle:@"保存" forState:UIControlStateNormal];
    [_preservationButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_preservationButton];
     */
}
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

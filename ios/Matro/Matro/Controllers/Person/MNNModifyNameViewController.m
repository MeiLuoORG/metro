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
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"

@interface MNNModifyNameViewController () {
    UITextField *_textField;
    UIButton *_preservationButton;
    NSString *typeStr;
}

@end

@implementation MNNModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
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
    
}



- (void)tap {
    [_textField resignFirstResponder];
}
//创建修改试图golden_button
- (void)createView {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(22, 40, self.view.frame.size.width-44, 41)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    if ([self.xiugaitype isEqualToString:@"1"]) {
       _textField.placeholder = @"请输入新的昵称";
        typeStr = @"ckuser";
    }else if ([self.xiugaitype isEqualToString:@"2"]){
        _textField.placeholder = @"请输入您的真实姓名";
        typeStr = @"name";
    }else if ([self.xiugaitype isEqualToString:@"3"]){
        _textField.placeholder = @"请输入您的身份证号";
        typeStr = @"identity_card";
    }else if ([self.xiugaitype isEqualToString:@"5"]){
        _textField.placeholder = @"请输入您的通讯地址";
        typeStr = @"temp_add";
    }
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.text = self.currentName;
    [self.view addSubview:_textField];
    _preservationButton = [[UIButton alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_textField.frame)+40, self.view.frame.size.width-44, 42)];
    [_preservationButton setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_preservationButton setTitle:@"保存" forState:UIControlStateNormal];
    [_preservationButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_textField becomeFirstResponder];
    
}
#pragma mark 保存修改后的昵称
- (void)buttonAction {
    
    [_textField resignFirstResponder];
    if ([self.xiugaitype isEqualToString:@"1"]) {
        if ([_textField.text isEqualToString:@""]) {
            
            [MBProgressHUD show:@"昵称不能为空，请确认" view:self.view];
            return;
        }else if (_textField.text.length < 2 || _textField.text.length >20){
            
            [MBProgressHUD show:@"昵称的长度不能小于2且不能大于20额，请确认" view:self.view];
            return;
        }
        
    }
    
    if ([self.xiugaitype isEqualToString:@"2"]) {
        if (_textField.text.length ==0) {
            [MBProgressHUD show:@"真实姓名不能为空，请确认" view:self.view];
            return;
        }
    }
    if ([self.xiugaitype isEqualToString:@"3"]) {
        if (_textField.text.length ==0 || _textField.text.length <18 || _textField.text.length >18 ) {
            [MBProgressHUD show:@"请输入正确的身份证号" view:self.view];
            return;
        }
    }
    
    if ([self.xiugaitype isEqualToString:@"5"]) {
        if (_textField.text.length ==0 ) {
            [MBProgressHUD show:@"通讯地址不能为空，请确认" view:self.view];
            return;
        }
    }
    NSDictionary *params;
    if ([self.xiugaitype isEqualToString:@"1"]) {
        params = @{@"type":self.xiugaitype,@"ckuser":_textField.text};
        
    }else if ([self.xiugaitype isEqualToString:@"2"]){
         params = @{@"type":self.xiugaitype,@"name":_textField.text};
        
    }else if ([self.xiugaitype isEqualToString:@"3"]){
        params = @{@"type":self.xiugaitype,@"identity_card":_textField.text};
        
    }else if ([self.xiugaitype isEqualToString:@"5"]){
        params = @{@"type":self.xiugaitype,@"temp_add":_textField.text};
        
    }
    
    [MLHttpManager post:XiuGaiBaseInfo_URLString params:params m:@"member" s:@"admin_member" success:^(id responseObject) {
            NSLog(@"上传成功responseObject=123=%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
           
            [MBProgressHUD show:@"修改成功" view:self.view];
            if ([self.xiugaitype isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:kUSERDEFAULT_USERNAME];
                
            }else if ([self.xiugaitype isEqualToString:@"2"]){
                [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:@"name"];
                
            }else if ([self.xiugaitype isEqualToString:@"3"]){
               [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                
            }else if ([self.xiugaitype isEqualToString:@"5"]){
               [[NSUserDefaults standardUserDefaults]setObject:_textField.text forKey:@"txAddr"];
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGEUSERINFO object:nil];
                
            [self popView];
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];

    }];

}

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ChongZhiViewController.m
//  Matro
//
//  Created by lang on 16/7/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ChongZhiViewController.h"

@interface ChongZhiViewController (){

    BOOL  _isChongZhi;
    int _cardNum;
    NSArray * _cardNumARRS;
}

@end

@implementation ChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cardNumARRS = @[@"10",@"20",@"30",@"50",@"100",@"300"];
    
    
    
    self.firstView.layer.borderWidth = 1.0f;
    self.firstView.layer.borderColor = [UIColor colorWithRed:193.0f/255.0 green:163.0f/225.0f blue:127.0f/255.0f alpha:1.0f].CGColor;
    self.firstView.layer.cornerRadius = 4.0f;
    self.firstView.layer.masksToBounds = YES;

    self.secondView.layer.borderWidth = 1.0f;
    self.secondView.layer.borderColor = [UIColor colorWithRed:193.0f/255.0 green:163.0f/225.0f blue:127.0f/255.0f alpha:1.0f].CGColor;
    self.secondView.layer.cornerRadius = 4.0f;
    self.secondView.layer.masksToBounds = YES;
    
    self.thirdView.layer.borderWidth = 1.0f;
    self.thirdView.layer.borderColor = [UIColor colorWithRed:193.0f/255.0 green:163.0f/225.0f blue:127.0f/255.0f alpha:1.0f].CGColor;
    self.thirdView.layer.cornerRadius = 4.0f;
    self.thirdView.layer.masksToBounds = YES;
    
    self.fourView.layer.borderWidth = 1.0f;
    self.fourView.layer.borderColor = [UIColor colorWithRed:193.0f/255.0 green:163.0f/225.0f blue:127.0f/255.0f alpha:1.0f].CGColor;
    self.fourView.layer.cornerRadius = 4.0f;
    self.fourView.layer.masksToBounds = YES;
    
    self.fiveView.layer.borderWidth = 1.0f;
    self.fiveView.layer.borderColor = [UIColor colorWithRed:193.0f/255.0 green:163.0f/225.0f blue:127.0f/255.0f alpha:1.0f].CGColor;
    self.fiveView.layer.cornerRadius = 4.0f;
    self.fiveView.layer.masksToBounds = YES;
    
    self.sixView.layer.borderWidth = 1.0f;
    self.sixView.layer.borderColor = [UIColor colorWithRed:193.0f/255.0 green:163.0f/225.0f blue:127.0f/255.0f alpha:1.0f].CGColor;
    self.sixView.layer.cornerRadius = 4.0f;
    self.sixView.layer.masksToBounds = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * loginid = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    if (![loginid isEqualToString:@""] && loginid ) {
        self.phoneTextField.text = loginid;
    }
    // Do any additional setup after loading the view from its nib.
    
    //UiTextField变化通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChangeAction:(id)sender{

    if ([self panDuanPhoneIsYesOrNO]) {
        
        //检测是否可以充值
        
        
    }
    
}
//检测手机号是否可以充值
- (void)jianCePhoneChongZhi{
    
    NSString * urlStr = [NSString stringWithFormat:@"http://op.juhe.cn/ofpay/mobile/telcheck?cardnum=%d&phoneno=%@&key=750c0694e48f04e9b1f5a5b1db118eee",_cardNum,self.phoneTextField.text];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"聚合数据请求：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        if([result[@"error_code"] isEqual:@0]){
            _isChongZhi = YES;
            
        }
        else{
            _isChongZhi = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"聚合数据请求错误：%@",error);
        _isChongZhi = NO;
    }];
    

}
//检测手机号运营商
- (void)yunYingShang{
//http://op.juhe.cn/ofpay/mobile/telquery?cardnum=30&phoneno=18913515635&key=您申请的KEY
    NSString * urlStr = [NSString stringWithFormat:@"http://op.juhe.cn/ofpay/mobile/telquery?cardnum=%d&phoneno=%@&key=750c0694e48f04e9b1f5a5b1db118eee",10,self.phoneTextField.text];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"聚合数据请求：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        if([result[@"error_code"] isEqual:@0]){
            NSDictionary * data = result[@"result"];
            if (data[@"game_area"]) {
                
            }
            
        }
        else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"聚合数据请求错误：%@",error);
        
    }];

}


- (IBAction)firstViewAction:(UIControl *)sender {
    NSLog(@"第一个");
    if ([self panDuanPhoneIsYesOrNO]) {
        
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)secondViewAction:(UIControl *)sender {
     NSLog(@"第2个");
    if ([self panDuanPhoneIsYesOrNO]) {
        
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)thirdViewAction:(UIControl *)sender {
     NSLog(@"第3个");
    if ([self panDuanPhoneIsYesOrNO]) {
        
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)fourViewAction:(UIControl *)sender {
     NSLog(@"第4个");
    if ([self panDuanPhoneIsYesOrNO]) {
        
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)fiveViewAction:(UIControl *)sender {
     NSLog(@"第5个");
    if ([self panDuanPhoneIsYesOrNO]) {
        
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)sixViewAction:(UIControl *)sender {
     NSLog(@"第6个");
    if ([self panDuanPhoneIsYesOrNO]) {
        
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}

- (IBAction)tongXunLuAction:(UIButton *)sender {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
    
    
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.phoneTextField.text = (__bridge NSString*)value;
    }];
}

- (BOOL)panDuanPhoneIsYesOrNO{
    
    BOOL result = [HFSUtility validateMobile:self.phoneTextField.text];
    return result;
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

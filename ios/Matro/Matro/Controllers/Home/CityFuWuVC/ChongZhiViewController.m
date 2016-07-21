//
//  ChongZhiViewController.m
//  Matro
//
//  Created by lang on 16/7/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ChongZhiViewController.h"


#define kAppleMerchantID @"merchant.Matro"

@interface ChongZhiViewController (){

    BOOL  _isChongZhi;
    int _cardNum;
    NSArray * _cardNumARRS;
    NSMutableArray * _buyJiaARR;
    NSMutableDictionary * _jiaGeDic;
    
    NSMutableArray * _phoneJiaGeARR;
}

@end

@implementation ChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _jiaGeDic = [[NSMutableDictionary alloc]init];
    _buyJiaARR = [[NSMutableArray alloc]initWithCapacity:6];
    _cardNumARRS = @[@"30",@"50",@"100",@"200",@"300",@"500"];
    _phoneJiaGeARR = [[NSMutableArray alloc]init];
    
    
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shoujiPaySuccess:) name:SHOUJI_CHONGZHI_PAYSUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shoujiPayFail:) name:SHOUJI_CHONGZHI_PAY_FAIL_NOTIFICATION object:nil];
}
- (void)shoujiPaySuccess:(id)sender{

    //[MBProgressHUD showSuccess:@"充值成功" toView:self.view];
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"充值成功";
    [_hud hide:YES afterDelay:2];
    
}

- (void)shoujiPayFail:(id)sender{
    //[MBProgressHUD showSuccess:@"充值失败" toView:self.view];
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"充值失败";
    [_hud hide:YES afterDelay:2];
}



- (void)textChangeAction:(id)sender{

    if ([self panDuanPhoneIsYesOrNO]) {
        
        //检测是否可以充值
        /*
        NSLog(@"_cardNumARRS的个数为：%ld",_cardNumARRS.count);
        for (int i = 0; i<_cardNumARRS.count; i++) {
            NSLog(@"执行了：%d",i);
            NSString * card = _cardNumARRS[i];
            //[self yunYingShang:self.phoneTextField.text withCardNum:[card intValue] withIndex:i];
        }
        */
        [self getPhoneInfo:self.phoneTextField.text];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self panDuanPhoneIsYesOrNO]) {
        /*
        //检测是否可以充值
        NSLog(@"_cardNumARRS的个数为：%ld",_cardNumARRS.count);
        for (int i = 0; i<_cardNumARRS.count; i++) {
            NSLog(@"执行了：%d",i);
            NSString * card = _cardNumARRS[i];
            //[self yunYingShang:self.phoneTextField.text withCardNum:[card intValue] withIndex:i];
        }
        */
        [self getPhoneInfo:self.phoneTextField.text];

        
    }

    
    
}

//手机充值查询接口
- (void)getPhoneInfo:(NSString *)phoneNum{
    //手机充值  查询
//#define SHOUJI_CHONGZHI_CHAXUN_URLString    ZHOULU_ML_BASE_URLString@"/api.php?m=recharge&s=phone_recharge&action=query"
    NSDictionary * ret = @{@"mobile":phoneNum};
    NSLog(@"充值的手机号为：%@",phoneNum);
    [MLHttpManager post:SHOUJI_CHONGZHI_CHAXUN_URLString params:ret m:@"recharge" s:@"phone_recharge" success:^(id responseObject) {
        NSLog(@"手机充值查询：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary * dataDic = result[@"data"];
            if ([dataDic[@"shop_delall"] isKindOfClass:[NSArray class]]) {
                
                [_phoneJiaGeARR addObjectsFromArray:dataDic[@"shop_delall"]];
                
                [self updataView];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"手机充值查询错误：%@",error);
    }];
    
    
}

- (void)updataView{

    for (int i = 0; i< _phoneJiaGeARR.count; i++) {
        if (i == 0) {
            
        }
        if (i == 1) {
            
        }
        if (i == 2) {
            
        }
        if (i == 3) {
            
        }
        if (i == 4) {
            
        }
        if (i == 5) {
            
        }
        
    }


}

/*

 
 //手机充值 下单
 #define SHOUJI_CHONGZHI_XIADAN_URLString    ZHOULU_ML_BASE_URLString@"/api.php?m=recharge&s=phone_recharge&action=inorder"
 
 */


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
- (void)yunYingShang:(NSString *)phoneNum withCardNum:(int)cardNum withIndex:(int) index{
//http://op.juhe.cn/ofpay/mobile/telquery?cardnum=30&phoneno=18913515635&key=您申请的KEY
    //static int i = 0;
    NSString * urlStr = [NSString stringWithFormat:@"http://op.juhe.cn/ofpay/mobile/telquery?cardnum=%d&phoneno=%@&key=750c0694e48f04e9b1f5a5b1db118eee",cardNum,phoneNum];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"聚合数据请求：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        if([result[@"error_code"] isEqual:@0]){
            NSDictionary * data = result[@"result"];
            if (data[@"game_area"]) {
                //if (i == 0) {
                     self.cardTypeLabel.text = data[@"game_area"];
                    
                //}
                //i++;
                
                
            }
            if (data[@"inprice"]) {
                
                NSString * str = [NSString stringWithFormat:@"%g",[data[@"inprice"] floatValue]];
                //[_buyJiaARR addObject:str];
                if (index == 0) {
                    self.firstJiaGeLabel.text = [NSString stringWithFormat:@"售价:%@元",str];
                    
                }
                if (index == 1) {
                     self.secondJiaGeLabel.text = [NSString stringWithFormat:@"售价:%@元",str];
                    
                }
                if (index == 2) {
                     self.thirdJiaGeLabel.text = [NSString stringWithFormat:@"售价:%@元",str];
                }
                if (index == 3) {
                     self.fourJiaGeLabel.text = [NSString stringWithFormat:@"售价:%@元",str];
                }
                if (index == 4) {
                     self.fiveJiaGeLabel.text = [NSString stringWithFormat:@"售价:%@元",str];
                }
                if (index == 5) {
                     self.sixJiaGeLabel.text = [NSString stringWithFormat:@"售价:%@元",str];
                }
                [_jiaGeDic setObject:str forKey:_cardNumARRS[index]];
                NSLog(@"index++++:%d",index);
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
        NSLog(@"实际充值金额：%@", _jiaGeDic[@"10"]);
        [self someButtonClickedwithTitle:_jiaGeDic[@"10"]];
        
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)secondViewAction:(UIControl *)sender {
     NSLog(@"第2个");
    if ([self panDuanPhoneIsYesOrNO]) {
        NSLog(@"实际充值金额：%@", _jiaGeDic[@"20"]);
        [self someButtonClickedwithTitle:_jiaGeDic[@"20"]];
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)thirdViewAction:(UIControl *)sender {
     NSLog(@"第3个");
    if ([self panDuanPhoneIsYesOrNO]) {
        NSLog(@"实际充值金额：%@", _jiaGeDic[@"30"]);
        [self someButtonClickedwithTitle:_jiaGeDic[@"30"]];
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)fourViewAction:(UIControl *)sender {
     NSLog(@"第4个");
    if ([self panDuanPhoneIsYesOrNO]) {
        NSLog(@"实际充值金额：%@", _jiaGeDic[@"50"]);
        [self someButtonClickedwithTitle:_jiaGeDic[@"50"]];
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)fiveViewAction:(UIControl *)sender {
     NSLog(@"第5个");
    if ([self panDuanPhoneIsYesOrNO]) {
        NSLog(@"实际充值金额：%@", _jiaGeDic[@"100"]);
        [self someButtonClickedwithTitle:_jiaGeDic[@"100"]];
    }
    else{
        [MBProgressHUD showSuccess:@"手机号格式错误" toView:self.view];
    }
}
- (IBAction)sixViewAction:(UIControl *)sender {
     NSLog(@"第6个");
    if ([self panDuanPhoneIsYesOrNO]) {
        NSLog(@"实际充值金额：%@", _jiaGeDic[@"300"]);
        [self someButtonClickedwithTitle:_jiaGeDic[@"300"]];
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
        
        if ([self panDuanPhoneIsYesOrNO]) {
            
            //检测是否可以充值
            NSLog(@"_cardNumARRS的个数为：%ld",_cardNumARRS.count);
            for (int i = 0; i<_cardNumARRS.count; i++) {
                NSLog(@"执行了：%d",i);
                NSString * card = _cardNumARRS[i];
                //[self yunYingShang:self.phoneTextField.text withCardNum:[card intValue] withIndex:i];
            }
    
        }

    }];
}

- (BOOL)panDuanPhoneIsYesOrNO{
    
    BOOL result = [HFSUtility validateMobile:self.phoneTextField.text];
    return result;
}


- (void)someButtonClickedwithTitle:(NSString *)titles {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"支付宝" otherButtonTitles:nil,nil];
    //sheet.destructiveButtonIndex = 1;
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击了第几个按钮result = %d", (int)buttonIndex);
    if(buttonIndex == 0){

        NSLog(@"微信");
     
        MLShouJiZhiViewController *vc = [[MLShouJiZhiViewController alloc]init];
        vc.view.backgroundColor = [UIColor clearColor];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
        }
        
        vc.type = 0;
        vc.jinE = 0.01;
        vc.orderNum = [NSString stringWithFormat:@"%d",arc4random()%10000];
        NSLog(@"self.orderNum的值为：%@",vc.orderNum);
        [self presentViewController:vc  animated:NO completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             [vc zhifuwith:0];
//             vc.type = 0;
//             vc.jinE = 0.01;
//             vc.orderNum = [NSString stringWithFormat:@"%d",arc4random()%10000];
             
         }];
        
        
    }
    else if (buttonIndex == 1){
        
        NSLog(@"支付宝");
    }
    else if (buttonIndex == 2){
        NSLog(@"银联");
    }
    else if(buttonIndex == 3){
        NSLog(@"APPLE PAY");
    
    }
    
    
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

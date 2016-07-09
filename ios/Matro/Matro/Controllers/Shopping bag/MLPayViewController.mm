//
//  MLPayViewController.m
//  Matro
//
//  Created by NN on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPayViewController.h"
#import "MLPayTableViewCell.h"
#import "AppDelegate.h"
#import "HFSConstants.h"
#import "UIColor+HeinQi.h"
#import "MLPayresultViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayOrder.h"
#import "HFSServiceClient.h"
#import "GTMNSString+URLArguments.h"
#import <PassKit/PassKit.h>
#import "MLShopBagViewController.h"
#import "MBProgressHUD+Add.h"

#import "UPAPayPlugin.h"
//#import <PassKit/PassKit.h>
#define kAppleMerchantID @"merchant.com.matro"

@interface MLPayViewController ()<UITableViewDataSource,UITableViewDelegate,UPAPayPluginDelegate
,PKPaymentAuthorizationViewControllerDelegate
>{
    NSMutableArray *_payTitleArray;
    NSMutableArray *_payImageArray;
}
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MLPayViewController


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收银台";
    
    UIBarButtonItem * button = [[UIBarButtonItem alloc]initWithTitle:@"我的订单" style:UIBarButtonItemStylePlain target:self action:@selector(productlistsAction)];
    button.tintColor = [UIColor colorWithHexString:@"AE8E5D"];
    self.navigationItem.rightBarButtonItem = button;
    if (_paramDic) {
        self.priceLabel.text = _paramDic[@"totalFee"];
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_paramDic[@"totalFee"]];
    }
    else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderDetail.DDJE];

    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shangyiye_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = item;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayResult:) name:kNOTIFICATIONWXPAY object:nil];
    
    
    

    _payImageArray = [NSMutableArray array];
    _payTitleArray = [NSMutableArray array];
    
    [_payTitleArray addObject:@"支付宝"];
    [_payImageArray addObject:@"zhifubao-1"];
    
    if (!_isGlobal) {
        [_payTitleArray addObject:@"微信支付"];
        [_payImageArray addObject:@"weixin"];
    }
    
    [_payTitleArray addObject:@"银联支付"];
    [_payImageArray addObject:@"yinglian"];
    
    // 暂时隐藏
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        [_payTitleArray addObject:@"Apple Pay"];
        [_payImageArray addObject:@"applepay"];
    }
    
    
    _tableView.tableFooterView = [[UIView alloc]init];
}


- (void)wxPayResult:(NSNotification *)notification{
    
    PayResp *resp = (PayResp *)notification.object;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
            {
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"付款成功";
                [_hud show:YES];
                [_hud hide:YES afterDelay:1];
            }
                
                break;
                
            default:
            {
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"付款失败";
                [_hud show:YES];
                [_hud hide:YES afterDelay:1];
            }
                break;
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)goBack{
    UIViewController *vc = [self.navigationController.viewControllers firstObject];
    if ([vc isKindOfClass:[MLShopBagViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)productlistsAction{
    
    if ([self getAppDelegate].tabBarController.selectedIndex == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self getAppDelegate].tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOTO_ODRE_LISTS object:nil];
    }

}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _payTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLPayTableViewCell" ;
    MLPayTableViewCell *cell = (MLPayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.payImageView.image = [UIImage imageNamed:_payImageArray[indexPath.row]];
    cell.payLabel.text = _payTitleArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        [self alipayPost];
    }
    else{
        NSString *titleStr = [_payTitleArray objectAtIndex:indexPath.row];
        if ([titleStr isEqualToString:@"微信支付"]) {
            
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                [self wxPayPost];
            }
            else{
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请安装微信";
                [_hud hide:YES afterDelay:2];
            }
            
        }
        else if ([titleStr isEqualToString:@"银联支付"]){
            [self upPayPost];
        }
        else if ([titleStr isEqualToString:@"Apple Pay"]){
            [self applepay];
        }
    }
    
}


-(void)alipayPost
{
    NSString *totalpay;
    NSString *outtradenum;
    if (_paramDic) {
        totalpay = _paramDic[@"totalFee"];
        outtradenum = _paramDic[@"order_trade_no"];
    }
    else
    {
        totalpay=[NSString stringWithFormat:@"%.2f",_orderDetail.DDJE];
        outtradenum =_orderDetail.JLBH?:@"";
    }
    NSDictionary *dic = @{@"out_trade_no":outtradenum,
                          @"subject":@"美罗全球精品购",
                          @"body":@"美罗全球精品购",
                          @"total_fee":totalpay
                          };
    
    
    [[HFSServiceClient sharedPayClient] POST:@"app/alipay" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"result %@",result);
        
        if (result) {
            
            AliPayOrder *order = [[AliPayOrder alloc] init];
            order.partner = result[@"partner"];
            order.seller = result[@"seller_id"];
            order.tradeNO = result[@"out_trade_no"];
            order.productName = result[@"subject"];
            order.productDescription = result[@"body"];
            order.amount = result[@"total_fee"];
            order.notifyURL = result[@"notify_url"];
            order.service = result[@"service"];
            order.paymentType = result[@"payment_type"];
            order.inputCharset = result[@"_input_charset"];
            order.itBPay = result[@"it_b_pay"];
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSString *signedString =result[@"sign"];
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            NSString *appScheme = @"Matro";
            if (signedString != nil) {
                signedString = [signedString gtm_stringByEscapingForURLArgument];

                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                NSLog(@"%@",orderString);
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    if ([resultDic[@"resultStatus"] intValue]==9000) {
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = resultDic[@"memo"];
                        [_hud hide:YES afterDelay:2];

                        
                    }
                    else{
                        NSString *resultMes = resultDic[@"memo"];
                        resultMes = (resultMes.length<=0?@"支付失败":resultMes);
                    }
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}

#pragma mark apple pay delegate
- (void)applepay
{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        [[HFSServiceClient sharedPayClient]POST:@"app/v200/unionpay" parameters:@{@"orderid":self.order_id?:@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
//        if([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]])
//        {
//            [UPAPayPlugin startPay:@"dingdan" mode:@"00" viewController:self delegate:self andAPMechantID:kAppleMerchantID];
//        }
    } else {
        [MBProgressHUD showMessag:@"您的设备暂不支持ApplePay" toView:self.view];
    }
}

#pragma mark apple pay delegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);
    
    // do an async call to the server to complete the payment.
    // See PKPayment class reference for object parameters that can be passed
    BOOL asyncSuccessful = FALSE;
    
    // When the async call is done, send the callback.
    // Available cases are:
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully.
    //    PKPaymentAuthorizationStatusFailure, // Merchant failed to auth the transaction.
    //
    //    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,  // Merchant refuses service to this billing address.
    //    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // Merchant refuses service to this shipping address.
    //    PKPaymentAuthorizationStatusInvalidShippingContact        // Supplied contact information is insufficient.
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was successful");
        
        //        [Crittercism endTransaction:@"checkout"];
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was unsuccessful");
        
        //        [Crittercism failTransaction:@"checkout"];
    }
    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}



#pragma mark wxPay

- (void)wxPayPost{
    NSString *totalpay;
    NSString *outtradenum;
    if (_paramDic) {
        totalpay = _paramDic[@"totalFee"];
        outtradenum = _paramDic[@"order_trade_no"];
    }
    else
    {
        totalpay=[NSString stringWithFormat:@"%.2f",_orderDetail.DDJE];
        outtradenum =_orderDetail.JLBH?:@"";
    }

    NSDictionary *dict = @{@"orderid":outtradenum?:@"",@"goods_name":@"美罗全球购",@"totalfee":totalpay?:@"",@"ip":@"",@"wxid":@"6"};
    NSLog(@"%@",dict);
    
    
    [[HFSServiceClient sharedPayClient] POST:@"app/wxpay" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = (NSDictionary *)responseObject;
        NSString *noncestr = [data objectForKey:@"noncestr"];
        NSString *partnerid = [data objectForKey:@"partnerid"];
        NSString *prepayid = [data objectForKey:@"prepayid"];
        NSString *timestamp = [data objectForKey:@"timestamp"];
        NSString *sign = [data objectForKey:@"sign"];
        NSString *package = [data objectForKey:@"package"];
        
        PayReq *req             = [[PayReq alloc] init];
        req.partnerId           = partnerid;
        req.prepayId            = prepayid;
        req.nonceStr            = noncestr;
        req.timeStamp           = [timestamp intValue];
        req.package             = package;
        req.sign                = sign;
        [WXApi sendReq:req];

        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}


#pragma mark 银联支付
- (void)upPayPost{
    NSString *totalpay;
    NSString *outtradenum;
    if (_paramDic) {
        totalpay = _paramDic[@"totalFee"];
        outtradenum = _paramDic[@"order_trade_no"];
    }
    else
    {
        totalpay=[NSString stringWithFormat:@"%.2f",_orderDetail.DDJE];
        outtradenum =_orderDetail.JLBH?:@"";
    }
    
    NSDictionary *dict = @{@"txnAmt":totalpay?:@"",@"orderId":outtradenum?:@"",@"orderDesc":@"美罗全球购"};
    [[HFSServiceClient sharedPayClient]POST:@"app/unionpay" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *tn = [responseObject objectForKey:@"tn"];
//        [UPPayPlugin startPay:tn mode:@"01" viewController:self delegate:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

}




#pragma mark - UPPayPluginDelegate
-(void)UPPayPluginResult:(NSString *)result {
    NSLog(@"%@", result);
    
    if ([result isEqualToString:@"success"]) {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"付款成功";
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
    } else if ([result isEqualToString:@"fail"]) {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"付款失败";
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
    } else if ([result isEqualToString:@"cancel"]) {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"付款被取消";
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
    }
}



- (void)showHudString:(NSString *)hud{
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = hud;
    [_hud show:YES];
    [_hud hide:YES afterDelay:1];
}

@end

//
//  MLShouJiZhiViewController.m
//  Matro
//
//  Created by lang on 16/7/19.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShouJiZhiViewController.h"
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
#import "UPPaymentControl.h"
#import "UPAPayPlugin.h"
//#import <PassKit/PassKit.h>
#import "MLHttpManager.h"

#define kAppleMerchantID @"merchant.Matro"


@interface MLShouJiZhiViewController ()<UPAPayPluginDelegate,PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation MLShouJiZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    //[self zhifuwith:self.type];
}

- (void)zhifuwith:(int)index{

    if (index == 0) {
        [self alipayPost];
    }
    if (index == 1) {
        
    }
    if (index == 2) {
        
    }
    if (index == 3) {
        
    }
}
-(void)alipayPost
{

    
    
//    NSDictionary * ret = @{@"order_id":self.orderNum,@"payment_type":@"alipay"};
//    [MLHttpManager post:ZhiFu_LIUSHUI_URLString params:ret m:@"product" s:@"pay" success:^(id responseObject) {
//        NSDictionary * results = (NSDictionary *)responseObject;
//        NSLog(@"请求订单流水：%@",results);
//        if ([results[@"code"] isEqual:@0]) {
            NSDictionary *dic = @{@"out_trade_no":self.orderNum,
                                  @"subject":@"话费充值",
                                  @"body":@"话费充值",
                                  @"total_fee":[NSString stringWithFormat:@"%.2f",self.jinE]
                                  };
            
            
            [[HFSServiceClient sharedPayClient] POST:ALIPAY_HUAFEI_URL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *result = (NSDictionary *)responseObject;
                NSLog(@"支付宝支付result %@",result);
                [self hideFengHuoLun];
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
                        NSLog(@"支付宝支付签名%@",orderString);
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            
                            if ([resultDic[@"resultStatus"] intValue]==9000) {
                                [_hud show:YES];
                                _hud.mode = MBProgressHUDModeText;
                                _hud.labelText = resultDic[@"memo"];
                                [_hud hide:YES afterDelay:2];
                                /*
                                MLPayresultViewController * payResultVC = [[MLPayresultViewController alloc]init];
                                payResultVC.hidesBottomBarWhenPushed = YES;
                                payResultVC.isSuccess = YES;
                                payResultVC.order_id = self.order_id;
                                [self.navigationController pushViewController:payResultVC animated:YES];
                                */
                                [[NSNotificationCenter defaultCenter] postNotificationName:SHOUJI_CHONGZHI_PAYSUCCESS_NOTIFICATION object:nil];
                            }
                            else{
                                /*
                                NSString *resultMes = resultDic[@"memo"];
                                resultMes = (resultMes.length<=0?@"支付失败":resultMes);
                                MLPayShiBaiViewController * shiBaiVC = [[MLPayShiBaiViewController alloc]init];
                                shiBaiVC.hidesBottomBarWhenPushed = YES;
                                
                                [self.navigationController pushViewController:shiBaiVC animated:YES];
                                */
                                [[NSNotificationCenter defaultCenter] postNotificationName:SHOUJI_CHONGZHI_PAY_FAIL_NOTIFICATION object:nil];
                            }
                            NSLog(@"支付宝支付结果reslut = %@",resultDic);
                        }];
                    }
                }
                
                 [self dismissViewControllerAnimated:NO completion:nil];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hideFengHuoLun];
                [_hud show:YES];
                NSLog(@"error kkkk %@",error);
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = REQUEST_ERROR_ZL;
                [_hud hide:YES afterDelay:2];
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOUJI_CHONGZHI_PAY_FAIL_NOTIFICATION object:nil];
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
            
            
//        }
//        
//    } failure:^(NSError *error) {
//        [self hideFengHuoLun];
//        [_hud show:YES];
//        NSLog(@"error kkkk %@",error);
//        _hud.mode = MBProgressHUDModeText;
//        _hud.labelText = REQUEST_ERROR_ZL;
//        [_hud hide:YES afterDelay:2];
//    }];

    
}




//显示 风火轮
- (void)showFengHuoLun{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
}

//隐藏 风火轮
- (void)hideFengHuoLun{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self closeLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

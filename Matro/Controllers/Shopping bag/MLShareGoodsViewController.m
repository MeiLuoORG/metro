//
//  MLShareGoodsViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShareGoodsViewController.h"
#import "UMSocial.h"
#import "MBProgressHUD+Add.h"

@interface MLShareGoodsViewController (){
    
    NSString *share_Url;
}

@property (weak, nonatomic) IBOutlet UIView *shareBgView;

@end

@implementation MLShareGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.shareBgView.layer.masksToBounds = YES;
    self.shareBgView.layer.cornerRadius = 3.f;
    
    if ([_paramDic[@"ZCSP"] isEqualToString:@"5"]) {
        share_Url = [NSString stringWithFormat:@"http://m.matrojp.com/products/products_hwg.aspx?JMSP_ID=%@",_paramDic[@"JMSP_ID"]];
    }
    else{
        share_Url = [NSString stringWithFormat:@"http://m.matrojp.com/products/products_cs.aspx?JMSP_ID=%@",_paramDic[@"JMSP_ID"]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)weixinClick:(id)sender {
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:share_Url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
           [self showSuccess];
        }
    }];
}
- (IBAction)bengyouquanClick:(id)sender {
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:share_Url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self showSuccess];
        }
    }];
}
- (IBAction)qqClick:(id)sender {
    
    [UMSocialData defaultData].extConfig.qqData.url = share_Url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:share_Url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self showSuccess];
        }
    }];
    
}
- (IBAction)qzoneClick:(id)sender {
    
    [UMSocialData defaultData].extConfig.qzoneData.url = share_Url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:share_Url image:self.qzoneImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self showSuccess];
        }
    }];
}


- (void)showSuccess{
    [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
    [self performSelector:@selector(closeWindow) withObject:nil afterDelay:1];
}

- (void)closeWindow{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)erweimaClick:(id)sender { //二维码分享
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.erweimaBlock) {
            self.erweimaBlock();
        }
    }];
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeWindow:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)dealloc{
    NSLog(@"已销毁");
}





@end

//
//  CityFuWuViewController.m
//  Matro
//
//  Created by lang on 16/7/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "CityFuWuViewController.h"
#import "MLLoginViewController.h"

@interface CityFuWuViewController (){

    NSString * _phoneStr;
    int _cardNum;
}

@end

@implementation CityFuWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HFSUtility hexStringToColor:@"f1f1f1"];
    _phoneStr = @"18868672308";
    _cardNum = 100;
    
    //http://bbctest.matrojp.com/api.php?m=product&s=webframe&method=cityservice
    
    
    
    [self qingqiuImage];
    // Do any additional setup after loading the view from its nib.
}


- (void)qingqiuImage{

    NSString * urls = [NSString stringWithFormat:@"%@/api.php?m=product&s=webframe&method=cityservice",ZHOULU_ML_BASE_URLString];
    [MLHttpManager get:urls params:nil m:@"product" s:@"webframe" success:^(id responseObject) {
        NSDictionary * result = (NSDictionary *)responseObject;
        NSLog(@"城市服务图片：%@",result);
        if ([result[@"code"] isEqual:@0]) {
            if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dataDic = result[@"data"];
                if ([dataDic[@"cityservice"] isKindOfClass:[NSArray class]]) {
                    NSArray * arr = dataDic[@"cityservice"];
                    
                    if (arr.count > 0) {
                        
                        NSDictionary * dicss = arr[0];
                        NSString * imageURL = dicss[@"imgurl"];
                        if (![imageURL isEqualToString:@""]) {
                            if ([imageURL hasSuffix:@"webp"]) {
                                
                                [self.topImageView setZLWebPImageWithURLStr:imageURL withPlaceHolderImage:PLACEHOLDER_IMAGE];
                                
                            } else {
                                [self.topImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"cityfuwu02.jpg"]];
     
                            }
                            
                        }
                        
                    }
                    
                    
                }
            }

        }else if ([result[@"code"]isEqual:@1002]){
        
            [MBProgressHUD show:@"登录超时，请重新登录" view:self.view];
            [self loginAction:nil];
    }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    

}

- (IBAction)shoujiAction:(UIControl *)sender {
    
    NSLog(@"手机充值");
    //750c0694e48f04e9b1f5a5b1db118eee
/*
    //打卡签到
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    NSLog(@"loginid的值为：%@",loginid);
    if (loginid && ![@"" isEqualToString:loginid]) {
        ChongZhiViewController * vc = [[ChongZhiViewController alloc]init];
        vc.title = @"手机充值";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(daKaQianDao) name:RENZHENG_LIJIA_Notification object:nil];
        MLLoginViewController * loginVC = [[MLLoginViewController alloc]init];
        loginVC.isLogin = YES;
        [self presentViewController:loginVC animated:NO completion:nil];
        
    }
    */
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"该服务暂未开启" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [self.view addSubview:alert];
    [alert show];
}

- (void)qingqiuJuHe{
    //http://op.juhe.cn/ofpay/mobile/telcheck?cardnum=100&phoneno=13429667914&key=您申请的KEY


}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
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

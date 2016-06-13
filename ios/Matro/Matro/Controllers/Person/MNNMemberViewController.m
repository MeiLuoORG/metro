//
//  MNNMemberViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNMemberViewController.h"
#import "MNNQRCodeViewController.h"
#import "MNNPurchaseHistoryViewController.h"
#import "MNNBindCardViewController.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "CommonHeader.h"
@interface MNNMemberViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    UIImageView *_membershipCard;//VIP标志图
    UILabel *_label;
    UIView *_backgroundView;
    UILabel *_preferentialRules;//优惠规则内容
    UIButton *btnTitle;
    UIButton *btnSelect;
    UIScrollView *scrollview;
    UIPageControl *pageControl;
    MBProgressHUD *_hud;
    
    UILabel * _ValidCentSLabel;//可用积分
}

@end

@implementation MNNMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的会员卡";

    self.moRenIndex = 0;
    self.currentCardIndex = 0;
    self.cardARR = [[NSMutableArray alloc]init];
    
    _ValidCentSLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_WIDTH-100, 10,70 , 20)];
    _ValidCentSLabel.textAlignment = NSTextAlignmentRight;
    _ValidCentSLabel.text = @"0001";
    _ValidCentSLabel.font = [UIFont systemFontOfSize:12];
    _ValidCentSLabel.alpha = 0.5;

    

    /*

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"绑定会员卡" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];

    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];


    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
     */

    [self createTableView];
    // Do any additional setup after loading the view.
    [self loadData];
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
}

- (void)buttonAction {
    /*
    self.hidesBottomBarWhenPushed = YES;
    MNNBindCardViewController *bindCradVC = [MNNBindCardViewController new];
    [self.navigationController pushViewController:bindCradVC animated:YES];
     */

}

#pragma mark 获取会员  会员卡信息
- (void)loadData {
    /*
     zhoulu
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    //{"appId": "test0002","phone":"18020260894","sign":$sign,"accessToken":$accessToken}
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":phone}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"phone":phone,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };

    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:VIPInfo_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary * userDataDic = result[@"data"];
        NSLog(@"获取会员卡信息%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            //vipCard
            NSArray * vipCardARR = userDataDic[@"vipCard"];
            if (vipCardARR.count > 0) {
                
                for (NSDictionary * dics  in vipCardARR) {
                    
                    if ([[NSString stringWithFormat:@"%@",dics[@"isDefault"]] isEqualToString:@"1"]) {
                        VipCardModel * cardModel = [[VipCardModel alloc]init];
                        cardModel.cardNo = dics[@"cardNo"];
                        cardModel.cardTypeIdString = dics[@"cardTypeId"];
                        cardModel.isDefault = [dics[@"isDefault"] intValue];
                        [self.cardARR addObject:cardModel];
                        //请求默认卡的信息
                        [self getCardInfowithcardNo:cardModel.cardNo];
                    }
                    
                }
                for (NSDictionary * dics  in vipCardARR) {
                    
                    if ([[NSString stringWithFormat:@"%@",dics[@"isDefault"]] isEqualToString:@"0"]) {
                        VipCardModel * cardModel = [[VipCardModel alloc]init];
                        cardModel.cardNo = dics[@"cardNo"];
                        cardModel.cardTypeIdString = dics[@"cardTypeId"];
                        cardModel.isDefault = [dics[@"isDefault"] intValue];
                        [self.cardARR addObject:cardModel];
                    }
                    
                }
                [self updataCardScrollView];
                
            }
            else{
            
            
            }
            
            
            
        }else{
            /*
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
            */
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"账户已过期" message:nil delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}

/*
#pragma mark 获取会员详细信息
- (void)getCardInfowithcardNo:(NSString *)cardno{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    //{"appId": "test0002","phone":"18020260894","sign":$sign,"accessToken":$accessToken}
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"cardNo":cardno}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"cardNo":cardno,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:VIPCardJiFen_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary * userDataDic = result[@"data"];
        NSLog(@"获取会员卡信息%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            //vipCard
            //ValidCent
            //_ValidCentString = userDataDic[@"ValidCent"];
            _ValidCentSLabel.text = userDataDic[@"ValidCent"];
            //[_tableView reloadData];
            //[self.view layoutIfNeeded];
            //[self.view setNeedsLayout];
            //[self.view setNeedsDisplay];
        }else{
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
            
            /*
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"账户已过期" message:nil delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
             [alert show];
             */

/*
}

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

}
*/
//更新会员卡图片
- (void)updataCardScrollView{

    scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH)*self.cardARR.count, 190);
    UIImageView * bkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, scrollview.contentSize.width, 110)];
    bkView.backgroundColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    [scrollview addSubview:bkView];
    
    for (int i=0; i<self.cardARR.count; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20+(MAIN_SCREEN_WIDTH)*(i), 20, MAIN_SCREEN_WIDTH-40, 150)];
        
        NSString *str=[NSString stringWithFormat:@"%d.JPG",i];
        
        imageView.image=[UIImage imageNamed:str];
        //加阴影 zhou
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        imageView.layer.shadowOffset = CGSizeMake(8,8);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        imageView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        imageView.layer.shadowRadius = 7;//阴影半径，默认3
        
        [scrollview addSubview:imageView];
    }


}


/*

#pragma mark 获取会员  会员卡信息

- (void)loadData {
    /*
     zhoulu
     */
/*
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    //{"appId": "test0002","phone":"18020260894","sign":$sign,"accessToken":$accessToken}
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":phone}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"phone":phone,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };

    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:VIPInfo_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary * userDataDic = result[@"data"];
        NSLog(@"获取会员卡信息%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            //vipCard
            NSArray * vipCardARR = userDataDic[@"vipCard"];
            if (vipCardARR.count > 0) {
                
                for (NSDictionary * dics  in vipCardARR) {
                    
                    if ([[NSString stringWithFormat:@"%@",dics[@"isDefault"]] isEqualToString:@"1"]) {
                        VipCardModel * cardModel = [[VipCardModel alloc]init];
                        cardModel.cardNo = dics[@"cardNo"];
                        cardModel.cardTypeIdString = dics[@"cardTypeId"];
                        cardModel.isDefault = [dics[@"isDefault"] intValue];
                        [self.cardARR addObject:cardModel];
                        //请求默认卡的信息
                        [self getCardInfowithcardNo:cardModel.cardNo];
                    }
                    
                }
                for (NSDictionary * dics  in vipCardARR) {
                    
                    if ([[NSString stringWithFormat:@"%@",dics[@"isDefault"]] isEqualToString:@"0"]) {
                        VipCardModel * cardModel = [[VipCardModel alloc]init];
                        cardModel.cardNo = dics[@"cardNo"];
                        cardModel.cardTypeIdString = dics[@"cardTypeId"];
                        cardModel.isDefault = [dics[@"isDefault"] intValue];
                        [self.cardARR addObject:cardModel];
                    }
                    
                }
                [self updataCardScrollView];
                
            }
            else{
            
            
            }
            
            
            
        }else{
 */
            /*
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
            */
/*
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"账户已过期" message:nil delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];


}

*/

#pragma mark 获取会员详细信息
- (void)getCardInfowithcardNo:(NSString *)cardno{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    //{"appId": "test0002","phone":"18020260894","sign":$sign,"accessToken":$accessToken}
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"cardNo":cardno}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"cardNo":cardno,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:VIPCardJiFen_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary * userDataDic = result[@"data"];
        NSLog(@"获取会员卡信息%@",result);
        if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
            //vipCard
            //ValidCent
            //_ValidCentString = userDataDic[@"ValidCent"];
            _ValidCentSLabel.text = userDataDic[@"ValidCent"];
            //[_tableView reloadData];
            //[self.view layoutIfNeeded];
            //[self.view setNeedsLayout];
            //[self.view setNeedsDisplay];
        }else{
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"errMsg"];
            [_hud hide:YES afterDelay:2];
            
            /*
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"账户已过期" message:nil delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
             [alert show];
             */
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
    

}


//更新会员卡图片
- (void)updataCardScrollView{

    scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH)*self.cardARR.count, 190);
    UIImageView * bkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, scrollview.contentSize.width, 110)];
    bkView.backgroundColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    [scrollview addSubview:bkView];
}



#pragma mark 获取用户信息
- (void)loadDate {

    
    for (int i=0; i<self.cardARR.count; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20+(MAIN_SCREEN_WIDTH)*(i), 20, MAIN_SCREEN_WIDTH-40, 150)];
        
        NSString *str=[NSString stringWithFormat:@"%d.JPG",i];
        
        imageView.image=[UIImage imageNamed:str];
        //加阴影 zhou
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        imageView.layer.shadowOffset = CGSizeMake(8,8);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        imageView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        imageView.layer.shadowRadius = 7;//阴影半径，默认3
        
        [scrollview addSubview:imageView];
    }


}



- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-20) style:UITableViewStyleGrouped];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 230)];
    UIView *sedbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, MAIN_SCREEN_WIDTH, 160)];
    sedbackgroundView.backgroundColor = [UIColor lightGrayColor];
    [_backgroundView addSubview:sedbackgroundView];
    
    //    _membershipCard = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, MAIN_SCREEN_WIDTH-40, 150)];
    //    [_backgroundView addSubview:_membershipCard];
    

    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 190)];
    

    

    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 190)];

    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(20, 20, MAIN_SCREEN_WIDTH-40, 170)];

    

    

    scrollview.backgroundColor=[UIColor whiteColor];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.bounces = NO;
    scrollview.pagingEnabled=YES;
    scrollview.delegate=self;
    scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH)*1, 190);
    
    
    /*
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(80, 140, MAIN_SCREEN_WIDTH-160, 30)];


    scrollview.pagingEnabled=YES;
    scrollview.delegate=self;
    scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH)*1, 190);
    
    
    /*
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(80, 140, MAIN_SCREEN_WIDTH-160, 30)];

    
    for (int i=0; i<4; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0+(MAIN_SCREEN_WIDTH-40)*(i), 0, MAIN_SCREEN_WIDTH-40, 170)];
        
        NSString *str=[NSString stringWithFormat:@"%d.JPG",i];
        
        imageView.image=[UIImage imageNamed:str];
        
        [scrollview addSubview:imageView];
    }
    
    scrollview.pagingEnabled=YES;
    scrollview.delegate=self;
    scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH-40)*4, 170);
    
    
    
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(80, 160, MAIN_SCREEN_WIDTH-160, 30)];

    
    pageControl.numberOfPages=4;
    
    pageControl.currentPage=0;
    
    pageControl.pageIndicatorTintColor=[UIColor greenColor];
    
    pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    */
    
    //背景色块
    UIImageView * bkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, scrollview.contentSize.width, 110)];
    bkView.backgroundColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    [scrollview addSubview:bkView];

    for (int i=0; i<1; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20+(MAIN_SCREEN_WIDTH)*(i), 20, MAIN_SCREEN_WIDTH-40, 150)];
        
        NSString *str=[NSString stringWithFormat:@"%d.JPG",i];
        
        imageView.image=[UIImage imageNamed:str];
        /*
        //加阴影 zhou
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        imageView.layer.shadowOffset = CGSizeMake(10,10);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        imageView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        imageView.layer.shadowRadius = 10;//阴影半径，默认3
        */
        [scrollview addSubview:imageView];
    }
    
    [_backgroundView addSubview:scrollview];

    //[_backgroundView addSubview:pageControl];


    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(scrollview.frame)+10, 70, 20)];
    [btnSelect setTitle:@"设为默认" forState:UIControlStateNormal];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSelect.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    btnSelect.selected  = YES;

    [_backgroundView addSubview:pageControl];
    
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(scrollview.frame)+15, MAIN_SCREEN_WIDTH-160, 20)];
    btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(32, CGRectGetMaxY(scrollview.frame)+15, 60, 20)];
    [btnTitle setTitle:@"设为默认" forState:UIControlStateNormal];
    [btnTitle.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(scrollview.frame)+19, 12, 12)];
    btnSelect.selected  = NO;

    [btnSelect setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    [btnSelect setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    [btnSelect setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    
    [btnSelect addTarget:self action:@selector(actSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(scrollview.frame)+10, MAIN_SCREEN_WIDTH-160, 20)];
    _label.text = @"使用时向服务员出示二维码";
    _label.font = [UIFont systemFontOfSize:12];
    _label.textAlignment = NSTextAlignmentCenter;
    
    
    /*
     if (_membershipCard.image == nil) {
     _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame)+20, MAIN_SCREEN_WIDTH, 20)];
     _label.text = @"您还没有会员卡，绑定即可享受线上优惠";
     _label.font = [UIFont systemFontOfSize:12];
     _label.textAlignment = NSTextAlignmentCenter;
     _membershipCard.image = [UIImage imageNamed:@"huiyuanka_weijihuo"];
     
     }
     else {
     _label = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(_membershipCard.frame)+20, MAIN_SCREEN_WIDTH-160, 20)];
     btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(32, CGRectGetMaxY(_membershipCard.frame)+20, 60, 20)];
     [btnTitle setTitle:@"设为默认" forState:UIControlStateNormal];
     [btnTitle.titleLabel setFont:[UIFont systemFontOfSize:12]];
     [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
     btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(_membershipCard.frame)+24, 12, 12)];
     btnSelect.selected  = NO;
     [btnSelect setImage:[UIImage imageNamed:@"r01"] forState:UIControlStateNormal];
     [btnSelect addTarget:self action:@selector(actSelect) forControlEvents:UIControlEventTouchUpInside];
     
     _label.text = @"使用时向服务员出示二维码";
     _label.font = [UIFont systemFontOfSize:12];
     _label.textAlignment = NSTextAlignmentCenter;
     _membershipCard.image = [UIImage imageNamed:@"huiyuanka_jinka"];
     }
     */
    
    [_backgroundView addSubview:_label];
    [_backgroundView addSubview:btnSelect];
    //[_backgroundView addSubview:btnTitle];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 200)];
    _preferentialRules = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MAIN_SCREEN_WIDTH-20, 100)];
    _preferentialRules.text = @"此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则!!!!!!!";
    _preferentialRules.font = [UIFont systemFontOfSize:12];
    _preferentialRules.alpha = 0.5;
    _preferentialRules.numberOfLines = 0;
    CGSize size = [_preferentialRules.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(_preferentialRules.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    view.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, size.height+60);
    _preferentialRules.frame = CGRectMake(10, 5, MAIN_SCREEN_WIDTH-20, size.height);
    [view addSubview:_preferentialRules];
    _tableView.tableHeaderView = _backgroundView;
    _tableView.tableFooterView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //pageControl.currentPage = scrollView.contentOffset.x/(MAIN_SCREEN_WIDTH);
    //动画过程中 一直执行
    //NSLog(@"scrollViewDidScroll");
    self.currentCardIndex = scrollview.contentOffset.x/MAIN_SCREEN_WIDTH;
    NSLog(@"scrollView结束拖拽：%d",self.currentCardIndex);
    if (self.currentCardIndex == self.moRenIndex) {
        
        btnSelect.selected = YES;
    }
    else{
        btnSelect.selected = NO;
     
    }
    
    

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{




}



-(void)actSelect:(UIButton *)sender{
    

    if (self.currentCardIndex == self.moRenIndex) {
  
         if (btnSelect.selected) {
         //btnSelect.selected = NO;
         NSLog(@"相同时取消选中");
         //[btnSelect setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
         }else{
         btnSelect.selected = YES;
         
         NSLog(@"相同时选中");
         // [btnSelect setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
         }
   
    }
    else{
        if (btnSelect.selected) {
            //btnSelect.selected = NO;
            NSLog(@"不同时取消选中");
            //[btnSelect setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        }else{
            btnSelect.selected = YES;
            self.moRenIndex = self.currentCardIndex;
            NSLog(@"不同时选中");
            //设置默认卡
            [self setMoRenCard];
            // [btnSelect setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
        }
    }
    
}
#pragma mark 设置默认卡
- (void)setMoRenCard{
    VipCardModel * moCard = [self.cardARR objectAtIndex:self.moRenIndex];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    
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
            NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":phone,@"cardNo":moCard.cardNo}];
            NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                    @"phone":phone,
                                    @"cardNo":moCard.cardNo,
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
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"默认卡设置成功！";
                    [_hud hide:YES afterDelay:2];

                    
                    NSString * cardTypeStr = [NSString stringWithFormat:@"%@",moCard.cardTypeIdString];
                    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:cardTypeStr forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                    [userDefault synchronize];
                    

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

#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *string = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"会员卡";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-50, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"accessToken"];//个人二维码图标
        //imageView.backgroundColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:imageView];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"可用积分";
        
        [cell addSubview:_ValidCentSLabel];

    }/*

    }

    if (indexPath.row == 2) {
        cell.textLabel.text = @"当前余额";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-100, 10,70 , 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"￥50000";
        label.font = [UIFont systemFontOfSize:12];
        label.alpha = 0.5;
        [cell.contentView addSubview:label];
    }*/
    if (indexPath.row == 2) {
        cell.textLabel.text = @"使用记录";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_WIDTH-130, 10,100 , 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"查看消费记录";
        label.font = [UIFont systemFontOfSize:12];
        label.alpha = 0.5;
        [cell.contentView addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"优惠规则";
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        MNNQRCodeViewController *qrCodeVC = [MNNQRCodeViewController new];
        
        VipCardModel * cardModel = [self.cardARR objectAtIndex:self.moRenIndex];
        qrCodeVC.cardNo = cardModel.cardNo;
        [self.navigationController pushViewController:qrCodeVC animated:YES];
    }
    if (indexPath.row == 2) {
        self.hidesBottomBarWhenPushed = YES;
        MNNPurchaseHistoryViewController *purchasHistoryVC = [MNNPurchaseHistoryViewController new];
        [self.navigationController pushViewController:purchasHistoryVC animated:YES];
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

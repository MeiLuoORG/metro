//
//  MLShopInfoViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopInfoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HFSConstants.h"
#import "MLGoodsDetailsViewController.h"
#import "Masonry.h"
#import "UIViewController+MLMenu.h"
#import "UIView+DownMenu.h"
#import "MLshopGoodsListViewController.h"
#import "PinPaiSPListViewController.h"
#import "MLGoodsListViewController.h"
#import "MLshopFLViewController.h"
#import "MLHttpManager.h"
#import "HFSServiceClient.h"
#import "MLLoginViewController.h"
#import "MLShopDetailViewController.h"
#import "MLActiveWebViewController.h"
#import "MBProgressHUD+Add.h"
@protocol JSObjectDelegate <JSExport>


- (void)navigationProduct:(NSString *)productId;
- (void)skipPage:(NSString *)url;


- (void)skipStoreDetaild:(NSString*)url;

- (void)skip:(NSString *)index Ui:(NSString *)sender;
- (void)storeCollect:(NSString*)type;

@end

@interface MLShopInfoViewController ()<UIWebViewDelegate,JSObjectDelegate,UITextFieldDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    UITextField *searchText;
    NSDictionary *dpDic;
    NSString *userid;
    NSString *shopDetailurl;


}
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)JSContext *context;

@end

@implementation MLShopInfoViewController
@synthesize uid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)] ;
     frameView.layer.borderWidth = 1;
     frameView.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
     frameView.layer.cornerRadius = 4.f;
     frameView.layer.masksToBounds = YES;
     frameView.backgroundColor = [UIColor whiteColor];
     dpDic = [NSDictionary dictionary];
    
     CGFloat H = frameView.bounds.size.height - 8;
     CGFloat imgW = H;
     CGFloat textW = frameView.bounds.size.width - imgW - 6;
     
     UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
     searchText = [[UITextField alloc] initWithFrame:CGRectMake( 6, 4, textW, H)];
     searchText.returnKeyType = UIReturnKeySearch;
     searchText.enablesReturnKeyAutomatically = YES;
     searchText.delegate = self;
     searchText.enabled = YES;
    
     [frameView addSubview:searchImg];
     [frameView addSubview:searchText];
     searchImg.frame = CGRectMake(textW - 58 - 70 , 4, imgW, imgW);
     
     searchText.textColor = [UIColor grayColor];
     searchText.placeholder = @"搜索店内的商品";
     searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
     self.navigationItem.titleView = frameView;
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 22)];
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
    [moreBtn setImage:[UIImage imageNamed:@"gengduozl"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(actmore) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *morebtnItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
  
    UIButton *sxuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 22)];
    [sxuanBtn setBackgroundImage:[UIImage imageNamed:@"fenlei1"] forState:UIControlStateNormal];
    [sxuanBtn addTarget:self action:@selector(actsxuan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sxuanbtnItem = [[UIBarButtonItem alloc]initWithCustomView:sxuanBtn];
    
    self.navigationItem.rightBarButtonItems = @[morebtnItem,sxuanbtnItem];

    
    
    [self loadWebView];
    
    [self loaddataDianpu];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self isshoucang];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
}

-(void)loadWebView{

    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    NSString *url = [NSString stringWithFormat:@"%@/store/index?sid=%@&uid=%@",HomeHTML_URLString,uid,userid];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [searchText becomeFirstResponder];
}

//点击键盘上搜索按钮时
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"%@",textField.text);
    [searchText resignFirstResponder];
    
    MLshopGoodsListViewController *vc = [[MLshopGoodsListViewController alloc]init];
    vc.filterParam = @{@"keyword":textField.text};
    vc.searchString = textField.text;
    vc.uid = uid;
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}

//快捷入口
-(void)actmore{

    self.hidesBottomBarWhenPushed = NO;

    [self dianpushowDownMenu];
    
}

//店铺商品分类
-(void)actsxuan{
    
    MLshopFLViewController *vc = [[MLshopFLViewController alloc]init];
    vc.uid = uid;
    [self.navigationController  pushViewController:vc animated:YES];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"_native"] = self;
    __weak typeof(self) weakself = self;
//    self.context[@"skipUi"] = ^(NSString *productid){
//        NSLog(@"%@",productid);
////            [weakself performSelectorOnMainThread:@selector(collectClick:) withObject:productid waitUntilDone:YES];
//    };
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:weakself.view];
    };
    
}

#pragma mark js回调

-(void)storeCollect:(NSString *)type{
    
    NSLog(@"shopparamDic===%@type===%@",_shopparamDic,type);
    
    if (userid) {
        
        if ([type isEqualToString:@"1"]) {
            
            [self shoucangDianpu:type];
            
            NSLog(@"1111");
            
        }else{
            
            [self quxiaoshoucangDianpu:type];
            
            NSLog(@"0000");
        }
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MLLoginViewController *vc = [[MLLoginViewController alloc] init];
    vc.isLogin = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)skip:(NSString *)index Ui:(NSString *)sender{
    
    NSLog(@"点击了网页：%@++++++%@",index,sender);
    //商品
    if ([index isEqualToString:@"1"]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc ]init];
        vc.paramDic = @{@"id":sender};
        [self.navigationController pushViewController:vc animated:YES];
   // [self performSelectorOnMainThread:@selector(pushTest:) withObject:sender waitUntilDone:YES];
        });
    }
    //品牌
    else if([index isEqualToString:@"2"]){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            PinPaiSPListViewController * vc = [[PinPaiSPListViewController alloc]init];
            vc.title = @"品牌馆";
            vc.searchString = sender;
            [self.navigationController pushViewController:vc animated:YES];
  
        });
    
    }
    //分类
    else if([index isEqualToString:@"3"]){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            MLGoodsListViewController * vc = [[MLGoodsListViewController alloc]init];
            [vc.filterParam  setValue:sender forKey:@"flid"];
            [self.navigationController pushViewController:vc animated:YES];
            
        });
        
    }
    //链接
    else if([index isEqualToString:@"4"]){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
     
            MLActiveWebViewController *vc = [[MLActiveWebViewController alloc]init];
            vc.title = @"热门活动";
            vc.link = sender;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        });
        
    }
    //店铺
    else if([index isEqualToString:@"5"]){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            self.store_link = [NSString stringWithFormat:@"%@/store?sid=%@&uid=%@",HomeHTML_URLString,sender,phone];
            [self loadWebView];
            
        });
        
    }
    //频道
    else if([index isEqualToString:@"9"]){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            PinPaiSPListViewController * vc = [[PinPaiSPListViewController alloc]init];
            vc.title = @"品牌馆";
            vc.searchString = sender;
            [self.navigationController pushViewController:vc animated:YES];
            
        });
        
    }
    
}

- (void)pushTest:(NSString *)sender{
    
   
}


//跳到店铺详情
-(void)skipStoreDetaild:(NSString *)storeid{

    NSLog(@"storeid===%@",storeid);
    shopDetailurl  = storeid;
    [self performSelector:@selector(gotoMLshopDetail) withObject:self afterDelay:0.5f];
//    [self performSelectorOnMainThread:@selector(shopdetail) withObject:nil waitUntilDone:YES];
    
 
}
-(void)gotoMLshopDetail{
    
//    [self performSelectorOnMainThread:@selector(shopdetail) withObject:nil waitUntilDone:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MLShopDetailViewController *vc = [[MLShopDetailViewController alloc]init];
        vc.urlstr = shopDetailurl;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    });
    
}

//-(void)shopdetail{
//
//    MLShopDetailViewController *vc = [[MLShopDetailViewController alloc]init];
//    vc.urlstr = shopDetailurl;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

//收藏店铺
-(void)shoucangDianpu:(NSString*)typeStr{
    
    NSLog(@"shopparamDic111===%@typeStr111===%@dpDic111===%@",_shopparamDic,typeStr,dpDic);
    
    
    if ([_shopparamDic[@"company"] isEqualToString:@""]) {
        
        _shopparamDic = @{@"userid":dpDic[@"userid"],@"company":dpDic[@"company"]};
 
    }
    NSLog(@"=====999%@",_shopparamDic);
    
        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
        NSDictionary *params = @{@"do":@"add",@"shopid":_shopparamDic[@"userid"],@"uname":@"ml_13771961207",@"shopname":_shopparamDic[@"company"]};
        
        [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
            NSLog(@"请求成功responseObject===%@",responseObject);
            
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            if ([responseObject[@"code"]isEqual:@0]) {
                if ([responseObject[@"data"][@"shop_add"]isEqual:@1]) {
                    
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"收藏成功";
                    [_hud hide:YES afterDelay:2];
                    
                    NSString *alertJS=@"resStoreCollect(1)"; //准备执行的js代码
                    [self.context evaluateScript:alertJS];//通过oc方法调用js的方法
                    
                    
                }else{
                    
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"收藏失败";
                    [_hud hide:YES afterDelay:1];
                    
                }
            }else if ([responseObject[@"code"]isEqual:@1002]){
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                [_hud hide:YES afterDelay:1];
                [self showError];
                
            }
    
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败 error===%@",error);
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:1];
            
            
        }];

}

//取消收藏店铺
-(void)quxiaoshoucangDianpu:(NSString*)typeStr{
  
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
    NSDictionary *params = @{@"do":@"sel"};
    
    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        
        if ([responseObject[@"data"][@"shop_list"] isKindOfClass:[NSString class]]) {
            
            
        }else{
            
            NSString *shopid = _shopparamDic[@"userid"];
            for (NSDictionary *tempdic in responseObject[@"data"][@"shop_list"]) {
                if ([shopid isEqualToString:tempdic[@"shopid"]]) {
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
                    NSDictionary *params = @{@"do":@"del",@"id":tempdic[@"id"]};
                    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
                        NSLog(@"请求成功responseObject===%@",responseObject);
                        
                        _hud = [[MBProgressHUD alloc]initWithView:self.view];
                        [self.view addSubview:_hud];
                        if ([responseObject[@"code"]isEqual:@0]) {
                            if ([responseObject[@"data"][@"shop_del"]isEqual:@1]) {
                                
                                [_hud show:YES];
                                _hud.mode = MBProgressHUDModeText;
                                _hud.labelText = @"取消收藏成功";
                                [_hud hide:YES afterDelay:2];
                                
                                NSString *alertJS=@"resStoreCollect(0)"; //准备执行的js代码
                                [self.context evaluateScript:alertJS];//通过oc方法调用js的alert
                                
                            }else{
                                
                                [_hud show:YES];
                                _hud.mode = MBProgressHUDModeText;
                                _hud.labelText = @"您的网络不给力啊";
                                [_hud hide:YES afterDelay:1];
                            }
                        }else if ([responseObject[@"code"]isEqual:@1002]){
                        
                            [_hud show:YES];
                            _hud.mode = MBProgressHUDModeText;
                            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                            [_hud hide:YES afterDelay:1];
                            [self showError];
                        }
           
                        
                    } failure:^(NSError *error) {
                        NSLog(@"请求失败 error===%@",error);
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = @"请求失败";
                        [_hud hide:YES afterDelay:1];
                        
                    }];
                }
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    
}


//店铺信息
-(void)loaddataDianpu{
    NSString *dpid = _shopparamDic[@"userid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=shop&uid=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,dpid,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"shop" s:@"shop" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        
        if ([responseObject[@"code"] isEqual:@0] && ![responseObject[@"data"][@"shop_info"] isKindOfClass:[NSNull class]]) {
            dpDic = responseObject[@"data"][@"shop_info"];
            NSLog(@"%@",dpDic);
            
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            [self showError];
        }
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
   
    /*
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        
        if ([responseObject[@"code"] isEqual:@0] && ![responseObject[@"data"][@"shop_info"] isKindOfClass:[NSNull class]]) {
            dpDic = responseObject[@"data"][@"shop_info"];
            NSLog(@"%@",dpDic);
            
        }
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
    */
}

//店铺是否收藏
-(void)isshoucang{

    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
    NSDictionary *params = @{@"do":@"sel"};
    
    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        if ([responseObject[@"code"]isEqual:@0]) {
            if ([responseObject[@"data"][@"shop_list"] isKindOfClass:[NSString class]]) {
                
                NSString *alertJS=@"resStoreCollect(0)"; //准备执行的js代码
                [self.context evaluateScript:alertJS];//通过oc方法调用js的方法
                
            }else{
                
                NSString *shopid = _shopparamDic[@"userid"];
                NSMutableArray *dpIDArr = [NSMutableArray array];
                
                for (NSDictionary *tempdic in responseObject[@"data"][@"shop_list"]) {
                    
                    [dpIDArr addObject:tempdic[@"shopid"]];
                    /*
                     if ([shopid isEqualToString:tempdic[@"shopid"]]) {
                     
                     NSString *alertJS=@"resStoreCollect(1)"; //准备执行的js代码
                     [self.context evaluateScript:alertJS];//通过oc方法调用js的
                     
                     }else{
                     
                     NSString *alertJS=@"resStoreCollect(0)"; //准备执行的js代码
                     [self.context evaluateScript:alertJS];//通过oc方法调用js的
                     }
                     */
                    
                }
                
                if ([dpIDArr containsObject:shopid]) {
                    NSString *alertJS=@"resStoreCollect(1)"; //准备执行的js代码
                    [self.context evaluateScript:alertJS];//通过oc方法调用js的
                }else{
                    
                    NSString *alertJS=@"resStoreCollect(0)"; //准备执行的js代码
                    [self.context evaluateScript:alertJS];//通过oc方法调用js的
                }
                
            }
        }else if ([responseObject[@"code"]isEqual:@1002]){
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            [self showError];
        
        }
 
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败 error===%@",error);
  
    }];

}

//去登录
-(void)showError
{
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)navigationProduct:(NSString *)productId{
    
    [self performSelectorOnMainThread:@selector(pushToGoodsDetail:) withObject:productId waitUntilDone:YES];
}


- (void)collectClick:(NSString *)collectId{
    NSLog(@"%@",collectId);
}

- (void)storeProductClick:(NSString *)productId{
    NSLog(@"%@",productId);
}


//- (void)skipPage:(NSString *)url{
//    NSLog(@"%@",url);
//    MLShopDetailViewController *vc = [[MLShopDetailViewController alloc]init];
//    vc.urlstr = url;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)pushToGoodsDetail:(NSString *)productId{
    MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *params = @{@"id":productId?:@""};
    vc.paramDic = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

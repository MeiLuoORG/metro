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
@protocol JSObjectDelegate <JSExport>


- (void)navigationProduct:(NSString *)productId;
- (void)skipPage:(NSString *)url;


- (void)skip:(NSString *)index Ui:(NSString *)sender;
- (void)storeCollect:(NSString*)type;

@end

@interface MLShopInfoViewController ()<UIWebViewDelegate,JSObjectDelegate,UITextFieldDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    UITextField *searchText;

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
     searchImg.frame = CGRectMake(textW - 58 - 60 , 4, imgW, imgW);
     
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
    NSString *url = [NSString stringWithFormat:@"http://61.155.212.146:3000/store/index?sid=20505&uid=%@",uid];
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
    vc.uid = uid;
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}


-(void)actmore{
    self.hidesBottomBarWhenPushed = NO;
    [self dianpushowDownMenu];
    
}

-(void)actsxuan{
    
    NSLog(@"111111");
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
    self.context[@"skipUi"] = ^(NSString *productid){
        NSLog(@"%@",productid);
//            [weakself performSelectorOnMainThread:@selector(collectClick:) withObject:productid waitUntilDone:YES];
    };
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
}

#pragma mark js回调
-(void)storeCollect:(NSString *)type{
    
//http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_shop
//    
//   【post】
//    
//    do=add
//        
//    shopid=13911
//        
//    uname=ml_13771961207
//        
//    shopname=嘻呗全球购
    
    NSLog(@"shopparamDic===%@",_shopparamDic);
    
    NSLog(@"type==%@",type);
    if ([type isEqualToString:@"1"]) {
        NSString *urlStr = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_shop"];
        NSDictionary *params = @{@"do":@"add",@"shopid":_shopparamDic[@"userid"],@"uname":@"ml_13771961207",@"shopname":_shopparamDic[@"company"]};
        
        [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
            NSLog(@"请求成功responseObject===%@",responseObject);
            if ([responseObject[@"code"]isEqual:@0]) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"收藏成功";
                [_hud hide:YES afterDelay:1];
            }else{
            
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"您的网络不给力啊";
                [_hud hide:YES afterDelay:1];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"请求失败 error===%@",error);
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:1];
            
        }];
    }else{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"取消收藏成功";
            [_hud hide:YES afterDelay:1];
            
            
        });
 
        /*
        NSString *urlStr = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_shop"];
        NSDictionary *params = @{@"do":@"del",@"id":@""};
        [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
            NSLog(@"请求成功responseObject===%@",responseObject);
            if ([responseObject[@"code"]isEqual:@0]) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"取消收藏成功";
                [_hud hide:YES afterDelay:1];
            }else{
                
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"您的网络不给力啊";
                [_hud hide:YES afterDelay:1];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"请求失败 error===%@",error);
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:1];
            
        }];
        */
    }
    
}


- (void)skip:(NSString *)index Ui:(NSString *)sender{
    
    NSLog(@"点击了网页：%@++++++%@",index,sender);
    //商品
    if ([index isEqualToString:@"1"]) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc ]init];
            [vc.paramDic setValue:sender forKey:@"id"];
            [self.navigationController pushViewController:vc animated:YES];

            
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
    //店铺
    else if([index isEqualToString:@"5"]){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            self.store_link = [NSString stringWithFormat:@"%@/store?sid=%@&uid=%@",@"http://192.168.19.247:3000",sender,phone];
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


- (void)navigationProduct:(NSString *)productId{
    
    [self performSelectorOnMainThread:@selector(pushToGoodsDetail:) withObject:productId waitUntilDone:YES];
}


- (void)collectClick:(NSString *)collectId{
    NSLog(@"%@",collectId);
}

- (void)storeProductClick:(NSString *)productId{
    NSLog(@"%@",productId);
}


- (void)skipPage:(NSString *)url{
    NSLog(@"%@",url);
}


- (void)pushToGoodsDetail:(NSString *)productId{
    MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *params = @{@"id":productId?:@""};
    vc.paramDic = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

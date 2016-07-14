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

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define NUMBER_OF_ITEMS (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS 25
#define ITEM_SPACING 210.0f
#define INCLUDE_PLACEHOLDERS YES

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
    UIView * _guiZeView;//会员卡消费规则接口
    
    UIImageView * _defaultImageView;
    UILabel * _yuELabel;
    
}
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) IBOutlet UIBarItem *orientationBarItem;
@property (nonatomic, retain) IBOutlet UIBarItem *wrapBarItem;
@end

@implementation MNNMemberViewController

@synthesize wrap;
@synthesize items;
@synthesize carousel;
@synthesize orientationBarItem;
@synthesize wrapBarItem;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    self.title = @"会员卡";
    self.moRenIndex = 0;
    self.currentCardIndex = 0;
    self.cardARR = [[NSMutableArray alloc]init];
    
    _ValidCentSLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_WIDTH-100, 10,70 , 20)];
    _ValidCentSLabel.textAlignment = NSTextAlignmentRight;
    _ValidCentSLabel.text = @"0";
    _ValidCentSLabel.font = [UIFont systemFontOfSize:12];
    _ValidCentSLabel.alpha = 0.5;

    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"绑定会员卡" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self createTableView];
    // Do any additional setup after loading the view.
    [self loadData];
    
    //初始化弹出信息
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    
    //加载3D图片
    //[self setUp];
}


#pragma 3D 图片开始

- (void)setUp
{
    if (self.cardARR.count > 0) {
        _defaultImageView.hidden = YES;
        
        //set up data
        //set up data
        self.wrap = NO;
        self.items = [NSMutableArray array];
        for (int i = 0; i < self.cardARR.count; i++)
        {
            [self.items addObject:@(i)];
        }
        
        //configure carousel
        //configure carousel
        self.carousel = [[iCarousel alloc]initWithFrame:CGRectMake(14, 20,SIZE_WIDTH-28, (227.0/347.0)*SIZE_WIDTH)];
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        self.carousel.type = iCarouselTypeRotary;
        
        [_backgroundView addSubview:self.carousel];
        

        VipCardModel * firstCardModel = [self.cardARR objectAtIndex:0];
        
        _preferentialRules.text = firstCardModel.cardRule;
        NSLog(@"消费规则内容：%@",_preferentialRules.text);
        CGRect rect = [_preferentialRules.text boundingRectWithSize:CGSizeMake(_preferentialRules.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil];
        //NSLog(@"会员卡消费规则：%g,---%g",size.height,rect.size.height);
        _guiZeView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, rect.size.height+60);
        _preferentialRules.frame = CGRectMake(20, 5, MAIN_SCREEN_WIDTH-40, rect.size.height);
        
        NSLog(@"消费规则视图的高度为：%g",rect.size.height+60);
        
        _tableView.tableFooterView = _guiZeView;
    }


}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;

    self.orientationBarItem = nil;
    self.wrapBarItem = nil;
}

#pragma mark iCarousel methods

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        if (self.cardARR.count > 0) {
            VipCardModel * CardModel = [self.cardARR objectAtIndex:index];
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_WIDTH-28, (227.0/347.0)*SIZE_WIDTH)];
            //((UIImageView *)view).image = [UIImage imageNamed:VIPCARDIMG_DEFAULTNAME];
            [((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:CardModel.cardImg] placeholderImage:[UIImage imageNamed:VIPCARDIMG_DEFAULTNAME]];
            //加阴影 zhou
            view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
            view.layer.shadowOffset = CGSizeMake(8,8);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
            view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
            view.layer.shadowRadius = 7;//阴影半径，默认3
            
            UILabel * label = [UILabel new];
            
            label.text = CardModel.cardNo;
            label.font = [UIFont systemFontOfSize:15.0f];
            
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(30);
                make.bottom.mas_equalTo(view).offset(-30);
            }];
            
            //view.contentMode = UIViewContentModeCenter;
            /*
             label = [[UILabel alloc] initWithFrame:view.bounds];
             label.backgroundColor = [UIColor clearColor];
             label.textAlignment = NSTextAlignmentCenter;
             label.font = [label.font fontWithSize:50];
             label.tag = 1;
             [view addSubview:label];
             */
        }

    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [self.items[(NSUInteger)index] stringValue];
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        if (self.cardARR.count > 0) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            VipCardModel * CardModel = [self.cardARR objectAtIndex:index];
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_WIDTH-28, (227.0/347.0)*SIZE_WIDTH)];
            //((UIImageView *)view).image = [UIImage imageNamed:VIPCARDIMG_DEFAULTNAME];
            [((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:CardModel.cardImg] placeholderImage:[UIImage imageNamed:VIPCARDIMG_DEFAULTNAME]];
            //加阴影 zhou
            view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
            view.layer.shadowOffset = CGSizeMake(8,8);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
            view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
            view.layer.shadowRadius = 7;//阴影半径，默认3
            //view.contentMode = UIViewContentModeCenter;
            /*
             label = [[UILabel alloc] initWithFrame:view.bounds];
             label.backgroundColor = [UIColor clearColor];
             label.textAlignment = NSTextAlignmentCenter;
             label.font = [label.font fontWithSize:50.0f];
             label.tag = 1;
             [view addSubview:label];
             */

        }
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.items)[(NSUInteger)index];
    NSLog(@"点击了Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"滑动到第几Index: %@", @(self.carousel.currentItemIndex));
    if (self.cardARR.count > 0) {
        self.currentCardIndex = (int)self.carousel.currentItemIndex;
        //NSLog(@"scrollView正在+++拖拽：%d",self.currentCardIndex);
        if (self.currentCardIndex == self.moRenIndex) {
            
            btnSelect.selected = YES;
        }
        else{
            btnSelect.selected = NO;
            
        }
        VipCardModel * firstCardModel = [self.cardARR objectAtIndex:self.currentCardIndex];
        
        _preferentialRules.text = firstCardModel.cardRule;
        //NSLog(@"消费规则内容：%@",_preferentialRules.text);
        CGRect rect = [_preferentialRules.text boundingRectWithSize:CGSizeMake(_preferentialRules.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil];
        //NSLog(@"会员卡消费规则：%g,---%g",size.height,rect.size.height);
        _guiZeView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, rect.size.height+60);
        _preferentialRules.frame = CGRectMake(20, 5, MAIN_SCREEN_WIDTH-40, rect.size.height);
        _tableView.tableFooterView = _guiZeView;
        NSLog(@"消费规则视图的高度为：%g",rect.size.height+60);
        [self getCardInfowithcardNo:firstCardModel.cardNo];
    }
    
    
}

#pragma end 3D图片结束
//////////////////////////////--------------------------

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
    
    [self yuanShengHuiYuanKaWithRet2:ret2];
    /*
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:VIPInfo_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
*/

}

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
    [self yuanShengXiangXiKaWithRet2:ret2];
    /*
    [[HFSServiceClient sharedClient] POST:VIPCardJiFen_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    */
    

}
#pragma mark 获取详细信息
- (void) yuanShengXiangXiKaWithRet2:(NSString *)ret2{
    VipCardModel * moCard = [self.cardARR objectAtIndex:self.moRenIndex];
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSString *urlStr = [NSString stringWithFormat:@"%@",VIPCardJiFen_URLString];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data3];
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
   
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              //JSON解析
                                              // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                              //NSLog(@"默认卡详细信息：%@",result);
                                              if ([result[@"succ"] isEqual:@1]) {
                                                 
                                                  NSDictionary * userDataDic = result[@"data"];
                                                  NSLog(@"获取单个会员卡详细信息%@",result);
                                                  if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                      //vipCard
                                                      //ValidCent
                                                      //_ValidCentString = userDataDic[@"ValidCent"];
                                                      
                                                      
                                                      self.currentCardModel = [VipCardModel new];
                                                      self.currentCardModel.cardID = userDataDic[@"CardId"];
                                                      self.currentCardModel.qrCode = userDataDic[@"QRCODE"];
                                                      self.currentCardModel.validCent = userDataDic[@"ValidCent"];
                                                      self.currentCardModel.yuE = userDataDic[@"SaleMoney"];
                                                      dispatch_sync(dispatch_get_main_queue(), ^{
                                                          _ValidCentSLabel.text = userDataDic[@"ValidCent"];
                                                          _yuELabel.text = userDataDic[@"SaleMoney"];
                                                      });
                                                      
                                                      //[_tableView reloadData];
                                                      //[self.view layoutIfNeeded];
                                                      //[self.view setNeedsLayout];
                                                      //[self.view setNeedsDisplay];
                                                  }else{
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [_hud show:YES];
                                                          _hud.mode = MBProgressHUDModeText;
                                                          _hud.labelText = result[@"errMsg"];
                                                          [_hud hide:YES afterDelay:2];
                                                      });
                                                     

                                                  }
                                                  
                                              }
                                              
                                          }
                                      }
                                      else{
                                          //请求有错误
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [_hud show:YES];
                                              _hud.mode = MBProgressHUDModeText;
                                              _hud.labelText = REQUEST_ERROR_ZL;
                                              _hud.labelFont = [UIFont systemFontOfSize:13];
                                              [_hud hide:YES afterDelay:1];
                                          });
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    //});
}



#pragma end mark 获取详细信息


//更新会员卡图片
- (void)updataCardScrollView{
    if (self.cardARR.count > 0) {
        _defaultImageView.hidden = YES;
        scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH)*self.cardARR.count, 267);
        UIImageView * bkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, scrollview.contentSize.width, 207)];
        bkView.backgroundColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        [scrollview addSubview:bkView];
        
        for (int i=0; i<self.cardARR.count; i++) {
            VipCardModel * cardModel = [self.cardARR objectAtIndex:i];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(14+(MAIN_SCREEN_WIDTH)*(i), 20, MAIN_SCREEN_WIDTH-28, (227.0/347.0)*SIZE_WIDTH)];
            
            /*
            NSString *str=[NSString stringWithFormat:@"%d.JPG",i];
            
            imageView.image=[UIImage imageNamed:str];
            */
            [imageView sd_setImageWithURL:[NSURL URLWithString:cardModel.cardImg] placeholderImage:[UIImage imageNamed:VIPCARDIMG_DEFAULTNAME]];
            
            //加阴影 zhou
            imageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
            imageView.layer.shadowOffset = CGSizeMake(8,8);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
            imageView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
            imageView.layer.shadowRadius = 7;//阴影半径，默认3
            
            [scrollview addSubview:imageView];
        }
        
        VipCardModel * firstCardModel = [self.cardARR objectAtIndex:0];
        
        _preferentialRules.text = firstCardModel.cardRule;
        NSLog(@"消费规则内容：%@",_preferentialRules.text);
        CGRect rect = [_preferentialRules.text boundingRectWithSize:CGSizeMake(_preferentialRules.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil];
        //NSLog(@"会员卡消费规则：%g,---%g",size.height,rect.size.height);
        _guiZeView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, rect.size.height+60);
        _preferentialRules.frame = CGRectMake(20, 5, MAIN_SCREEN_WIDTH-40, rect.size.height);
        
        _tableView.tableFooterView = _guiZeView;
    }

}


- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    _tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, (307.0/375.0)*SIZE_WIDTH)];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    //    _membershipCard = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, MAIN_SCREEN_WIDTH-40, 150)];
    //    [_backgroundView addSubview:_membershipCard];
    
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, (267.0/375.0)*SIZE_WIDTH)];
    scrollview.backgroundColor=[UIColor whiteColor];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.bounces = NO;
    scrollview.pagingEnabled=YES;
    scrollview.delegate=self;
    scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH)*1, (267.0/375.0)*SIZE_WIDTH);
    
    
    /*
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(80, 140, MAIN_SCREEN_WIDTH-160, 30)];
    
    pageControl.numberOfPages=4;
    
    pageControl.currentPage=0;
    
    pageControl.pageIndicatorTintColor=[UIColor greenColor];
    
    pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    */
    
    //背景色块
    UIImageView * bkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, scrollview.contentSize.width, 207)];
    bkView.backgroundColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    //[scrollview addSubview:bkView];

    for (int i=0; i<1; i++) {
        _defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14+(MAIN_SCREEN_WIDTH)*(i), 20, MAIN_SCREEN_WIDTH-28, (227.0/347.0)*SIZE_WIDTH)];
        
        //NSString *str=[NSString stringWithFormat:@"%d.JPG",i];
        
        _defaultImageView.image=[UIImage imageNamed:VIPCARDIMG_DEFAULTNAME];
        //加阴影 zhou
        _defaultImageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _defaultImageView.layer.shadowOffset = CGSizeMake(8,8);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _defaultImageView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _defaultImageView.layer.shadowRadius = 7;//阴影半径，默认3
        /*
        //加阴影 zhou
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        imageView.layer.shadowOffset = CGSizeMake(10,10);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        imageView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        imageView.layer.shadowRadius = 10;//阴影半径，默认3
        */
        [scrollview addSubview:_defaultImageView];
    }
    
    [_backgroundView addSubview:scrollview];
    //[_backgroundView addSubview:pageControl];


    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(scrollview.frame)+10, 70, 20)];
    [btnSelect setTitle:@"设为默认" forState:UIControlStateNormal];
    [btnSelect setTitleColor:[HFSUtility hexStringToColor:Main_grayBackgroundColor] forState:UIControlStateNormal];
    [btnSelect.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    btnSelect.selected  = YES;
    [btnSelect setImage:[UIImage imageNamed:@"zSelectBtn"] forState:UIControlStateNormal];
    [btnSelect setImage:[UIImage imageNamed:@"zSelected"] forState:UIControlStateSelected];
    [btnSelect setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    
    [btnSelect addTarget:self action:@selector(actSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(scrollview.frame)+10, MAIN_SCREEN_WIDTH-160, 20)];
    _label.text = @"使用时向服务员出示二维码";
    _label.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _label.font = [UIFont systemFontOfSize:10.0f];
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
    
    _guiZeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 200)];
    _guiZeView.backgroundColor = [UIColor whiteColor];
    _preferentialRules = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, MAIN_SCREEN_WIDTH-40, 100)];
    _preferentialRules.text = @"优惠规则";
    _preferentialRules.font = [UIFont systemFontOfSize:10];
    _preferentialRules.alpha = 0.5;
    _preferentialRules.numberOfLines = 0;
    //CGSize size = [_preferentialRules.text sizeWithFont:[UIFont systemFontOfSize:10.0f] constrainedToSize:CGSizeMake(_preferentialRules.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    CGRect rect = [_preferentialRules.text boundingRectWithSize:CGSizeMake(_preferentialRules.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil];
    //NSLog(@"会员卡消费规则：%g,---%g",size.height,rect.size.height);
    _guiZeView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, rect.size.height+60);
    _preferentialRules.frame = CGRectMake(20, 5, MAIN_SCREEN_WIDTH-40, rect.size.height);
    [_guiZeView addSubview:_preferentialRules];
    _tableView.tableHeaderView = _backgroundView;
    _tableView.tableFooterView = _guiZeView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    //加载3D
    //[self setUp];
    
}
-(CGFloat)textHeight:(NSString *)string{
    //传字符串返回高度
    CGRect rect =[string boundingRectWithSize:CGSizeMake(394, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];//计算字符串所占的矩形区域的大小
    return rect.size.height;//返回高度
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
    if (self.cardARR.count > 0) {
     
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
            
            [self yuanShengMoRenKaWithRet2:ret2];
            
            /*
            //@"vip/AuthUserInfo"
            [[HFSServiceClient sharedClient] POST:BindCard_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *result = (NSDictionary *)responseObject;
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
             */
        }
    
        
    }

}
#pragma mark 设置默认卡

- (void) yuanShengMoRenKaWithRet2:(NSString *)ret2{
     VipCardModel * moCard = [self.cardARR objectAtIndex:self.moRenIndex];
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSString *urlStr = [NSString stringWithFormat:@"%@",BindCard_URLString];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data3];
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSLog(@"原生错误error:%@",error);
                                      
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              //JSON解析
                                              // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                              NSLog(@"设置默认卡%@",result);
                                              if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = @"默认卡设置成功！";
                                                  [_hud hide:YES afterDelay:1.0f];
                                                  });
                                                  NSString * cardTypeStr = [NSString stringWithFormat:@"%@",moCard.cardTypeName];
                                                  NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                                                  [userDefault setObject:cardTypeStr forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                  [userDefault setObject:moCard.cardNo forKey:kUSERDEFAULT_USERCARDNO];
                                                  NSLog(@"设置的默认卡号为：%@",moCard.cardNo);
                                                  [userDefault synchronize];
                                                  
                                              }else{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = result[@"errMsg"];
                                                  [_hud hide:YES afterDelay:2];
                                                  });
                                              }
                                              
                                          }
                                      }
                                      else{
                                          //请求有错误
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [_hud show:YES];
                                              _hud.mode = MBProgressHUDModeText;
                                              _hud.labelText = REQUEST_ERROR_ZL;
                                              _hud.labelFont = [UIFont systemFontOfSize:13];
                                              [_hud hide:YES afterDelay:1];
                                          });
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    //});
}


#pragma end 设置默认卡 结束

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
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIZE_WIDTH - 50, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"erweima"];//个人二维码图标
        //imageView.backgroundColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:imageView];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"可用积分";
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        [cell addSubview:_ValidCentSLabel];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"当前余额";
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        _yuELabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_WIDTH-130, 10,100 , 20)];
        _yuELabel.textAlignment = NSTextAlignmentRight;
        _yuELabel.text = @"0";
        _yuELabel.font = [UIFont systemFontOfSize:12];
        _yuELabel.alpha = 0.5;
        [cell addSubview:_yuELabel];
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"使用记录";
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_WIDTH-130, 10,100 , 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"查看消费记录";
        label.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.alpha = 0.5;
        [cell.contentView addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"优惠规则";
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        MNNQRCodeViewController *qrCodeVC = [MNNQRCodeViewController new];
        VipCardModel * cardModel = [self.cardARR objectAtIndex:self.currentCardIndex];
        qrCodeVC.cardNo = cardModel.cardNo;
        /*
        if (self.currentCardModel.qrCode) {
            
            qrCodeVC.cardNo = self.currentCardModel.qrCode;
            
        }
        */
        [self.navigationController pushViewController:qrCodeVC animated:YES];
        
    }
    if (indexPath.row == 3) {
        self.hidesBottomBarWhenPushed = YES;
        MNNPurchaseHistoryViewController *purchasHistoryVC = [MNNPurchaseHistoryViewController new];
        
        if (self.currentCardModel.cardID) {
            
            purchasHistoryVC.cardID = self.currentCardModel.cardID;
            [self.navigationController pushViewController:purchasHistoryVC animated:YES];
        }
        
        
    }
}

#pragma mark 原生会员卡信息
- (void) yuanShengHuiYuanKaWithRet2:(NSString *)ret2{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSString *urlStr = [NSString stringWithFormat:@"%@",VIPInfo_URLString];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data3];
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              //JSON解析
                                              // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              //NSLog(@"error原生数据登录：++： %@",yuanDic);
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
                                                              cardModel.cardImg = dics[@"cardImg"];
                                                              cardModel.cardRule = dics[@"cardRule"];
                                                              cardModel.cardTypeName = dics[@"cardTypeName"];
                                                              [self.cardARR addObject:cardModel];
                                                              //请求默认卡的信息
                                                              [self getCardInfowithcardNo:cardModel.cardNo];
                                                          }
                                                          
                                                      }
                                                      for (NSDictionary * dics  in vipCardARR) {
                                                          
                                                          if ([[NSString stringWithFormat:@"%@",dics[@"isDefault"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@",dics[@"isDefault"]] isEqualToString:@""] || ![NSString stringWithFormat:@"%@",dics[@"isDefault"]]) {
                                                              VipCardModel * cardModel = [[VipCardModel alloc]init];
                                                              cardModel.cardNo = dics[@"cardNo"];
                                                              cardModel.cardTypeIdString = dics[@"cardTypeId"];
                                                              cardModel.isDefault = [dics[@"isDefault"] intValue];
                                                              cardModel.cardImg = dics[@"cardImg"];
                                                              cardModel.cardRule = dics[@"cardRule"];
                                                              cardModel.cardTypeName = dics[@"cardTypeName"];
                                                              [self.cardARR addObject:cardModel];
                                                          }
                                                          
                                                      }
                                                      //[self updataCardScrollView];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [self setUp];
                                                       });
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
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [MBProgressHUD showMessag:@"没有会员卡信息" toView:self.view];
                                                       /*
                                                       UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"账户已过期" message:nil delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                                                        [alert show];
                                                       */
                                                   });
                                              }

                                              
                                          }
                                      }
                                      else{
                                          //请求有错误
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [_hud show:YES];
                                              _hud.mode = MBProgressHUDModeText;
                                              _hud.labelText = REQUEST_ERROR_ZL;
                                              _hud.labelFont = [UIFont systemFontOfSize:13];
                                              [_hud hide:YES afterDelay:1];
                                          });
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    //});
}
#pragma end mark 原生注册方法  结束


#pragma end mark



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

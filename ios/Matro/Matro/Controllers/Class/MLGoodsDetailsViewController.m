
//
//  MLGoodsDetailsViewController.m
//  Matro
//
//  Created by NN on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsDetailsViewController.h"
#import "RecommendCollectionViewCell.h"
#import "CPPhotoInfoViewController.h"
#import "MLGoodsDetailsTableViewCell.h"
#import "YAScrollSegmentControl.h"
#import "AppDelegate.h"
#import "HFSConstants.h"
#import "CPStepper.h"
#import "UIColor+HeinQi.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "HFSUtility.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "MLLoginViewController.h"
#import "MLSureViewController.h"
#import "MLShopBagViewController.h"

#import "YMNavigationController.h"
#import "MLHelpCenterDetailController.h"
#import "NSString+GONMarkup.h"
#import "Masonry.h"
#import "MLKuajingCell.h"
#import "MLShareGoodsViewController.h"
#import "MLGoodsSharePhotoViewController.h"
#import "MBProgressHUD+Add.h"
#import <DWTagList/DWTagList.h>
#import "SearchHistory.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MLpingjiaViewController.h"
#import "MLHttpManager.h"
#import "MLShopInfoViewController.h"
#import "MLHelpCenterDetailController.h"
#import "OffLlineShopCart.h"
#import "MBProgressHUD+Add.h"
#import "CompanyInfo.h"
#import "IMJIETagView.h"
#import "IMJIETagFrame.h"
#import "CommonHeader.h"
#import "MLBuyKnowViewController.h"
#import "MLPingjiaListViewController.h"
#import "MLHttpManager.h"
@interface UIImage (SKTagView)

+ (UIImage *)imageWithColor: (UIColor *)color;
@end

@interface MLGoodsDetailsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,YAScrollSegmentControlDelegate,DWTagListDelegate,IMJIETagViewDelegate,UIGestureRecognizerDelegate>{
    
    NSDictionary *pDic;//商品详情信息
    NSDictionary *dPDic;//店铺详情信息
    
    NSMutableArray *_imageArray;//轮播图数组
    
    NSMutableArray *_recommendArray;
    NSArray *_titleArray;//随机出现的商品属性选择的标题数组
    NSArray *tempArr;
    
    YAScrollSegmentControl *titleView;//标题上选择查看商品还是详情按钮
    NSString *userid;
    NSString *spid;
    NSString *weburl;
    BOOL isglobal;
    NSMutableArray *imgUrlArray;
    
    UIView *overView;
    
    NSMutableDictionary *guigeDic;//总的规格字典
    NSMutableArray *porpertyArray;//规格数组
    NSMutableArray *huoyuanArray;//规格1
    NSMutableArray *jieduanArray;//规格2
//    DWTagList *huoyuanList;
//    DWTagList *jieduanList;
    
    NSMutableArray *promotionArray;//优惠券
    
    NSDictionary *Searchdic;//根据选的规格遍历出来的商品信息
    
    NSString *phoneNum;
    
    NSString *DPuid;
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;//最底层的SV
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontrol;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pingmuW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pingmuH;

@property (strong, nonatomic) IBOutlet UIScrollView *pingmu1rootScrollView;//第一页的SV商品页
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) IBOutlet UILabel *biaotiLabel;//标题
@property (strong, nonatomic) IBOutlet UILabel *texingLabel;//特性
@property (strong, nonatomic) IBOutlet UILabel *jiageLabel;//价格
@property (strong, nonatomic) IBOutlet UILabel *yuanjiaLabel;//原价
@property (strong, nonatomic) IBOutlet UIButton *shoucangButton;//收藏按钮
@property (strong, nonatomic) IBOutlet UILabel *yuanchandiLabel;//原产地

@property (strong, nonatomic) IBOutlet UIView *kujingBgView;//跨境商品显示选项的主视图，是跨境商品的时候显示且zengpinTH = 120 不是的时候隐藏且 zengpinTH = 0
@property (strong, nonatomic) IBOutlet UILabel *shuilvLabel;//跨境商品有的税率
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *zengpinTH;//跨境 = 120，正常 = 0

@property (strong, nonatomic) IBOutlet UILabel *huodongLabel;//活动
@property (strong, nonatomic) IBOutlet UIImageView *zengpImageView;//赠品图片
@property (strong, nonatomic) IBOutlet UILabel *zengpinnameLabel;//赠品文字
@property (strong, nonatomic) IBOutlet UILabel *cuxiaoxinxiLabel;//促销信息

@property (strong, nonatomic) IBOutlet UITableView *tableView;//选择商品类型，应该是类似于大小颜色之类的，cell应是随机标题+随机的选项按钮（未完成）
@property (strong, nonatomic) IBOutlet UILabel *kuncuntisLabel;//库存
@property (strong, nonatomic) IBOutlet CPStepper *shuliangStepper;
@property (strong, nonatomic) IBOutlet UIView *pingjiaView;//遍历这个View,来修改星星图片 tag 101~105
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *likeH;//猜你喜欢的collectionView的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tisH;

@property (strong, nonatomic) IBOutlet UIWebView *webView;//图文详情，加在第二页

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kuajingHeight;

@property (nonatomic,strong)MLKuajingCell *xiaoshuiView;
@property (nonatomic,strong)MLKuajingCell *zengzhiView;
@property (weak, nonatomic) IBOutlet UIView *tedianView;
@property (weak, nonatomic) IBOutlet UIView *zengpinView;
@property (weak, nonatomic) IBOutlet UIView *huoYuanView;
@property (weak, nonatomic) IBOutlet UIView *jieDuanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuxiaoH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuxiaoxinxiH;
@property (weak, nonatomic) IBOutlet UIView *biaotiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigeH;

@property (weak, nonatomic) IBOutlet UIImageView *dianpuimage;
@property (weak, nonatomic) IBOutlet UILabel *dianpuname;
@property (weak, nonatomic) IBOutlet UILabel *dianputexing;
@property (weak, nonatomic) IBOutlet UILabel *miaoshuNum;
@property (weak, nonatomic) IBOutlet UILabel *fuwuNum;
@property (weak, nonatomic) IBOutlet UILabel *wuliuNum;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuNum;
@property (weak, nonatomic) IBOutlet UILabel *shangpinNum;
@property (weak, nonatomic) IBOutlet UILabel *dongtaiNum;
@property (weak, nonatomic) IBOutlet UIView *lianxikefuView;
@property (weak, nonatomic) IBOutlet UIView *jinrudianpuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yonghucaozuoH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dianpuH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuanchandiH;
@property (weak, nonatomic) IBOutlet UIView *yuanchandiView;
@property (weak, nonatomic) IBOutlet UIView *blankview;
@property (weak, nonatomic) IBOutlet UIButton *jiarugouwucheBtn;




@end

@implementation MLGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleView = [[YAScrollSegmentControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH - 20, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.tintColor = [UIColor clearColor];
    titleView.buttons = @[@"商品",@"图文详情"];
    
    [titleView setTitleColor:[UIColor colorWithHexString:@"AE8E5D"] forState:UIControlStateSelected];
    [titleView setTitleColor:[UIColor colorWithHexString:@"A9A9A9"] forState:UIControlStateNormal];
//    [titleView setBackgroundImage:[UIImage imageNamed:@"sel_type_g"] forState:UIControlStateSelected];
//    [titleView setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
    titleView.delegate = self;
    self.navigationItem.titleView = titleView;
    pDic = [[NSDictionary alloc] init];
    _recommendArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSArray alloc] init];
    huoyuanArray = [[NSMutableArray alloc]init];
    jieduanArray = [[NSMutableArray alloc] init];
    promotionArray = [[NSMutableArray alloc] init];
    porpertyArray = [[NSMutableArray alloc] init];
    Searchdic = [[NSDictionary alloc] init];
    
    imgUrlArray = [NSMutableArray array];
    // 一期隐藏
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share1"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    _imageScrollView.delegate = self;
    _imageArray = [[NSMutableArray alloc] init];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightbackButtonAction)];
    
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftbackButtonAction)];
    
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftRecognizer];
    
    
    //设置SV1 上拉加载
    
    MJRefreshAutoStateFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.mainScrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_HEIGHT - 64);
            titleView.selectedIndex = 1;
        } completion:^(BOOL finished) {
            //结束加载
            [_pingmu1rootScrollView.footer endRefreshing];
        }];
        
    }];
    
    [footer setTitle:@"点击或继续拖动，查看图文详情" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"加载失败" forState:MJRefreshStateNoMoreData];
    _pingmu1rootScrollView.footer = footer;
    
    
    //设置SV2 有下拉操作
    
    MJRefreshStateHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            //下拉执行对应的操作
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
            titleView.selectedIndex = 0;
        } completion:^(BOOL finished) {
            //结束加载
            [_webView.scrollView.header endRefreshing];
        }];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"点击或继续拖动返回" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即返回" forState:MJRefreshStatePulling];
    [header setTitle:@"加载失败" forState:MJRefreshStateNoMoreData];
    
    
    [self.shoucangButton addTarget:self action:@selector(addFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    _webView.scrollView.header = header;
    

    UIView *cover = [[UIView alloc]initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor whiteColor];
    overView = cover;
    [self.view addSubview:cover];
    
    self.lianxikefuView.layer.borderWidth = 1.f;
    self.lianxikefuView.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
    self.lianxikefuView.layer.cornerRadius = 4.f;
    self.lianxikefuView.layer.masksToBounds = YES;
    self.jinrudianpuView.layer.borderWidth = 1.f;
    self.jinrudianpuView.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
    self.jinrudianpuView.layer.cornerRadius = 4.f;
    self.jinrudianpuView.layer.masksToBounds = YES;
    
  //  [self loadDateProDetail];
    
   // [self loaddataDianpu];

    [self guessYLike];

}
-(void)addFavorite
{
    
}

- (void)rightbackButtonAction{
    [self didSelectItemAtIndex:0];
    titleView.selectedIndex = 0;
    
}

- (void)leftbackButtonAction{
    
    [self didSelectItemAtIndex:1];
    titleView.selectedIndex = 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [super viewWillAppear:animated];
    _pingmuH.constant = MAIN_SCREEN_HEIGHT - 64 - 45;
    _pingmuW.constant = MAIN_SCREEN_WIDTH;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    DPuid = [userDefaults valueForKey:DIANPU_MAIJIA_UID];
    [self loadDateProDetail];
    
}

- (IBAction)actPingjia:(id)sender {
 
    MLpingjiaViewController *vc = [[MLpingjiaViewController alloc] init];
    vc.paramDic = @{@"id":_paramDic[@"id"]};
    NSLog(@"pingjia===%@222%@",self.paramDic,vc.paramDic);
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark 获取商品详情数据
- (void)loadDateProDetail {
 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"===%@",_paramDic);
    
  //  if (userid) {
    //
        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=detail&id=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,_paramDic[@"id"],vCFBundleShortVersionStr];
        //测试链接
        //NSString *urlStr = @"http://bbctest.matrojp.com/api.php?m=product&s=detail&id=15233";
        
        [ MLHttpManager get:urlStr params:nil m:@"product" s:@"detail" success:^ (id responseObject) {
            NSLog(@"responseObject===%@",responseObject);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dic = responseObject[@"data"];
            if (dic[@"pinfo"][@"userid"]) {
                if ([DPuid isEqualToString:dic[@"pinfo"][@"userid"]]) {
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                    self.jiarugouwucheBtn.enabled = NO;
                }else{
                
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                    self.jiarugouwucheBtn.enabled = YES;
                }
            }
            
            pDic = responseObject[@"data"];
            [self loaddataDianpu];
            _titleArray = dic[@"pinfo"][@"porperty_name"];//规格名
            
            NSString *is_collect = dic[@"pinfo"][@"is_collect"];//是否收藏
            
            if ([is_collect isEqual:@0]) {
                
                self.shoucangButton.selected = NO;
                [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
                [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
                
            }else{
                
                self.shoucangButton.selected = YES;
                [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
                [self.shoucangButton setTitle:@"已收藏" forState:UIControlStateNormal];
                [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
            }
            
            if (_titleArray && _titleArray.count >0) {
                NSArray *porpertyArr = dic[@"pinfo"][@"porperty"];
                [porpertyArray addObjectsFromArray:porpertyArr];
                
                if (porpertyArr.count >0) {
                    
                    NSDictionary *guigeDic = porpertyArr[0];
                    NSString *is_promotion = dic[@"pinfo"][@"is_promotion"];
                    NSString *promition_start_time = dic[@"pinfo"][@"promition_start_time"];
                    NSString *promition_end_time = dic[@"pinfo"][@"promition_end_time"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
                    NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
                    NSDate *date=[dateFormatter dateFromString:nowdate];
                    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                    NSLog(@"timeSp:%@",timeSp);
                    
                    if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                        
                        float pricef = [guigeDic[@"price"] floatValue];
                        self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                        float  originprice= [guigeDic[@"market_price"] floatValue];
                        
                        NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                        
                        NSAttributedString *attrStr =
                        [[NSAttributedString alloc]initWithString:pricestr
                                                       attributes:
                         @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                        self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                        
                    }else if(![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                    
                    if ([is_promotion isEqualToString:@"1"]  && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                        
                        float pricef = [guigeDic[@"promotion_price"] floatValue];
                        self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                        float  originprice= [guigeDic[@"market_price"] floatValue];
                        
                        NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                        
                        NSAttributedString *attrStr =
                        [[NSAttributedString alloc]initWithString:pricestr
                                                       attributes:
                         @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                        self.yuanjiaLabel.attributedText=attrStr;
                    }else{
                    
                    float pricef = [guigeDic[@"price"] floatValue];
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [guigeDic[@"market_price"] floatValue];
                    
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                    }
                }
                    
                    [self.shuliangStepper setTextValue:1];
                    UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
                    UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
                    
                    NSString *amount = dic[@"pinfo"][@"amount"];
                    NSString *safe_amount = dic[@"pinfo"][@"safe_amount"];
                    
                    self.shuliangStepper.maxValue = amount.intValue;
                    
                    
                    if ((amount.floatValue - safe_amount.floatValue)>5) {
                        self.kuncuntisLabel.text = @"库存充足";
                        self.shuliangStepper.minValue = 1;
                    }else if((amount.floatValue - safe_amount.floatValue)>0 && (amount.floatValue - safe_amount.floatValue)<=5){
                        
                        self.kuncuntisLabel.text = @"库存紧张";
                        self.shuliangStepper.minValue = 1;
                    }
                    
                    if ((amount.floatValue - safe_amount.floatValue) == 0) {
                        [self.shuliangStepper setTextValue:0];
                        leftbtn.enabled=NO;
                        rightbtn.enabled = NO;
                        self.kuncuntisLabel.text = @"售罄";
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                    }
                    
                }
                
                int i = 0;
                
                for (NSDictionary *tempdic in porpertyArr) {
                    
                    NSArray *setmealArr = tempdic[@"setmeal"];
                    
                    if (setmealArr.count == 1) {
                        self.guigeH.constant = 40;
                        NSDictionary *guigeDic1 = setmealArr[0];
                        NSString *guigestr1 = guigeDic1[@"name"];
                        if (i == 0) {
                            [huoyuanArray addObject:guigestr1];
                        }else{


                            if ([huoyuanArray containsObject:guigestr1]) {
                                
                            }else{
                                
                                [huoyuanArray addObject:guigestr1];
                            }

                        }
                        
                        i++;
                        
                    }else{
                        
                        NSDictionary *guigeDic1 = setmealArr[0];
                        NSDictionary *guigeDic2 = setmealArr[1];
                        NSString *guigestr1 = guigeDic1[@"name"];
                        NSString *guigestr2 = guigeDic2[@"name"];
                        if (i == 0) {
                            
                            [huoyuanArray addObject:guigestr1];
                            
                        }else{
                            
                            if ([huoyuanArray containsObject:guigestr1]) {
                                
                            }else{
                                
                                [huoyuanArray addObject:guigestr1];
                            }
                            
                        }
                        i++;
                        if ([jieduanArray containsObject:guigestr2]) {
                            
                        }else{
                            
                            [jieduanArray addObject:guigestr2];
                            
                        }
                    }
                    
                }
                
                [_tableView reloadData];
            }
            else{
                
                self.guigeH.constant = 0;
                
                NSString *promition_start_time = dic[@"pinfo"][@"promition_start_time"];
                NSString *promition_end_time = dic[@"pinfo"][@"promition_end_time"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
                NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
                NSDate *date=[dateFormatter dateFromString:nowdate];
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                NSLog(@"timeSp:%@",timeSp);
                
                if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                    
                    float pricef = [dic[@"pinfo"][@"price"] floatValue];
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [dic[@"pinfo"][@"market_price"] floatValue];
                    
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                }else if (![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                    
                    NSString *is_promotion = dic[@"pinfo"][@"is_promotion"];
                    NSLog(@"%f===111%f===222%f",timeSp.doubleValue,promition_start_time.doubleValue,promition_end_time.doubleValue);
                    
                    if ([is_promotion isEqualToString:@"1"] && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                        
                        float pricef = [dic[@"pinfo"][@"promotion_price"]floatValue] ;
                        self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                        float  originprice= [dic[@"pinfo"][@"market_price"] floatValue];
                        
                        NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                        
                        NSAttributedString *attrStr =
                        [[NSAttributedString alloc]initWithString:pricestr
                                                       attributes:
                         @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                        self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                        
                    }else{
                        
                        float pricef = [dic[@"pinfo"][@"price"] floatValue];
                        self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                        float  originprice= [dic[@"pinfo"][@"market_price"] floatValue];
                        
                        NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                        
                        NSAttributedString *attrStr =
                        [[NSAttributedString alloc]initWithString:pricestr
                                                       attributes:
                         @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                        self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    }
                }
                
                self.shuliangStepper.paramDic = dic;
                
                [self.shuliangStepper setTextValue:1];
                UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
                UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
                
                NSString *amount = dic[@"pinfo"][@"amount"];
                NSString *safe_amount = dic[@"pinfo"][@"safe_amount"];
                NSString *sell_amount = dic[@"pinfo"][@"sell_amount"];
                self.shuliangStepper.maxValue = amount.intValue;
                
                
                if ((amount.floatValue - safe_amount.floatValue)>5) {
                    self.kuncuntisLabel.text = @"库存充足";
                    self.shuliangStepper.minValue = 1;
                }else if((amount.floatValue - safe_amount.floatValue)>0 && (amount.floatValue - safe_amount.floatValue)<=5){
                    
                    self.kuncuntisLabel.text = @"库存紧张";
                    self.shuliangStepper.minValue = 1;
                }
                
                if ((amount.floatValue - safe_amount.floatValue) == 0) {
                    [self.shuliangStepper setTextValue:0];
                    leftbtn.enabled=NO;
                    rightbtn.enabled = NO;
                    self.kuncuntisLabel.text = @"售罄";
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                }
                
            }
            
            NSArray *promotionArr = dic[@"promotion"];
            
            for (NSDictionary *promotionDic in promotionArr) {
                
                NSString *nameStr = promotionDic[@"name"];
                [promotionArray addObject:nameStr];
            }
            
            //①②③④⑤⑥⑦⑧⑨⑩
            if (promotionArray.count == 0) {
                self.cuxiaoxinxiLabel.text = @"";
            }else if (promotionArray.count == 1){
                self.cuxiaoH .constant  = 40;
                self.cuxiaoxinxiH.constant  = 18;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@",promotionArray[0]];
            }
            else if (promotionArray.count == 2){
                self.cuxiaoH.constant  = 58;
                self.cuxiaoxinxiH.constant  = 36;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@",promotionArray[0],promotionArray[1]];
            }else if (promotionArray.count == 3){
                self.cuxiaoH.constant  = 76;
                self.cuxiaoxinxiH.constant  = 54;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@",promotionArray[0],promotionArray[1],promotionArray[2]];
            }else if (promotionArray.count == 4){
                self.cuxiaoH.constant  = 94;
                self.cuxiaoxinxiH.constant  = 72;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3]];
            }else if (promotionArray.count == 5){
                self.cuxiaoH.constant  = 112;
                self.cuxiaoxinxiH.constant  = 90;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4]];
            }else if (promotionArray.count == 6){
                self.cuxiaoH.constant  = 130;
                self.cuxiaoxinxiH.constant  = 108;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5]];
            }else if (promotionArray.count == 7){
                self.cuxiaoH.constant  = 148;
                self.cuxiaoxinxiH.constant  = 126;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@\n⑦ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5],promotionArray[6]];
            }else if (promotionArray.count == 8){
                self.cuxiaoH.constant  = 166;
                self.cuxiaoxinxiH.constant  = 144;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@\n⑦ %@\n⑧ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5],promotionArray[6],promotionArray[7]];
            }
            
            NSString *count = dic[@"comment_score"];
            
            UIImage *image1 = [UIImage imageNamed:@"Star_big2"];
            
            if (count.intValue == 0) {
                
                self.star1.image = image1;
                self.star2.image = image1;
                self.star3.image = image1;
                self.star4.image = image1;
                self.star5.image = image1;
            }else if (count.intValue == 1){
                
                self.star2.image = image1;
                self.star3.image = image1;
                self.star4.image = image1;
                self.star5.image = image1;
                
            }else if (count.intValue == 2){
                
                self.star3.image = image1;
                self.star4.image = image1;
                self.star5.image = image1;
                
            }else if (count.intValue == 3){
                
                self.star4.image = image1;
                self.star5.image = image1;
                
            }else if (count.intValue == 4){
                
                self.star5.image = image1;
                
            }else if (count.intValue == 5){
                
                
            }
            
            if (dic && dic[@"pinfo"] && dic[@"pinfo"]!=[NSNull null]) {
                
                NSDictionary *tempdic = dic[@"pinfo"];
                self.shareDic = tempdic;
                if (tempdic[@"jmsp_id"] && tempdic[@"jmsp_id"] !=[NSNull null]) {
                    spid = dic[@"pinfo"][@"jmsp_id"];
                    
                }
                
                //加载h5详情页
                if (dic[@"pinfo"][@"detail"]) {
                    NSString *htmlCode = [NSString stringWithFormat:@"<html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"><style type=\"text/css\">body{font-size : 0.9em;}img{width:%@ !important;}</style></head><body>%@</body></html>",@"100%",dic[@"pinfo"][@"detail"]];
                    NSLog(@"%@",htmlCode);
                    
                    [self.webView loadHTMLString:htmlCode baseURL:nil];
                }
                
                self.biaotiLabel.text = dic[@"pinfo"][@"pname"];
                self.texingLabel.text = dic[@"pinfo"][@"p_name"];
                
                
                
                if ([dic[@"pinfo"][@"way"] isEqualToString:@"1"]) {
                    self.kujingBgView.hidden = YES;
                    self.kuajingHeight.constant = 0;
                    isglobal = NO;
                    [self.tedianView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.biaotiView.mas_bottom);
                    }];
                }
                else if ([dic[@"pinfo"][@"way"] isEqualToString:@"3"]){
                    
                    self.kujingBgView.hidden = YES;
                    self.kuajingHeight.constant = 0;
                    isglobal = NO;
                    
                }
                
                else{
                    self.kujingBgView.hidden = NO;
                    self.kuajingHeight.constant = 120;
                    
                    if (![dic[@"pinfo"][@"production_name"] isEqualToString:@""]) {
                        self.yuanchandiLabel.text = dic[@"pinfo"][@"production_name"];
                        self.blankview.hidden = YES;
                    }else{
                        self.yuanchandiView.hidden = YES;
                        self.yuanchandiH.constant = 0;
                        self.kuajingHeight.constant = 80;
                        
                    }
                    
                    float xiaofeishuilv = [dic[@"pinfo"][@"tax"] floatValue];
                    float pricef = [dic[@"pinfo"][@"price"] floatValue];
                    float zengzhishuilv = [dic[@"tax"][@"vat"] floatValue];
                    float shuifei =(((xiaofeishuilv + zengzhishuilv)/(1 - xiaofeishuilv)) * 0.7) * pricef;
                    self.shuilvLabel.text =[NSString stringWithFormat:@"预计￥%.2f",shuifei];
                    
                    
                    isglobal = YES;
                    
                }
                
            }
            if (dic && dic[@"pinfo"] && dic[@"pinfo"] !=[NSNull null]) {
                
                NSDictionary *tempdic2 = dic[@"pinfo"];
                if (tempdic2[@"detail"] && tempdic2[@"detail"] !=[NSNull null]) {
                    weburl = tempdic2[@"detail"];
                }
            }
            
            NSLog(@"_imageArray===%@",dic[@"pinfo"][@"pic_more"]);
            _imageArray = dic[@"pinfo"][@"pic_more"];
            
            if (![_imageArray isKindOfClass:[NSNull class]]) {//防崩溃
                [self imageUIInit];
            }
            
            
            [overView removeFromSuperview];
            
        } failure:^( NSError *error) {
            [overView removeFromSuperview];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];
   // }
    /*
    else{

        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=detail&id=%@",MATROJP_BASE_URL,_paramDic[@"id"]];
        //测试链接
        // NSString *urlStr = @"http://bbctest.matrojp.com/api.php?m=product&s=detail&id=15233";
        
        [[HFSServiceClient sharedJSONClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject===%@",responseObject);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dic = responseObject[@"data"];
            pDic = responseObject[@"data"];
            
            _titleArray = dic[@"pinfo"][@"porperty_name"];//规格名
            
            NSString *is_collect = dic[@"pinfo"][@"is_collect"];//是否收藏
            
            if ([is_collect isEqual:@0]) {
                self.shoucangButton.selected = NO;
                [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
                [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
            }else{
                
                self.shoucangButton.selected = YES;
                [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
                [self.shoucangButton setTitle:@"已收藏" forState:UIControlStateNormal];
                [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
            }
            
            if (_titleArray && _titleArray.count >0) {
                NSArray *porpertyArr = dic[@"pinfo"][@"porperty"];
                [porpertyArray addObjectsFromArray:porpertyArr];
                
                if (porpertyArr.count >0) {
                    
                    NSDictionary *guigeDic = porpertyArr[0];
                    
                    float pricef = [guigeDic[@"promotion_price"] floatValue];
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [guigeDic[@"market_price"] floatValue];
                    
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                    
                    [self.shuliangStepper setTextValue:1];
                    UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
                    UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
                    
                    NSString *amount = dic[@"pinfo"][@"amount"];
                    NSString *safe_amount = dic[@"pinfo"][@"safe_amount"];
                    
                    self.shuliangStepper.maxValue = amount.intValue;
                    
                    
                    if (amount.floatValue >= safe_amount.floatValue) {
                        self.kuncuntisLabel.text = @"库存充足";
                    }else if(amount.floatValue < safe_amount.floatValue){
                        
                        self.kuncuntisLabel.text = [NSString stringWithFormat:@"%@",amount];
                    }
                    
                    if (amount.floatValue == 0) {
                        [self.shuliangStepper setTextValue:0];
                        leftbtn.enabled=NO;
                        rightbtn.enabled = NO;
                        self.kuncuntisLabel.text = @"售罄";
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                    }
                    
                    
                }
                
                
                int i = 0;
                
                for (NSDictionary *tempdic in porpertyArr) {
                    
                    NSArray *setmealArr = tempdic[@"setmeal"];
                    
                    if (setmealArr.count == 1) {
                        self.guigeH.constant = 40;
                        NSDictionary *guigeDic1 = setmealArr[0];
                        NSString *guigestr1 = guigeDic1[@"name"];
                        if (i == 0) {
                            [huoyuanArray addObject:guigestr1];
                        }else{
                            
                            for (NSString *searchstr in huoyuanArray) {
                                if (![guigestr1 isEqualToString:searchstr]) {
                                    [huoyuanArray addObject:guigestr1];
                                }else{
                                    
                                }
                            }
                        }
                        
                        i++;
                        
                    }else{
                        
                        NSDictionary *guigeDic1 = setmealArr[0];
                        NSDictionary *guigeDic2 = setmealArr[1];
                        NSString *guigestr1 = guigeDic1[@"name"];
                        NSString *guigestr2 = guigeDic2[@"name"];
                        if (i == 0) {
                            
                            [huoyuanArray addObject:guigestr1];
                            
                        }else{
                            
                            if ([huoyuanArray containsObject:guigestr1]) {
                                
                            }else{
                                
                                [huoyuanArray addObject:guigestr1];
                            }
                            
                        }
                        i++;
                        if ([jieduanArray containsObject:guigestr2]) {
                            
                        }else{
                            
                            [jieduanArray addObject:guigestr2];
                            
                        }
                    }
                    
                }
                
                [_tableView reloadData];
            }
            else{
                
                self.guigeH.constant = 0;
                
                NSString *promition_start_time = dic[@"pinfo"][@"promition_start_time"];
                NSString *promition_end_time = dic[@"pinfo"][@"promition_end_time"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
                NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
                NSDate *date=[dateFormatter dateFromString:nowdate];
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                NSLog(@"timeSp:%@",timeSp);
                
                if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                    
                    float pricef = [dic[@"pinfo"][@"price"] floatValue];
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [dic[@"pinfo"][@"market_price"] floatValue];
                    
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                }else if (![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                    
                    NSString *is_promotion = dic[@"pinfo"][@"is_promotion"];
                    NSLog(@"%f===111%f===222%f",timeSp.doubleValue,promition_start_time.doubleValue,promition_end_time.doubleValue);
                    
                    if ([is_promotion isEqualToString:@"1"] && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                        
                        float pricef = [dic[@"pinfo"][@"promotion_price"]floatValue] ;
                        self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                        float  originprice= [dic[@"pinfo"][@"market_price"] floatValue];
                        
                        NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                        
                        NSAttributedString *attrStr =
                        [[NSAttributedString alloc]initWithString:pricestr
                                                       attributes:
                         @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                        self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                        
                    }else{
                        
                        float pricef = [dic[@"pinfo"][@"price"] floatValue];
                        self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                        float  originprice= [dic[@"pinfo"][@"market_price"] floatValue];
                        
                        NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                        
                        NSAttributedString *attrStr =
                        [[NSAttributedString alloc]initWithString:pricestr
                                                       attributes:
                         @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                           NSForegroundColorAttributeName:[UIColor grayColor],
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                           NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                        self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    }
                }
                
                self.shuliangStepper.paramDic = dic;
                
                [self.shuliangStepper setTextValue:1];
                UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
                UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
                
                NSString *amount = dic[@"pinfo"][@"amount"];
                NSString *safe_amount = dic[@"pinfo"][@"safe_amount"];
                NSString *sell_amount = dic[@"pinfo"][@"sell_amount"];
                self.shuliangStepper.maxValue = amount.intValue;
                
                
                if (amount.floatValue >= safe_amount.floatValue) {
                    self.kuncuntisLabel.text = @"库存充足";
                }else if(amount.floatValue < safe_amount.floatValue){
                    
                    self.kuncuntisLabel.text = [NSString stringWithFormat:@"%@",amount];
                }
                
                if (amount.floatValue == 0) {
                    [self.shuliangStepper setTextValue:0];
                    leftbtn.enabled=NO;
                    rightbtn.enabled = NO;
                    self.kuncuntisLabel.text = @"售罄";
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                }
            }
            
            NSArray *promotionArr = dic[@"promotion"];
            
            for (NSDictionary *promotionDic in promotionArr) {
                
                NSString *nameStr = promotionDic[@"name"];
                [promotionArray addObject:nameStr];
            }
            
            //①②③④⑤⑥⑦⑧⑨⑩
            if (promotionArray.count == 0) {
                self.cuxiaoxinxiLabel.text = @"";
            }else if (promotionArray.count == 1){
                self.cuxiaoH .constant  = 40;
                self.cuxiaoxinxiH.constant  = 18;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@",promotionArray[0]];
            }
            else if (promotionArray.count == 2){
                self.cuxiaoH.constant  = 58;
                self.cuxiaoxinxiH.constant  = 36;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@",promotionArray[0],promotionArray[1]];
            }else if (promotionArray.count == 3){
                self.cuxiaoH.constant  = 76;
                self.cuxiaoxinxiH.constant  = 54;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@",promotionArray[0],promotionArray[1],promotionArray[2]];
            }else if (promotionArray.count == 4){
                self.cuxiaoH.constant  = 94;
                self.cuxiaoxinxiH.constant  = 72;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3]];
            }else if (promotionArray.count == 5){
                self.cuxiaoH.constant  = 112;
                self.cuxiaoxinxiH.constant  = 90;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4]];
            }else if (promotionArray.count == 6){
                self.cuxiaoH.constant  = 130;
                self.cuxiaoxinxiH.constant  = 108;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5]];
            }else if (promotionArray.count == 7){
                self.cuxiaoH.constant  = 148;
                self.cuxiaoxinxiH.constant  = 126;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@\n⑦ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5],promotionArray[6]];
            }else if (promotionArray.count == 8){
                self.cuxiaoH.constant  = 166;
                self.cuxiaoxinxiH.constant  = 144;
                self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@\n⑦ %@\n⑧ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5],promotionArray[6],promotionArray[7]];
            }
            
            NSString *count = dic[@"comment_score"];
            
            UIImage *image1 = [UIImage imageNamed:@"Star_big2"];
            
            if (count.intValue == 0) {
                
                self.star1.image = image1;
                self.star2.image = image1;
                self.star3.image = image1;
                self.star4.image = image1;
                self.star5.image = image1;
            }else if (count.intValue == 1){
                
                self.star2.image = image1;
                self.star3.image = image1;
                self.star4.image = image1;
                self.star5.image = image1;
                
            }else if (count.intValue == 2){
                
                self.star3.image = image1;
                self.star4.image = image1;
                self.star5.image = image1;
                
            }else if (count.intValue == 3){
                
                self.star4.image = image1;
                self.star5.image = image1;
                
            }else if (count.intValue == 4){
                
                self.star5.image = image1;
                
            }else if (count.intValue == 5){
                
                
            }
            
            if (dic && dic[@"pinfo"] && dic[@"pinfo"]!=[NSNull null]) {
                
                NSDictionary *tempdic = dic[@"pinfo"];
                self.shareDic = tempdic;
                if (tempdic[@"jmsp_id"] && tempdic[@"jmsp_id"] !=[NSNull null]) {
                    spid = dic[@"pinfo"][@"jmsp_id"];
                    
                }
                
                //加载h5详情页
                if (dic[@"pinfo"][@"detail"]) {
                    NSString *htmlCode = [NSString stringWithFormat:@"<html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"><style type=\"text/css\">body{font-size : 0.9em;}img{width:%@ !important;}</style></head><body>%@</body></html>",@"100%",dic[@"pinfo"][@"detail"]];
                    NSLog(@"%@",htmlCode);
                    
                    [self.webView loadHTMLString:htmlCode baseURL:nil];
                }
                
                self.biaotiLabel.text = dic[@"pinfo"][@"pname"];
                self.texingLabel.text = dic[@"pinfo"][@"p_name"];
                
                
                
                if ([dic[@"pinfo"][@"way"] isEqualToString:@"1"]) {
                    self.kujingBgView.hidden = YES;
                    self.kuajingHeight.constant = 0;
                    isglobal = NO;
                    [self.tedianView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.biaotiView.mas_bottom);
                    }];
                }
                else if ([dic[@"pinfo"][@"way"] isEqualToString:@"3"]){
                    
                    self.kujingBgView.hidden = YES;
                    self.kuajingHeight.constant = 0;
                    isglobal = NO;
                    
                }
                
                else{
                    self.kujingBgView.hidden = NO;
                    self.kuajingHeight.constant = 120;
                    
                    if (dic[@"pinfo"][@"production_name"]) {
                        self.yuanchandiLabel.text = dic[@"pinfo"][@"production_name"];
                        
                    }
                    
                    float xiaofeishuilv = [dic[@"pinfo"][@"tax"] floatValue];
                    float pricef = [dic[@"pinfo"][@"price"] floatValue];
                    float zengzhishuilv = [dic[@"tax"][@"vat"] floatValue];
                    float shuifei =(((xiaofeishuilv + zengzhishuilv)/(1 - xiaofeishuilv)) * 0.7) * pricef;
                    self.shuilvLabel.text =[NSString stringWithFormat:@"预计￥%.2f",shuifei];
                    
                    
                    isglobal = YES;
                    
                }
                
            }
            if (dic && dic[@"pinfo"] && dic[@"pinfo"] !=[NSNull null]) {
                
                NSDictionary *tempdic2 = dic[@"pinfo"];
                if (tempdic2[@"detail"] && tempdic2[@"detail"] !=[NSNull null]) {
                    weburl = tempdic2[@"detail"];
                }
            }
            
            NSLog(@"_imageArray===%@",dic[@"pinfo"][@"pic_more"]);
            _imageArray = dic[@"pinfo"][@"pic_more"];
            
            if (![_imageArray isKindOfClass:[NSNull class]]) {//防崩溃
                [self imageUIInit];
            }
            
            
            [overView removeFromSuperview];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [overView removeFromSuperview];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];
    }
   */
    

}


-(void)loaddataDianpu{
    

    NSLog(@"paramDic==%@===22%@",_paramDic,pDic);
    
    NSString *dpid = pDic[@"pinfo"][@"userid"];
   
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=shop&uid=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,dpid,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"shop" s:@"shop" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *shop_info = responseObject[@"data"][@"shop_info"];
            dPDic = shop_info;
            NSString *logo = shop_info[@"logo"];
            if (![logo isKindOfClass:[NSNull class]]) {
                [self.dianpuimage sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"icon_default"]];
            }else{
                
                self.dianpuimage.image = [UIImage imageNamed:@"icon_default"];
            }
            NSArray *csarr = shop_info[@"cs"];
            if (csarr.count == 0) {
                self.dianpuH.constant = 166;
                self.yonghucaozuoH.constant = 0;
            }else{
                for (NSDictionary *tempdic in csarr) {
                    NSString *tool = tempdic[@"tool"];
                    NSString *number = tempdic[@"number"];
                    if ([tool isEqualToString:@"4"]) {
                        phoneNum = number;
                        break;
                    }
                    
                }
                
                if (![phoneNum isEqualToString:@""]) {
                    self.dianpuH.constant = 210;
                    self.yonghucaozuoH.constant = 44;
                }else{
                    
                    self.dianpuH.constant = 166;
                    self.yonghucaozuoH.constant = 0;
                }
            }
            
            
            self.dianpuname.text = shop_info[@"company"];
            self.dianputexing.text = shop_info[@"main_pro"];
            NSString  *score_a = shop_info[@"score_a"];
            NSString *score_b = shop_info[@"score_b"];
            NSString *score_c = shop_info[@"score_c"];
            
            self.miaoshuNum.text = [NSString stringWithFormat:@"%@",score_a];
            self.fuwuNum.text = [NSString stringWithFormat:@"%@",score_b];
            self.wuliuNum.text = [NSString stringWithFormat:@"%@",score_c];
            
            self.guanzhuNum.text = shop_info[@"shop_collect"];
            self.shangpinNum.text = shop_info[@"product_num"];
            self.dongtaiNum.text = shop_info[@"news_num"];
            
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
        
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *shop_info = responseObject[@"data"][@"shop_info"];
            dPDic = shop_info;
            NSString *logo = shop_info[@"logo"];
            if (![logo isKindOfClass:[NSNull class]]) {
                [self.dianpuimage sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"icon_default"]];
            }else{
            
                self.dianpuimage.image = [UIImage imageNamed:@"icon_default"];
            }
            NSArray *csarr = shop_info[@"cs"];
            for (NSDictionary *tempdic in csarr) {
                NSString *tool = tempdic[@"tool"];
                NSString *number = tempdic[@"number"];
                if ([tool isEqualToString:@"4"]) {
                    phoneNum = number;
                    break;
                }
                
            }
    
            if (![phoneNum isEqualToString:@""]) {
                self.dianpuH.constant = 210;
                self.yonghucaozuoH.constant = 44;
            }else{
            
                self.dianpuH.constant = 166;
                self.yonghucaozuoH.constant = 0;
            }
            
            self.dianpuname.text = shop_info[@"company"];
            self.dianputexing.text = shop_info[@"main_pro"];
            NSString  *score_a = shop_info[@"score_a"];
            NSString *score_b = shop_info[@"score_b"];
            NSString *score_c = shop_info[@"score_c"];
            
            self.miaoshuNum.text = [NSString stringWithFormat:@"%@",score_a];
            self.fuwuNum.text = [NSString stringWithFormat:@"%@",score_b];
            self.wuliuNum.text = [NSString stringWithFormat:@"%@",score_c];
            
            self.guanzhuNum.text = shop_info[@"shop_collect"];
            self.shangpinNum.text = shop_info[@"product_num"];
            self.dongtaiNum.text = shop_info[@"news_num"];
            
        }
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
     */
    
}



- (void)guessYLike {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=guess_like&method=get_guess_like&start=0&limit=8&catid=&brandid=",MATROJP_BASE_URL];
    
    [MLHttpManager get:urlStr params:nil m:@"product" s:@"guess_like" success:^(id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        
        if(responseObject)
        {
            [_recommendArray removeAllObjects];
            NSArray *arr = responseObject[@"data"][@"product"];
            if (arr && arr.count>0) {
                [_recommendArray addObjectsFromArray:arr];
            }
        }
        
        NSInteger row = 2;
        if (_recommendArray.count != 0) {
            _likeH.constant = 170*row;
            
        }else{
            
            _likeH.constant = 0;
            
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"猜你喜欢 请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    /*
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关于税费计算
- (IBAction)actShuifei:(id)sender {
    NSString *code = @"35";
    MLHelpCenterDetailController *vc = [[MLHelpCenterDetailController alloc]init];
    vc.webCode = code;
    [self.navigationController  pushViewController:vc animated:YES];
    
}


#pragma mark 立即购买
- (IBAction)buyAction:(id)sender {
  
    [self addShoppingBag:nil];
    
    
}
#pragma mark 加入购物袋
- (IBAction)addShoppingBag:(id)sender {
    /*
     http://localbbc.matrojp.com/api.php?m=product&s=cart&action=add_cart
     POST
     id=12301 商品id    商品详情接口里的   pinfo  下的id
     nums=1 商品数量
     sid=12311 商品规格ID    没有规格的填0 有规格填 商品详情接口里的   pinfo  下的 property  下的 id 字段
     
     sku=0  商品货号   没有规格的时候填商品详情接口里的   pinfo  下的code,如果是带规格的那么填pinfo  下的 property  下的 sku字段
    */
    
    if ([self.kuncuntisLabel.text isEqualToString:@"售罄"]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"此商品已售罄";
        [_hud hide:YES afterDelay:1];
        return;
    }

    
    if (userid) {
        
    NSString *pid = pDic[@"pinfo"][@"id"];
    NSString *sid ;
    NSString *sku;
    if (_titleArray && _titleArray.count ==0) {
        sid = @"0";
        sku = pDic[@"pinfo"][@"code"]?:@"";
        
    }else{
        sid = Searchdic[@"id"]?:@"";
        sku= Searchdic[@"sku"]?:@"";
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=add_cart",MATROJP_BASE_URL];
    NSDictionary *params = @{@"id":pid,@"nums":[NSNumber numberWithInteger:_shuliangStepper.value],@"sid":sid,@"sku":sku};
    
    [MLHttpManager post:urlStr params:params m:@"product" s:@"cart" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *code = result[@"code"];
        if ([code isEqual:@0]) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"加入购物车成功";
            [_hud hide:YES afterDelay:1];
        }
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"加入购物车失败";
        [_hud hide:YES afterDelay:1];
    }];
        
    }else{ //离线情况下 本地缓存
        
        if (dPDic&&pDic) { //已经有店铺名称的和商品详情的情况
            //店铺id
            NSString *cid = _paramDic[@"userid"];
            NSString *pid = pDic[@"pinfo"][@"id"];
            //根据店铺id去查记录
            NSPredicate *cPre = [NSPredicate predicateWithFormat:@"cid == %@",cid];
            CompanyInfo *cp = [CompanyInfo MR_findFirstWithPredicate:cPre];
            if (cp) {//如果能查到店铺
                NSString *pids = cp.shopCart;
                //是否包含该记录
                if([pids rangeOfString:pid].location == NSNotFound)
                {//如果已经包含  查出该记录  记录Nums++
                    NSString *pids = cp.shopCart;
                    NSMutableArray *tmp = [[pids componentsSeparatedByString:@","] mutableCopy];
                    [tmp addObject:pid];
                    cp.shopCart = [tmp componentsJoinedByString:@","];
                    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
                }
            }else{ //如果查不到记录
                //添加一条店铺记录
                CompanyInfo *cp = [CompanyInfo MR_createEntity];
                cp.company = dPDic[@"company"];
                cp.cid = self.paramDic[@"userid"];
                cp.shopCart = pid;
                cp.checkAll = 0;
                [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
             }
           [self saveShopCartWithPid:pid];
            
        }
    }
    
}


- (void)saveShopCartWithPid:(NSString *)pid{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"pid == %@",pid];
    OffLlineShopCart *model2 = (OffLlineShopCart *)[OffLlineShopCart MR_findFirstWithPredicate:pre];
    if (model2) { //说明已经存在了 Num加
        model2.num ++;
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        [MBProgressHUD showMessag:@"加入购物车成功" toView:self.view];
    }
    else{ //如果没有就直接加进去
        OffLlineShopCart  *model = [OffLlineShopCart MR_createEntity];
        model.pid = pDic[@"pinfo"][@"id"];
        model.pname = pDic[@"pinfo"][@"pname"];
        model.pic = pDic[@"pinfo"][@"pic"];
        model.pro_price = [pDic[@"pinfo"][@"price"] floatValue];
        model.amount = [pDic[@"pinfo"][@"amount"] integerValue];
        model.num = 1;
        model.company_id= _paramDic[@"userid"];
        model.sid = pDic[@"pinfo"][@"property"][@"id"]?:@"0";
        model.sku = pDic[@"pinfo"][@"property"][@"sku"]?:pDic[@"pinfo"][@"code"];
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [MBProgressHUD showMessag:@"加入购物车成功" toView:self.view];
        }];
        
    }

}



#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MLLoginViewController *vc = [[MLLoginViewController alloc] init];
     vc.isLogin = YES;
   // YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
     [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark- 分享按钮
-(void)shareButtonAction{
    
    if (!self.shareDic) {
        return;
    }
    NSLog(@"self.paramDic===%@",self.shareDic);
    
    MLShareGoodsViewController *vc = [[MLShareGoodsViewController alloc]init];
    vc.paramDic = self.shareDic;
    
    if (self.imageScrollView.subviews.count>0) {
         UIImageView *imgView = [self.imageScrollView.subviews firstObject];
        vc.qzoneImg = imgView.image;
    }
   
    __weak typeof(self) weakself = self;
    vc.erweimaBlock = ^(){
        MLGoodsSharePhotoViewController *vc = [[MLGoodsSharePhotoViewController alloc]init];
        vc.goodsDetail = weakself.shareDic;
        vc.paramDic = weakself.shareDic;
        vc.img_url = imgUrlArray.count>0?[imgUrlArray firstObject]:@"";
        vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        [self presentViewController:vc  animated:YES completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             
         }];
    };
    vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }else{
        
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
        
    }
    
    [self presentViewController:vc  animated:YES completion:^(void)
     {
         vc.view.superview.backgroundColor = [UIColor clearColor];
         
     }];
    
    
}

#pragma mark- 图片相关
- (void)imageUIInit {
    
    CGFloat imageScrollViewWidth = MAIN_SCREEN_WIDTH;
    CGFloat imageScrollViewHeight = _imageScrollView.bounds.size.height;
    
        for(int i = 0; i<_imageArray.count; i++) {
            if ([_imageArray[i] isKindOfClass:[NSNull class]]) {
                continue;
            }

        }
    for (int i=0; i<_imageArray.count; i++) {
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        NSLog(@"imageview == %@",imageview.sd_imageURL);
        
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [imageview addGestureRecognizer:singleTap];
        [_imageScrollView addSubview:imageview];
    }
    
    _imageScrollView.contentSize = CGSizeMake(imageScrollViewWidth*_imageArray.count, 0);
    _imageScrollView.bounces = NO;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.delegate = self;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    
    _pagecontrol.numberOfPages = _imageArray.count;

}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",tap.view.tag);
    
    CPPhotoInfoViewController * vc = [[CPPhotoInfoViewController alloc]init];
    
    vc.bigPhotoImageArray =_imageArray;
    
    vc.bigPhotoImageNum = tap.view.tag;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _imageScrollView) {
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        _pagecontrol.currentPage = i - 1;
    }

}

- (IBAction)bagButtonAction:(id)sender {
    [self getAppDelegate].tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- 购买须知
- (IBAction)xuzhiAction:(id)sender {
    
    MLBuyKnowViewController *vc = [[MLBuyKnowViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- YAScrollSegmentControlDelegate
- (void)didSelectItemAtIndex:(NSInteger)index;{
    NSLog(@"%ld",index);
    if (titleView.selectedIndex == index) {
        return;
    }else{
        if (index == 0) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                //下拉执行对应的操作
                self.mainScrollView.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                //结束加载
                [_webView.scrollView.header endRefreshing];
            }];

        }else{
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.mainScrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_HEIGHT - 64);
            } completion:^(BOOL finished) {
                //结束加载
                [_pingmu1rootScrollView.footer endRefreshing];
            }];
            
        }
    }

}

#pragma mark - UIWebViewDelegate

//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    
//    //    webView.scrollView.scrollEnabled = NO;
////    webView.scrollView.bounces = NO;
////    _dataWebView.scrollView.delegate = self;
////    _infoBgviewHConstraint.constant = webView.scrollView.contentSize.height + 30;
////    _webRootScrollView.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH, _infoBgviewHConstraint.constant);
////    _webRootSHConstraint.constant = MAIN_SCREEN_HEIGHT - 114;
//}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error);
}



#pragma mark- UICollectionViewDataSource And UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _recommendArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RecommendCollectionViewCell" ;
    
    UINib *nib = [UINib nibWithNibName:@"RecommendCollectionViewCell"bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    
    RecommendCollectionViewCell * cell = (RecommendCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *paramdic = [_recommendArray objectAtIndex:indexPath.row];
    cell.productNameLabel.text = paramdic[@"pname"];
    NSString *picstr = paramdic[@"pic"];
    if (![picstr isKindOfClass:[NSNull class]]) {
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:paramdic[@"pic"]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    }else{
    
        cell.productImageView .image = [UIImage imageNamed:@"icon_default"];
    }
    
    NSString *pricestr = paramdic[@"price"];
    CGFloat price = [pricestr floatValue];
    cell.productPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    
    /*
    NSString *priceStr = paramdic[@"XJ"];
    NSString *realStr = paramdic[@"LSDJ"];
    CGFloat xj = [priceStr floatValue];
    CGFloat lsdj = [realStr floatValue];
    
    NSString   *newpriceStr = [NSString stringWithFormat:@"<font name = \"STHeitiSC-Light\" size = \"13\"><color value = \"#856D47\">￥%.2f </></><font name = \"STHeitiSC-Light\" size = \"13\"><strike  word=\"true\"><color value = \"#505050\">￥%.2f</></></>",xj,lsdj];
    cell.productPriceLabel.attributedText = [newpriceStr createAttributedString];
     */
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MAIN_SCREEN_WIDTH - 35)/4, 165);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    NSDictionary *dic = [_recommendArray objectAtIndex:indexPath.row];
    if (dic) {
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
        vc.paramDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 0);
}



#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    __weak typeof(self) weakself = self;
    static NSString *CellIdentifier = @"MLGoodsDetailsTableViewCell" ;
    MLGoodsDetailsTableViewCell *cell = (MLGoodsDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    
    cell.infoTitleLabel.text = [ NSString stringWithFormat:@"%@:", _titleArray[indexPath.row]];
    
    NSString *is_promotion = pDic[@"pinfo"][@"is_promotion"];
    NSString *promition_start_time = pDic[@"pinfo"][@"promition_start_time"];
    NSString *promition_end_time = pDic[@"pinfo"][@"promition_end_time"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
    NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
    NSDate *date=[dateFormatter dateFromString:nowdate];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    
    if (indexPath.row == 0) {
        
        cell.tags = huoyuanArray;
        cell.goodsBiaoQianSelBlock = ^(NSArray *tagsIndex){
    
            NSString *indexStr = [tagsIndex firstObject];
            NSInteger index = [indexStr integerValue];
            NSString *str = [huoyuanArray objectAtIndex:index];
            NSLog(@"%@",str);
            
            NSString *promotion_price;
            NSString *price;
            NSString *market_price;
            NSString *stock;
            NSString *safe_stock;
  
            for (NSDictionary *searchDic in porpertyArray) {
                NSMutableArray *guige = [[NSMutableArray alloc] init];
                NSArray *setmealArr = searchDic[@"setmeal"];
                if (setmealArr.count == 1) {
                    NSDictionary *guigeDic1 = setmealArr[0];
                    
                    NSString *guigestr1 = guigeDic1[@"name"];
                    
                    
                    [guige addObject:guigestr1];
                    
                }else{
                    
                    NSDictionary *guigeDic1 = setmealArr[0];
                    NSDictionary *guigeDic2 = setmealArr[1];
                    NSString *guigestr1 = guigeDic1[@"name"];
                    NSString *guigestr2 = guigeDic2[@"name"];
                    
                    [guige addObject:guigestr1];
                    [guige addObject:guigestr2];
                }
                for (NSString *searchStr in guige) {
                    if ([searchStr isEqualToString:str]) {
                        Searchdic = searchDic;
                        promotion_price = searchDic[@"promotion_price"];
                        price = searchDic[@"price"];
                        market_price = searchDic[@"market_price"];
                        stock = searchDic[@"stock"];
                        safe_stock = searchDic[@"safe_stock"];
                        
                    }
                }
            }
            
            NSLog(@"%@  %@  %@  %@  %@",promotion_price,price,market_price,stock,safe_stock);
            
            if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                
                float pricef = price.floatValue;
                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                
                float  originprice= [market_price floatValue];
                NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                NSAttributedString *attrStr =
                [[NSAttributedString alloc]initWithString:pricestr
                                               attributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                   NSForegroundColorAttributeName:[UIColor grayColor],
                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                   NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                self.yuanjiaLabel.attributedText = attrStr; //原价要划掉
                
            }else if(![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                
                if ([is_promotion isEqualToString:@"1"]  && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                    
                    float pricef = promotion_price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    
                    float  originprice= [market_price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText = attrStr; //原价要划掉
                    
                }else{
                    
                    float pricef = price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    
                    float  originprice= [market_price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText = attrStr; //原价要划掉
                    
                }
            }
            
//            float pricef = price.floatValue;
//            self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
//            
//            float  originprice= [market_price floatValue];
//            NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
//            NSAttributedString *attrStr =
//            [[NSAttributedString alloc]initWithString:pricestr
//                                           attributes:
//             @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
//               NSForegroundColorAttributeName:[UIColor grayColor],
//               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
//               NSStrikethroughColorAttributeName:[UIColor grayColor]}];
//            self.yuanjiaLabel.attributedText = attrStr; //原价要划掉
            
            
            [self.shuliangStepper setTextValue:1];
            UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
            UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
            self.shuliangStepper.maxValue = stock.intValue;
            
            if ((stock.floatValue - safe_stock.floatValue)>5) {
                self.kuncuntisLabel.text = @"库存充足";
                self.shuliangStepper.minValue = 1;
            }else if((stock.floatValue - safe_stock.floatValue)>0&&(stock.floatValue - safe_stock.floatValue)<=5){
                
                self.kuncuntisLabel.text = @"库存紧张";
                self.shuliangStepper.minValue = 1;
            }
            
            if ((stock.floatValue - safe_stock.floatValue) == 0) {
                [self.shuliangStepper setTextValue:0];
                leftbtn.enabled=NO;
                rightbtn.enabled = NO;
                self.kuncuntisLabel.text = @"售罄";
                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
            }
   
        };
        
    }else{
    
        cell.tags = jieduanArray;
        cell.goodsBiaoQianSelBlock = ^(NSArray *tagsIndex){
            
            NSString *indexStr = [tagsIndex firstObject];
            NSInteger index = [indexStr integerValue];
            NSString *str = [jieduanArray objectAtIndex:index];
            NSLog(@"%@",str);
            
            NSString *promotion_price;
            NSString *price;
            NSString *market_price;
            NSString *stock;
            NSString *safe_stock;
            
            
            for (NSDictionary *searchDic in porpertyArray) {
                NSMutableArray *guige = [[NSMutableArray alloc] init];
                NSArray *setmealArr = searchDic[@"setmeal"];
                if (setmealArr.count == 1) {
                    NSDictionary *guigeDic1 = setmealArr[0];
                    
                    NSString *guigestr1 = guigeDic1[@"name"];
                    
                    
                    [guige addObject:guigestr1];
                    
                }else{
                    
                    NSDictionary *guigeDic1 = setmealArr[0];
                    NSDictionary *guigeDic2 = setmealArr[1];
                    NSString *guigestr1 = guigeDic1[@"name"];
                    NSString *guigestr2 = guigeDic2[@"name"];
                    
                    [guige addObject:guigestr1];
                    [guige addObject:guigestr2];
                }
                for (NSString *searchStr in guige) {
                    if ([searchStr isEqualToString:str]) {
                        Searchdic = searchDic;
                        promotion_price = searchDic[@"promotion_price"];
                        price = searchDic[@"price"];
                        market_price = searchDic[@"market_price"];
                        stock = searchDic[@"stock"];
                        safe_stock = searchDic[@"safe_stock"];
                        
                    }
                }
            }
            
            NSLog(@"%@  %@  %@  %@",price,market_price,stock,safe_stock);
            
            if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                
                float pricef = price.floatValue;
                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                float  originprice= [market_price floatValue];
                NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                NSAttributedString *attrStr =
                [[NSAttributedString alloc]initWithString:pricestr
                                               attributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                   NSForegroundColorAttributeName:[UIColor grayColor],
                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                   NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                
            }else if(![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                
                if ([is_promotion isEqualToString:@"1"]  && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                    
                    float pricef = promotion_price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [market_price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                }else{
                    
                    float pricef = price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [market_price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                }
            }
            
//            float pricef = price.floatValue;
//            self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
//            float  originprice= [market_price floatValue];
//            NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
//            NSAttributedString *attrStr =
//            [[NSAttributedString alloc]initWithString:pricestr
//                                           attributes:
//             @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
//               NSForegroundColorAttributeName:[UIColor grayColor],
//               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
//               NSStrikethroughColorAttributeName:[UIColor grayColor]}];
//            self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
            
            
            [self.shuliangStepper setTextValue:1];
            UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
            UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
            
            
            if ((stock.floatValue - safe_stock.floatValue)>5) {
                self.kuncuntisLabel.text = @"库存充足";
                self.shuliangStepper.minValue = 1;
            }else if((stock.floatValue - safe_stock.floatValue)>0&&(stock.floatValue - safe_stock.floatValue)<=5){
                
                self.kuncuntisLabel.text = @"库存紧张";
                self.shuliangStepper.minValue = 1;
            }
            
            if ((stock.floatValue - safe_stock.floatValue) == 0) {
                [self.shuliangStepper setTextValue:0];
                leftbtn.enabled=NO;
                rightbtn.enabled = NO;
                self.kuncuntisLabel.text = @"售罄";
                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
            }
            
        };

    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
    frame.tagsMinPadding = 4;
    frame.tagsMargin = 10;
    frame.tagsLineSpacing = 10;
    frame.tagsArray = huoyuanArray;
    */
    
    return 40;
}


#pragma Mark 收藏
- (IBAction)shouCangClick:(id)sender {
  /*
    http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
   do = add 【操作码】
  
   pid= 13911 【商品id】
   
   uname = ml_13771961207【会员名】
 
  */
    
    NSString *pid = pDic[@"pinfo"][@"id"];
    NSString *uname = pDic[@"pinfo"][@"user"];
    if (userid) {
        
        if (!self.shoucangButton.selected) {
        
        self.shoucangButton.selected = YES;

        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
        NSDictionary *params = @{@"do":@"add",@"pid":pid,@"uname":uname};
            
        
      [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
          NSDictionary *result = (NSDictionary *)responseObject;
          NSString *share_add = result[@"data"][@"share_add"];
          if (share_add) {
              [_hud show:YES];
              _hud.mode = MBProgressHUDModeText;
              _hud.labelText = @"收藏成功";
              [_hud hide:YES afterDelay:1];
              
              [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
              [self.shoucangButton setTitle:@"已收藏" forState:UIControlStateNormal];
              [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
          }
          NSLog(@"请求成功 result====%@",result);
      } failure:^(NSError *error) {
          NSLog(@"请求失败 error===%@",error);
          
      }];
    }else{
        self.shoucangButton.selected = NO;
        [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
        [self.shoucangButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
        [self deleteClick:pid];
        
        return;
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
}


#pragma Mark 取消收藏
- (void) deleteClick:(NSString*)sender{
    /*
     http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
     
     【post】
     
     do=del 【操作码】
     
     id=2281 【收藏商品id】
    */
    NSLog(@"pDic===%@",pDic);
    NSString *pid = pDic[@"pinfo"][@"id"];
  
    if (userid) {
 
            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
            NSDictionary *params = @{@"do":@"sel"};
            
            [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
                
                NSLog(@"请求成功responseObject===%@",responseObject);
                if (![responseObject[@"data"][@"share_list"] isKindOfClass:[NSNull class]]) {
        
                        
                        for (NSDictionary *tempdic in responseObject[@"data"][@"share_list"]) {
                            
                            if ([pid  isEqualToString:tempdic[@"pid"]]) {
                                
                                if (!self.shoucangButton.selected) {
                                    
                                self.shoucangButton.selected = NO;
                                [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
                                [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
                                    
                                NSString *ppid = tempdic[@"id"];
                                NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
                                NSDictionary *params = @{@"do":@"del",@"id":ppid};
                                
                                [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
                                    NSDictionary *result = (NSDictionary *)responseObject;
                                    NSString *share_add = result[@"data"][@"ads_del"];
                                    if (share_add) {
                                        [_hud show:YES];
                                        _hud.mode = MBProgressHUDModeText;
                                        _hud.labelText = @"取消收藏成功";
                                        [_hud hide:YES afterDelay:1];
                                    }else{
                                        
                                    }
                                    NSLog(@"请求成功 result====%@",result);
                                    
                                } failure:^(NSError *error) {
                                    NSLog(@"请求失败 error===%@",error);
                                    
                                }];
                            }else{
                                self.shoucangButton.selected = NO;
                                [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
                                [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
                                
                                return;
                                }
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
    }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
                [alert show];
        
        
                return;
            }

}

-(void)showError
{
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)actDianpu:(id)sender {
    
    MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    vc.store_link = [NSString stringWithFormat:@"%@/store?sid=%@&uid=%@",DianPuURL_URLString,_paramDic[@"userid"],phone];
    vc.uid = pDic[@"pinfo"][@"userid"];
    vc.shopparamDic = dPDic;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)actKefu:(id)sender {
    
    NSLog(@"联系客服%@",phoneNum);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:url];
    
}

@end



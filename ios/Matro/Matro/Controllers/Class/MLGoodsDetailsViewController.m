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
#import "MLBagViewController.h"
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

@interface UIImage (SKTagView)

+ (UIImage *)imageWithColor: (UIColor *)color;
@end

@interface MLGoodsDetailsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,YAScrollSegmentControlDelegate,DWTagListDelegate>{
    
    NSDictionary *pDic;//商品详情信息
    
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
    
    NSMutableArray *porpertyArray;//规格数组
    NSMutableArray *huoyuanArray;//规格1
    NSMutableArray *jieduanArray;//规格2
    DWTagList *huoyuanList;
    DWTagList *jieduanList;
    
    NSMutableArray *promotionArray;//优惠券
    
    NSDictionary *Searchdic;//根据选的规格遍历出来的商品信息
    
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




@end

@implementation MLGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleView = [[YAScrollSegmentControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH - 20, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.tintColor = [UIColor clearColor];
    titleView.buttons = @[@"商    品",@"图文详情"];
    
    [titleView setTitleColor:[UIColor colorWithHexString:@"AE8E5D"] forState:UIControlStateSelected];
    [titleView setTitleColor:[UIColor colorWithHexString:@"A9A9A9"] forState:UIControlStateNormal];
    [titleView setBackgroundImage:[UIImage imageNamed:@"sel_type_g"] forState:UIControlStateSelected];
    [titleView setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
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
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Share-1"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    _imageScrollView.delegate = self;
    _imageArray = [[NSMutableArray alloc] init];
    
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
    
    [self loadDateProDetail];

    [self guessYLike];

}
-(void)addFavorite
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
}

/*
-(DWTagList *)styleTagList:(DWTagList *)tagList {
    
    tagList.font = [UIFont systemFontOfSize:14.0f];
    tagList.borderColor = [UIColor colorWithHexString:@"#EBEBEB"];
    tagList.borderWidth = 1.f;
    //tagList.textColor = [UIColor colorWithHexString:@"#260E00"];
    tagList.labelMargin = 6.0f;
    //[tagList setTagBackgroundColor:RGBA(255, 255, 255, 1)];
    tagList.cornerRadius = 4.0f;
    tagList.horizontalPadding = 6.0f;
    tagList.verticalPadding = 6.0f;
    
    return tagList;
}
*/

- (IBAction)actPingjia:(id)sender {
    
    NSLog(@"pingjia===");
    MLpingjiaViewController *vc = [[MLpingjiaViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark 获取商品详情数据
- (void)loadDateProDetail {
    //http://bbctest.matrojp.com/api.php?m=product&s=detail&id=15233
    //测试用的  以后要删除
    //&test_phone=13771961207
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=detail&id=%@&test_phone=13771961207",@"http://bbctest.matrojp.com",_paramDic[@"id"]];
    //测试链接
    //NSString *urlStr = @"http://bbctest.matrojp.com/api.php?m=product&s=detail&id=15233";
    
    [[HFSServiceClient sharedJSONClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic = responseObject[@"data"];
        pDic = responseObject[@"data"];
        
        _titleArray = dic[@"pinfo"][@"porperty_name"];
        
        NSString *is_collect = dic[@"pinfo"][@"is_collect"];
        
        if ([is_collect isEqual:@0]) {
            self.shoucangButton.selected = NO;
            [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
            [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
        }else{
            
            self.shoucangButton.selected = YES;
            [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
            [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
        }
        
        if (_titleArray && _titleArray.count >0) {
            NSArray *porpertyArr = dic[@"pinfo"][@"porperty"];
            [porpertyArray addObjectsFromArray:porpertyArr];
            
            NSLog(@"porpertyArr===%@",porpertyArr);
            for (NSDictionary *tempdic in porpertyArr) {
                NSLog(@"tempdic==%@",tempdic);
                
                NSArray *setmealArr = tempdic[@"setmeal"];
                NSLog(@"setmealArr==%@",setmealArr);
                NSDictionary *guigeDic1 = setmealArr[0];
                NSDictionary *guigeDic2 = setmealArr[1];
                NSString *guigestr1 = guigeDic1[@"name"];
                NSString *guigestr2 = guigeDic2[@"name"];
               
                [huoyuanArray addObject:guigestr1];
                [jieduanArray addObject:guigestr2];
                NSLog(@"huoyuanArray===%@,jieduanArray===%@",huoyuanArray,jieduanArray);
            }
            
            [_tableView reloadData];
        }else{
            self.guigeH.constant = 0;
//            _titleArray = @[@"货源",@"阶段"];
//            [_tableView reloadData];
        }
        
        NSArray *promotionArr = dic[@"promotion"];
        NSLog(@"promotionArr===%@",promotionArr);
        for (NSDictionary *promotionDic in promotionArr) {
            
            NSString *nameStr = promotionDic[@"name"];
            [promotionArray addObject:nameStr];
        }
        NSLog(@"promotionArray===%@",promotionArray);
        //①②③④⑤
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
        }
        
        NSString *count = dic[@"comment_score"];
        NSLog(@"count===%@",count);
        UIImage *image1 = [UIImage imageNamed:@"xin2"];
        
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
            NSLog(@"return dic %@",dic);
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
            float  originprice= [dic[@"pinfo"][@"price"] floatValue];
            
            float pricef = [dic[@"pinfo"][@"market_price"] floatValue];
            NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
            self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
            
            NSAttributedString *attrStr =
            [[NSAttributedString alloc]initWithString:pricestr
                                           attributes:
             @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
               NSForegroundColorAttributeName:[UIColor grayColor],
               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
               NSStrikethroughColorAttributeName:[UIColor grayColor]}];
            self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
            
            
            
            self.shuliangStepper.paramDic = dic;
            
            [self.shuliangStepper setTextValue:1];
            UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
            UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
            
            NSString *amount = dic[@"pinfo"][@"amount"];
            NSString *safe_amount = dic[@"pinfo"][@"safe_amount"];
            NSString *sell_amount = dic[@"pinfo"][@"sell_amount"];
            
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
            }
            
            NSLog(@"%@",dic);
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
                
                float shuiliv = [dic[@"pinfo"][@"tax"] floatValue];
                float pricef = [dic[@"pinfo"][@"market_price"] floatValue];
                float shuifei = (shuiliv * pricef)/100;
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


- (void)selectedTag:(NSString *)tagName{
    
    NSLog(@"点击了====%@",tagName);
    NSLog(@"array====%@",porpertyArray);
    
    NSString *price;
    NSString *market_price;
    NSString *stock;
    NSString *safe_stock;
    
    for (NSDictionary *searchDic in porpertyArray) {
        
        NSArray *setmealArr = searchDic[@"setmeal"];
        NSDictionary *guigeDic1 = setmealArr[0];
        NSDictionary *guigeDic2 = setmealArr[1];
        NSString *guigestr1 = guigeDic1[@"name"];
        NSString *guigestr2 = guigeDic2[@"name"];
        NSMutableArray *guige = [[NSMutableArray alloc] init];
        [guige addObject:guigestr1];
        [guige addObject:guigestr2];
        
        NSLog(@"guige===%@",guige);
        
        for (NSString *searchStr in guige) {
            if ([searchStr isEqualToString:tagName]) {
                Searchdic = searchDic;
                price = searchDic[@"price"];
                market_price = searchDic[@"market_price"];
                stock = searchDic[@"stock"];
                safe_stock = searchDic[@"safe_stock"];
                
                }
            }
        
        
    }
    
    NSLog(@"%@  %@  %@  %@",price,market_price,stock,safe_stock);
    
    float pricef = price.floatValue;
    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:market_price
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
       NSForegroundColorAttributeName:[UIColor grayColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
    
    
    [self.shuliangStepper setTextValue:1];
    UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
    UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
    
    
    if (stock.floatValue >= safe_stock.floatValue) {
        self.kuncuntisLabel.text = @"库存充足";
    }else if(stock.floatValue < safe_stock.floatValue){
        
        self.kuncuntisLabel.text = [NSString stringWithFormat:@"%@",stock];
    }
    
    if (stock.floatValue == 0) {
        [self.shuliangStepper setTextValue:0];
        leftbtn.enabled=NO;
        rightbtn.enabled = NO;
        self.kuncuntisLabel.text = @"售罄";
    }
    

    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _pingmuH.constant = MAIN_SCREEN_HEIGHT - 64 - 45;
    _pingmuW.constant = MAIN_SCREEN_WIDTH;
    
//    //根据接口换地址
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]];
//    [_webView loadRequest:request];
    //_titleArray = @[@"货  源:",@"阶  段:"];

}

- (void)guessYLike {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=getcnxh&spsl=6",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject)
        {
            [_recommendArray removeAllObjects];
            NSArray *arr = (NSArray *)responseObject;
            if (arr && arr.count>0) {
                [_recommendArray addObjectsFromArray:arr];
            }
        }
        NSInteger row = (((_recommendArray.count / 3) >= 1 ? (_recommendArray.count / 3) + ((_recommendArray.count % 3 == 0)? 0 : 1) : 1));
        
//        CGRect rect = [UIScreen mainScreen].bounds;
        
        if (_recommendArray.count != 0) {
            _likeH.constant = 157*row;
//            _likeH.constant = (row + 1) * 10 + row *((MAIN_SCREEN_WIDTH - 5 * 10)/3/(rect.size.width/3)*157);
        }else{
            _likeH.constant = 0;
        }
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"猜你喜欢 请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
    NSLog(@"pDic===5555 %@",pDic);
    NSLog(@"Searchdic===6666%@",Searchdic);
        
    NSString *pid = pDic[@"pinfo"][@"id"];
    NSString *sid ;
    NSString *sku;
    if (_titleArray && _titleArray.count ==0) {
        sid = @"0";
        sku = pDic[@"pinfo"][@"code"];
        
    }else{
        sid = Searchdic[@"id"];
        sku= Searchdic[@"sku"];
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=add_cart&test_phone=13771961207",@"http://bbctest.matrojp.com"];
    NSDictionary *params = @{@"id":pid,@"nums":[NSNumber numberWithInteger:_shuliangStepper.value],@"sid":sid,@"sku":sku};
    
    
    [[HFSServiceClient sharedJSONClientNOT]POST:urlStr parameters:params constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *result = (NSDictionary *)responseObject;
         NSString *code = result[@"code"];
         if ([code isEqual:@0]) {
             [_hud show:YES];
             _hud.mode = MBProgressHUDModeText;
             _hud.labelText = @"加入购物车成功";
             [_hud hide:YES afterDelay:2];
         }
         NSLog(@"请求成功 result====%@",result);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败 error===%@",error);
         [_hud show:YES];
         _hud.mode = MBProgressHUDModeText;
         _hud.labelText = @"加入购物车失败";
         [_hud hide:YES afterDelay:2];
     }];
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
    
    /*
    if (userid) {
        NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/products.ashx?op=addcart&jmsp_id=%@&spsl=%ld&userid=%@",SERVICE_GETBASE_URL,spid,(unsigned long)_shuliangStepper.value, userid];
        
        [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"加入购物袋成功";
            [_hud hide:YES afterDelay:1];
            NSDictionary *dic = (NSDictionary *)responseObject;
                    NSLog(@"%@",dic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];
        
        
        if (!sender) {
            [self getAppDelegate].tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
   */
   
}

#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MLLoginViewController *vc = [[MLLoginViewController alloc] init];
     vc.isLogin = YES;
    YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:^{
        
    }];
}
#pragma mark- 分享按钮
-(void)shareButtonAction{
    
    if (!self.shareDic) {
        return;
    }
    NSLog(@"self.paramDic===%@",self.paramDic);
    
    MLShareGoodsViewController *vc = [[MLShareGoodsViewController alloc]init];
    vc.paramDic = self.paramDic;
    
    if (self.imageScrollView.subviews.count>0) {
         UIImageView *imgView = [self.imageScrollView.subviews firstObject];
        vc.qzoneImg = imgView.image;
    }
   
    __weak typeof(self) weakself = self;
    vc.erweimaBlock = ^(){
        MLGoodsSharePhotoViewController *vc = [[MLGoodsSharePhotoViewController alloc]init];
        vc.goodsDetail = weakself.shareDic;
        vc.paramDic = weakself.paramDic;
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
        [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:[UIImage imageNamed:@"imageloading"]];
        NSLog(@"imageview == %@",imageview.sd_imageURL);
        
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        //[imageview addGestureRecognizer:singleTap];
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
    
//    if (scrollView == _dataWebView.scrollView) {
//        if (scrollView.contentOffset.y > _dataWebView.scrollView.frame.size.height) {
//            _backToTopView.hidden = NO;
//        } else {
//            _backToTopView.hidden = YES;
//        }
//    }
}

- (IBAction)bagButtonAction:(id)sender {
    [self getAppDelegate].tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- 购买须知
- (IBAction)xuzhiAction:(id)sender {
    
    MLHelpCenterDetailController *vc = [[MLHelpCenterDetailController alloc]init];
    vc.webCode = @"0304010404";
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
//    _infoBgviewHConstraint.constant = 30;
}



#pragma mark- UICollectionViewDataSource And UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _recommendArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RecommendCollectionViewCell" ;
    
    UINib *nib = [UINib nibWithNibName:@"RecommendCollectionViewCell"bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    
    RecommendCollectionViewCell * cell = (RecommendCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *paramdic = [_recommendArray objectAtIndex:indexPath.row];
    cell.productNameLabel.text = paramdic[@"SPNAME"];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:paramdic[@"IMGURL"]] placeholderImage:[UIImage imageNamed:@"imageloading"]];
    NSString *priceStr = paramdic[@"XJ"];
    NSString *realStr = paramdic[@"LSDJ"];
    CGFloat xj = [priceStr floatValue];
    CGFloat lsdj = [realStr floatValue];
    
    NSString   *newpriceStr = [NSString stringWithFormat:@"<font name = \"STHeitiSC-Light\" size = \"13\"><color value = \"#856D47\">￥%.2f </></><font name = \"STHeitiSC-Light\" size = \"13\"><strike  word=\"true\"><color value = \"#505050\">￥%.2f</></></>",xj,lsdj];
    cell.productPriceLabel.attributedText = [newpriceStr createAttributedString];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MAIN_SCREEN_WIDTH - 5* 10)/3, 150);
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
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLGoodsDetailsTableViewCell" ;
    MLGoodsDetailsTableViewCell *cell = (MLGoodsDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.infoTitleLabel.text = [ NSString stringWithFormat:@"%@:", _titleArray[indexPath.row]];
    
    if (indexPath.row == 0) {
        
        huoyuanList = [[DWTagList alloc]initWithFrame:CGRectMake(60, 5, MAIN_SCREEN_WIDTH - 60, 30)];
        huoyuanList.tagDelegate = self;
        //huoyuanList = [self styleTagList:huoyuanList];
        huoyuanList.horizontalPadding = 10.0f;
        huoyuanList.verticalPadding = 6.0f;
        [huoyuanList setTag:huoyuanArray];
        [cell.tagView addSubview:huoyuanList];
        [self.view layoutIfNeeded];
        huoyuanList.frame = CGRectMake(0, 5, cell.tagView.bounds.size.width, cell.tagView.bounds.size.height - 10);
        huoyuanList.alwaysBounceVertical = NO;
        huoyuanList.alwaysBounceHorizontal = NO;
    }else{
    
        jieduanList = [[DWTagList alloc]initWithFrame:CGRectMake(60, 5, MAIN_SCREEN_WIDTH - 60, 30)];
        jieduanList.tagDelegate = self;
        jieduanList.horizontalPadding = 10.0f;
        jieduanList.verticalPadding = 6.0f;
        //jieduanList = [self styleTagList:jieduanList];
        [jieduanList setTag:jieduanArray];
        [cell.tagView addSubview:jieduanList];
        [self.view layoutIfNeeded];
        jieduanList.frame = CGRectMake(0, 5, cell.tagView.bounds.size.width, cell.tagView.bounds.size.height - 10);
        jieduanList.alwaysBounceVertical = NO;
        jieduanList.alwaysBounceHorizontal = NO;
    }
    
    
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}




#pragma Mark 收藏
- (IBAction)shouCangClick:(id)sender {
  /*
    http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
   do = add 【操作码】
  
   pid= 13911 【商品id】
   
   uname = ml_13771961207【会员名】
   
   //模拟用的
   &test_phone=用户电话号码
  */
    
    NSLog(@"pDic===%@",pDic);
    NSString *pid = pDic[@"pinfo"][@"id"];
    NSString *uname = pDic[@"pinfo"][@"user"];
    if (userid) {
        if (!self.shoucangButton.selected) {
        
        self.shoucangButton.selected = YES;
            
        [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
        [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
  
        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product&test_phone=13771961207",@"http://bbctest.matrojp.com"];
        NSDictionary *params = @{@"do":@"add",@"pid":pid,@"uname":uname};
    
    
      [[HFSServiceClient sharedJSONClientNOT]POST:urlStr parameters:params constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
       } success:^(AFHTTPRequestOperation *operation, id responseObject){
           
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *share_add = result[@"data"][@"share_add"];
        if (share_add) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"收藏成功";
            [_hud hide:YES afterDelay:2];
        }
        NSLog(@"请求成功 result====%@",result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        
        }];
    }else{
        self.shoucangButton.selected = NO;
        [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
        [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
        [self deleteClick:pid];
        
        return;
        }
    }else{
        [MBProgressHUD showMessag:@"请先登录" toView:self.view];
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
    if (userid) {
        if (!self.shoucangButton.selected) {
 
            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",@"http://bbctest.matrojp.com"];
            NSDictionary *params = @{@"do":@"del",@"id":sender};
            self.shoucangButton.selected = NO;
            [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
            [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
            
            [[HFSServiceClient sharedJSONClientNOT]POST:urlStr parameters:params constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSDictionary *result = (NSDictionary *)responseObject;
                 NSString *share_add = result[@"data"][@"ads_del"];
                 if (share_add) {
                     [_hud show:YES];
                     _hud.mode = MBProgressHUDModeText;
                     _hud.labelText = @"取消收藏成功";
                     [_hud hide:YES afterDelay:2];
                 }else{
                     
                 }
                 NSLog(@"请求成功 result====%@",result);
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"请求失败 error===%@",error);
                 
             }];
        }else{
            self.shoucangButton.selected = NO;
            [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
            [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
            
            return;
        }
    }else{
        [MBProgressHUD showMessag:@"请先登录" toView:self.view];
        return;
    }

}

@end



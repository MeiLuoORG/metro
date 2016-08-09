//
//  SecondsViewController.m
//  Matro
//
//  Created by lang on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "SecondsViewController.h"
#import "MLFristTableViewCell.h"
#import "MLFristCollectionViewCell.h"
#import "MLAdTableViewCell.h"
#import "MLSecondTableViewCell.h"
#import "MLThirdTableViewCell.h"
#import "MLYourlikeCollectionViewCell.h"
#import "MLSecondCollectionViewCell.h"
#import "MLYourlikeTableViewCell.h"
#import "UIColor+HeinQi.h"
#import "MJRefresh.h"

#define FristCCELL_IDENTIFIER @"MLFristCollectionViewCell"
#define SecondCCELL_IDENTIFIER @"MLSecondCollectionViewCell"
#define YourlikeCCELL_IDENTIFIER @"MLYourlikeCollectionViewCell"

#define CollectionViewCellMargin 5.0f//间隔5

@interface SecondsViewController (){
    
    CGFloat _index_0_height;
    CGFloat _index_1_height;
    CGFloat _index_2_height;
    CGFloat _index_3_height;
    CGFloat _index_4_height;
    CGFloat _index_5_height;
    CGFloat _index_6_height;
    CGFloat _index_7_height;
    BOOL ishotSP;
    NSMutableArray *_imageArray;//滚动图数组
    NSArray *adimageArr;
    NSMutableArray *hotspArr;//热门商品
    NSMutableArray *hotbrandArr;//热门品牌
    NSMutableArray *newgoodsee1;//广告1
    NSMutableArray *newgoodsee2;//广告2
    NSMutableArray *newgoodsee3;//广告3
    NSMutableArray *beutytitleArr;//第二类标题
    NSMutableArray *beutyadvertiseArr;//第二类标题下广告
    NSMutableArray *watchtitleArr;//第三类标题
    NSMutableArray *havewatchArr;//第三类标题下广告
    NSMutableArray *goodtitleArr;//猜你喜欢标题
    NSMutableArray *beutyArr;//第二类下面的商品
    NSMutableArray *watchArr;//第三类下面的商品
    NSMutableArray *productArr;//猜你喜欢数据
    
  
}
@property (strong,nonatomic)UIScrollView *imageScrollView;
@property (strong,nonatomic)UIPageControl *pagecontrol;
@property (strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)UIButton *backBtn ;//置顶按钮


@end

@implementation SecondsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ishotSP = YES;
    _index_0_height = 464.0f/750.0f*SIZE_WIDTH;
    
    _index_1_height = 460.0f/750.0f*SIZE_WIDTH+5;
    
    _index_2_height = 300.0f/750.0f*SIZE_WIDTH+5;
    
    _index_3_height = 300.0f/750.0f*SIZE_WIDTH+5;
    
    _index_4_height = 300.0f/750.0f*SIZE_WIDTH+5;
    
   // _index_5_height = 740.0/750.0f*SIZE_WIDTH;
    
   // _index_6_height = 740.0/750.0f*SIZE_WIDTH+60.0f;
    
   // _index_7_height = (468.0/750.0*SIZE_WIDTH)*5 + 100;
    hotspArr = [NSMutableArray array];
    hotbrandArr = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    newgoodsee1 = [NSMutableArray array];
    newgoodsee2 = [NSMutableArray array];
    newgoodsee3 = [NSMutableArray array];
    beutytitleArr = [NSMutableArray array];
    beutyadvertiseArr = [NSMutableArray array];
    watchtitleArr = [NSMutableArray array];
    havewatchArr = [NSMutableArray array];
    goodtitleArr = [NSMutableArray array];
    beutyArr = [NSMutableArray array];
    watchArr = [NSMutableArray array];
    productArr = [NSMutableArray array];

    [self createTableviewML];
//    [self loadData];
//    [self loadYourlikeData];
    [self addTimer];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40,self.view.frame.size.height-45-49-22, 25, 25)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"backTop.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    self.backBtn.hidden = YES;
    
}

-(void)backTopButtonAction:(UIButton*)sender{

    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
    [self loadYourlikeData];
}

//获取全球购数据
-(void)loadData{

    NSString *urlStr;
    NSString *mstr;
    if (self.indexType == 1) {
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=foreginbuy&method=display&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
        mstr = @"foreginbuy";
    }else if (self.indexType == 2){
    
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=mlgoods&method=display&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
        mstr = @"mlgoods";
    }else if (self.indexType == 3){
        
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=yttd&method=display&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
        mstr = @"yttd";
    }

    [MLHttpManager get:urlStr params:nil m:@"product" s:mstr success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqual:@0]) {
            
            if ([responseObject[@"data"][@"hotcategory"] isKindOfClass:[NSArray class]]) {
                
                hotspArr = responseObject[@"data"][@"hotcategory"];
            }
            if ([responseObject[@"data"][@"hotbrand"] isKindOfClass:[NSArray class]]) {
                
                hotbrandArr = responseObject[@"data"][@"hotbrand"];
            }
            
            if ([responseObject[@"data"][@"advertise"] isKindOfClass:[NSArray class]]) {
                
                adimageArr = responseObject[@"data"][@"advertise"];
            }
            if ([responseObject[@"data"][@"newgoodsee1"] isKindOfClass:[NSArray class]]) {
                
                newgoodsee1 = responseObject[@"data"][@"newgoodsee1"];
            }
            
            if ([responseObject[@"data"][@"newgoodsee2"] isKindOfClass:[NSArray class]]) {
                
                newgoodsee2 = responseObject[@"data"][@"newgoodsee2"];
            }
            
            if ([responseObject[@"data"][@"newgoodsee3"] isKindOfClass:[NSArray class]]) {
                
                newgoodsee3 = responseObject[@"data"][@"newgoodsee3"];
            }
            
            if ([responseObject[@"data"][@"beutytitle"] isKindOfClass:[NSArray class]]) {
                
                beutytitleArr = responseObject[@"data"][@"beutytitle"];
            }
            if ([responseObject[@"data"][@"beutyadvertise"] isKindOfClass:[NSArray class]]) {
                
                beutyadvertiseArr = responseObject[@"data"][@"beutyadvertise"];
            }
            if ([responseObject[@"data"][@"beuty"] isKindOfClass:[NSArray class]]) {
                
                beutyArr = responseObject[@"data"][@"beuty"];
            }
            if ([responseObject[@"data"][@"watchtitle"] isKindOfClass:[NSArray class]]) {
                
                watchtitleArr = responseObject[@"data"][@"watchtitle"];
            }
            if ([responseObject[@"data"][@"havewatch"] isKindOfClass:[NSArray class]]) {
                
                havewatchArr = responseObject[@"data"][@"havewatch"];
            }
            if ([responseObject[@"data"][@"watch"] isKindOfClass:[NSArray class]]) {
                
                watchArr = responseObject[@"data"][@"watch"];
            }
            
            goodtitleArr = responseObject[@"data"][@"goodtitle"];
            
            if (adimageArr && adimageArr.count > 0) {
               
                for (int i =0 ; i< adimageArr.count; i++) {
                    NSDictionary * adimageDic = adimageArr[i];
                    [_imageArray addObject:adimageDic];
                }
            }
            
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error){
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    
}
//获取猜你喜欢数据
-(void)loadYourlikeData{

    NSString *urlStr;
    NSString *mstr;
    if (self.indexType == 1) {
        
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=foreginbuy&method=good&pageindex=1&pagesize=10&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
        mstr = @"foreginbuy";
        
    }else if (self.indexType == 2){
        
        urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=mlgoods&method=good&pageindex=1&pagesize=8&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
        mstr = @"mlgoods";
        
    }else if (self.indexType == 3){
        
       urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=yttd&method=good&pageindex=1&pagesize=8&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
        mstr = @"yttd";
    }
    
    [MLHttpManager get:urlStr params:nil m:@"product" s:mstr success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        
        if ([[responseObject objectForKey:@"code"] isEqual:@0]) {
            
            if (responseObject) {
                NSArray *arr = (NSArray*)responseObject[@"data"][@"good"];
                if (arr && arr.count > 0) {
                    
                    [productArr addObjectsFromArray:arr];
                }
            }
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error){
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
}

- (void)createTableviewML{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-49.0-60) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableview.footer = [self loadMoreDataFooterWith:self.tableview];
    [self.view addSubview:self.tableview];
    
}

//-(MJRefreshAutoNormalFooter *)loadMoreDataFooterWith:(UIScrollView *)scrollView {
//    MJRefreshAutoNormalFooter *loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self loadYourlikeData];
//        [scrollView.footer endRefreshing];
//    }];
//
//    return loadMoreFooter;
//}

#pragma mark TableViewDelegate代理方法Start
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    switch (indexPath.row) {
        case 0:{
            height = _index_0_height;
            
        }
            break;
        case 1:{
          //  height = _index_1_height;
            height = 294;
           
            
        }
            break;
        case 2:{
            height = _index_2_height;
            
        }
            break;
        case 3:{
            height = _index_3_height;
            
        }
            break;
        case 4:{
            height = _index_4_height;
            
        }
            break;
        case 5:{
            height = _index_5_height+40;
    
        }
            break;
        case 6:{
            height = _index_6_height+40;
        }
            break;
        case 7:{
            height = _index_7_height;
            
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"tableviewCellID";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:{
          
            UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
            _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
            _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake((MAIN_SCREEN_WIDTH-80)/2, _index_0_height-20, 80, 20)];
            
            [headview addSubview:_imageScrollView];
            [headview addSubview: _pagecontrol];

            if (![_imageArray isKindOfClass:[NSNull class]]) {//防崩溃
                [self imageUIInit];
            }
            
            
            [cell addSubview:headview];
            
        }
            break;
            
        case 1:{
            static NSString *FristCellIdentifier = @"MLFristTableViewCell" ;
            
            MLFristTableViewCell *FristTableViewCell = [tableView dequeueReusableCellWithIdentifier:FristCellIdentifier];
           
            if (FristTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: FristCellIdentifier owner:self options:nil];
                FristTableViewCell = [array objectAtIndex:0];
            }
            
            if (ishotSP == YES) {
                FristTableViewCell.hotppLab.textColor = [UIColor grayColor];
                FristTableViewCell.hotppView.hidden = YES;
            }else{
                FristTableViewCell.hotspLab.textColor = [UIColor grayColor];
                FristTableViewCell.hotspView.hidden = YES;
                
            }
            
            FristTableViewCell.hotspClick = ^(){
                
                ishotSP = YES;
                FristTableViewCell.hotppLab.textColor = [UIColor grayColor];
                FristTableViewCell.hotppView.hidden = YES;
                FristTableViewCell.hotspLab.textColor = [UIColor colorWithHexString:@"260E00"];
                FristTableViewCell.hotspView.hidden = NO;
                [self.tableview reloadData];
            };
            
            FristTableViewCell.hotppClick = ^(){
               
                ishotSP = NO;
                FristTableViewCell.hotppLab.textColor = [UIColor colorWithHexString:@"260E00"];
                FristTableViewCell.hotppView.hidden = NO;
                FristTableViewCell.hotspLab.textColor = [UIColor grayColor];
                FristTableViewCell.hotspView.hidden = YES;
                [self.tableview reloadData];
            };
            
            FristTableViewCell.firstCollectionView.delegate = self;
            FristTableViewCell.firstCollectionView.dataSource = self;
            FristTableViewCell.firstCollectionView.tag = 1;
            [FristTableViewCell.firstCollectionView registerNib:[UINib  nibWithNibName:@"MLFristCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:FristCCELL_IDENTIFIER];
            FristTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return FristTableViewCell;
        }
            break;
            
        case 2:{
            
            static NSString *ADCellIdentifier = @"MLAdTableViewCell";
            MLAdTableViewCell *AdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ADCellIdentifier];
            if (AdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ADCellIdentifier owner:self options:nil];
                AdTableViewCell = [array objectAtIndex:0];
            }
            if (newgoodsee1 && newgoodsee1.count > 0) {
                NSString *imageurl;
                for (NSDictionary *adDic in newgoodsee1) {
                    imageurl = adDic[@"imgurl"];
                }
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [AdTableViewCell.adImageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    AdTableViewCell.adImageView.image = [UIImage imageNamed:@"icon_default"];
                }
            }
            AdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return AdTableViewCell;
            
            
        }
            break;
            
        case 3:{
            
            static NSString *ADCellIdentifier = @"MLAdTableViewCell";
            MLAdTableViewCell *AdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ADCellIdentifier];
            if (AdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ADCellIdentifier owner:self options:nil];
                AdTableViewCell = [array objectAtIndex:0];
            }
            if (newgoodsee2 && newgoodsee2.count > 0) {
                NSString *imageurl;
                for (NSDictionary *adDic in newgoodsee2) {
                    imageurl = adDic[@"imgurl"];
                }
                
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [AdTableViewCell.adImageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    AdTableViewCell.adImageView.image = [UIImage imageNamed:@"icon_default"];
                }
            }
            AdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return AdTableViewCell;
        }
            break;
            
        case 4:{
            
            static NSString *ADCellIdentifier = @"MLAdTableViewCell";
            MLAdTableViewCell *AdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ADCellIdentifier];
            if (AdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ADCellIdentifier owner:self options:nil];
                AdTableViewCell = [array objectAtIndex:0];
            }
            if (newgoodsee3 && newgoodsee3.count > 0) {
                NSString *imageurl;
                for (NSDictionary *adDic in newgoodsee3) {
                    imageurl = adDic[@"imgurl"];
                }
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [AdTableViewCell.adImageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    AdTableViewCell.adImageView.image = [UIImage imageNamed:@"icon_default"];
                }
            }
            AdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return AdTableViewCell;
        }
            
            break;
        case 5:{

            static NSString *SecondCellIdentifier = @"MLSecondTableViewCell";
            MLSecondTableViewCell *SecondTableViewCell = [tableView dequeueReusableCellWithIdentifier:SecondCellIdentifier];
            if (SecondTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: SecondCellIdentifier owner:self options:nil];
                SecondTableViewCell = [array objectAtIndex:0];
            }
            if (beutytitleArr && beutytitleArr.count > 0) {
                
                NSString *imageurl = beutytitleArr[0][@"imgurl"]?:@"";
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [SecondTableViewCell.secondHeadimage sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    SecondTableViewCell.secondHeadimage.image = [UIImage imageNamed:@"icon_default"];
                }
                
            }
            
            if (beutyadvertiseArr && beutyadvertiseArr.count > 0) {
               
                NSString *imageurl0 = beutyadvertiseArr[0][@"imgurl"]?:@"";
                NSString *imageurl1 = beutyadvertiseArr[1][@"imgurl"]?:@"";
                
                if (![imageurl0 isKindOfClass:[NSNull class]]) {
                    [SecondTableViewCell.secondImage1 sd_setImageWithURL:[NSURL URLWithString:imageurl0] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    SecondTableViewCell.secondImage1.image = [UIImage imageNamed:@"icon_default"];
                }
                if (![imageurl1 isKindOfClass:[NSNull class]]) {
                    [SecondTableViewCell.secondImage2 sd_setImageWithURL:[NSURL URLWithString:imageurl1] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    SecondTableViewCell.secondImage2.image = [UIImage imageNamed:@"icon_default"];
                }
    
            }
            SecondTableViewCell.leftClickblock = ^(){
                
                if (beutyadvertiseArr && beutyadvertiseArr.count > 0) {
                    
                 [self pushToType:beutyadvertiseArr[0][@"ggtype"]?:@"" withUi:beutyadvertiseArr[0][@"ggv"]?:@""];
                    
                }
                
            };
            SecondTableViewCell.rightClickblock = ^(){
                
                if (beutyadvertiseArr && beutyadvertiseArr.count > 0) {
                    
                    [self pushToType:beutyadvertiseArr[1][@"ggtype"]?:@"" withUi:beutyadvertiseArr[1][@"ggv"]?:@""];
                  
                }
            };
            SecondTableViewCell.secondCollectionView.delegate = self;
            SecondTableViewCell.secondCollectionView.dataSource = self;
            SecondTableViewCell.secondCollectionView.tag = 5;
            [SecondTableViewCell.secondCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            
            if (beutyArr && beutyArr.count > 0 ) {
                
                _index_5_height = 185.f/375.f*MAIN_SCREEN_WIDTH +(((MAIN_SCREEN_WIDTH) - (CollectionViewCellMargin*10))/4)*1.72 +40;
            }
            
            SecondTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return SecondTableViewCell;
        }
            
            break;
        case 6:{
 
            static NSString *ThirdCellIdentifier = @"MLThirdTableViewCell";
            MLThirdTableViewCell *ThirdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ThirdCellIdentifier];
            if (ThirdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ThirdCellIdentifier owner:self options:nil];
                ThirdTableViewCell = [array objectAtIndex:0];
            }
            if (watchtitleArr && watchtitleArr.count > 0) {
                
                NSString *imageurl = watchtitleArr[0][@"imgurl"]?:@"";
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [ThirdTableViewCell.thirdHeadImage sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    ThirdTableViewCell.thirdHeadImage.image = [UIImage imageNamed:@"icon_default"];
                }
                
            }
            if (havewatchArr && havewatchArr.count >0) {
                
                NSString *imageurl = havewatchArr[0][@"imgurl"]?:@"";
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [ThirdTableViewCell.thirdImage  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    ThirdTableViewCell.thirdImage.image = [UIImage imageNamed:@"icon_default"];
                }
            }
            
            ThirdTableViewCell.imageClickBlock = ^(){
                
                if (havewatchArr && havewatchArr.count > 0) {
                    
                    [self pushToType:havewatchArr[0][@"ggtype"]?:@"" withUi:havewatchArr[0][@"ggv"]?:@""];
                    
                }
                
            };
            
            ThirdTableViewCell.thirdCollectionView.delegate = self;
            ThirdTableViewCell.thirdCollectionView.dataSource = self;
            ThirdTableViewCell.thirdCollectionView.tag = 6;
            [ThirdTableViewCell.thirdCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            if (watchArr && watchArr.count > 0) {
                _index_6_height = 8.f/15.f*MAIN_SCREEN_WIDTH+(((MAIN_SCREEN_WIDTH) - (CollectionViewCellMargin*10))/4)*1.72 + 40;
            }
            
            ThirdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return ThirdTableViewCell;
        }
            
            break;
        case 7:{
            static NSString *YourlikeCellIdentifier = @"MLYourlikeTableViewCell";
            MLYourlikeTableViewCell *YourlikeTableViewCell = [tableView dequeueReusableCellWithIdentifier:YourlikeCellIdentifier];
            if (YourlikeTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: YourlikeCellIdentifier owner:self options:nil];
                YourlikeTableViewCell = [array objectAtIndex:0];
            }
            if (![goodtitleArr isKindOfClass:[NSString class]]) {
                if (goodtitleArr && goodtitleArr.count > 0) {
                    
                    NSString *imageurl = goodtitleArr[0][@"imgurl"]?:@"";
                    if (![imageurl isKindOfClass:[NSNull class]]) {
                        [YourlikeTableViewCell.likeHeadImage  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                    }else{
                        
                        YourlikeTableViewCell.likeHeadImage.image = [UIImage imageNamed:@"icon_default"];
                    }
                    
                }
            }else{
            
                YourlikeTableViewCell.likeHeadImage.image = [UIImage imageNamed:@"world_title"];
            }
            
            
            YourlikeTableViewCell.LikeCollectionView.delegate = self;
            YourlikeTableViewCell.LikeCollectionView.dataSource = self;
            YourlikeTableViewCell.LikeCollectionView.tag = 7;
            
            [YourlikeTableViewCell.LikeCollectionView registerNib:[UINib  nibWithNibName:@"MLYourlikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER];
            YourlikeTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            
            NSLog(@"----%lu",(unsigned long)productArr.count);
            float cellW = (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2;
            
            if ( productArr && productArr.count >0) {
                
                _index_7_height = cellW*1.35*(productArr.count/2)+(8/75)*MAIN_SCREEN_WIDTH+(productArr.count/2)*5+30;

            }
            
            return YourlikeTableViewCell;
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (newgoodsee1 && newgoodsee1.count >0) {
            NSDictionary *tempdic = newgoodsee1[0];
            [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
        }
    }else if(indexPath.row == 3){
    
        if (newgoodsee2 && newgoodsee2.count >0) {
            NSDictionary *tempdic = newgoodsee2[0];
            [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
        }
    }else if(indexPath.row == 4){
    
        if (newgoodsee3 && newgoodsee3.count >0) {
            NSDictionary *tempdic = newgoodsee3[0];
            [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
        }
    }
    
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1) {
        if (ishotSP == YES) {
            if (hotspArr.count <= 6) {
                
                return hotspArr.count;
            }
            else{
                
                return 8;
            }
 
        }else{
            if (hotbrandArr.count <= 6) {
                
                return hotbrandArr.count;
                
            }else{
                
                return 8;
            }
        }
    }else if(collectionView.tag == 5){
        
        return beutyArr.count;
        
    }else if (collectionView.tag == 6){
    
        return watchArr.count;
        
    }else{
    
        return productArr.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        MLFristCollectionViewCell *cell = (MLFristCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FristCCELL_IDENTIFIER forIndexPath:indexPath];
        cell.firstImageView.layer.borderWidth = 1.f;
        cell.firstImageView.layer.borderColor = [UIColor colorWithHexString:@"F5F5F5"].CGColor;
        cell.firstImageView.layer.cornerRadius = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4)/2;
        cell.firstImageView.layer.masksToBounds = YES;
        if (ishotSP == YES) {
            
            if (hotspArr.count > 6) {
                if (indexPath.row < 7) {
                    
                    NSDictionary *tempDic = hotspArr[indexPath.row];
                    cell.firstNameLab.text = tempDic[@"mc"]?:@"";
                    NSString *imageurl = tempDic[@"imgurl"]?:@"";
                    if (![imageurl isKindOfClass:[NSNull class]]) {
                        [cell.firstImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                    }else{
                        
                        cell.firstImageView.image = [UIImage imageNamed:@"icon_default"];
                    }
                }
                
                if (indexPath.row == 7) {
                    cell.firstNameLab.text = @"更多";
                    cell.firstImageView.image = [UIImage imageNamed:@"more_goods"];
                }
            }else{
            
                NSDictionary *tempDic = hotspArr[indexPath.row];
                cell.firstNameLab.text = tempDic[@"mc"]?:@"";
                NSString *imageurl = tempDic[@"imgurl"]?:@"";
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [cell.firstImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    cell.firstImageView.image = [UIImage imageNamed:@"icon_default"];
                }
            }

        }else{

            if (hotbrandArr.count > 6) {
                if (indexPath.row <7) {
                    
                    NSDictionary *tempDic = hotbrandArr[indexPath.row];
                    cell.firstNameLab.text = tempDic[@"name"]?:@"";
                    NSString *imageurl = tempDic[@"imgurl"]?:@"";
                    if (![imageurl isKindOfClass:[NSNull class]]) {
                        [cell.firstImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                    }else{
                        
                        cell.firstImageView.image = [UIImage imageNamed:@"icon_default"];
                    }
                }
                if (indexPath.row == 7) {
                    cell.firstNameLab.text = @"更多";
                    cell.firstImageView.image = [UIImage imageNamed:@"more_goods"];
                }
            }else{
            
                NSDictionary *tempDic = hotbrandArr[indexPath.row];
                cell.firstNameLab.text = tempDic[@"name"]?:@"";
                NSString *imageurl = tempDic[@"imgurl"]?:@"";
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [cell.firstImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    cell.firstImageView.image = [UIImage imageNamed:@"icon_default"];
                }
            }
            

        }
        
        
        return cell;
    }else if(collectionView.tag == 7){
        
        MLYourlikeCollectionViewCell *cell = (MLYourlikeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER forIndexPath:indexPath];
        
        NSDictionary *tempDic = productArr[indexPath.row];
        if (![tempDic isKindOfClass:[NSNull class]]) {
            cell.likeNameLab.text = tempDic[@"pname"]?:@"";
            
            float  originprice= [tempDic[@"promotion_price"] floatValue];
            
            if ( ![tempDic[@"promotion_price"] isKindOfClass:[NSNull class]]) {
                if (originprice == 0.00) {
                    cell.cuxiaoPriceLabel.hidden = YES;
                    float price = [tempDic[@"price"] floatValue];
                    
                    cell.likePriceLab.text = [NSString  stringWithFormat:@"￥%.2f",price];
                }
                else{
                    cell.cuxiaoPriceLabel.hidden = NO;
                    float price = [tempDic[@"price"] floatValue];
                    
                    cell.likePriceLab.text = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSString *Pricestr = [NSString stringWithFormat:@"￥%.2f",price];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:Pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    cell.cuxiaoPriceLabel.attributedText=attrStr; //原价要划掉
                }
            }
            float amount = [tempDic[@"amount"] floatValue];
            if (amount < 1) {
                cell.shouqingLabel.hidden = NO;
            }else{
                cell.shouqingLabel.hidden = YES;
            }
            
            NSString *imageurl = tempDic[@"pic"]?:@"";
            if (![imageurl isKindOfClass:[NSNull class]]) {
                [cell.likeImage  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
            }else{
            
                cell.likeImage.image = [UIImage imageNamed:@"icon_default"];
            }
            

        }
        
        return cell;
        
    }else{

        MLSecondCollectionViewCell *cell = (MLSecondCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SecondCCELL_IDENTIFIER forIndexPath:indexPath];
        if (collectionView.tag == 5) {
            NSDictionary *tempDic = beutyArr[indexPath.row];
            cell.secondNameLab.text = tempDic[@"pname"]?:@"";
            float promotion_price = [tempDic[@"promotion_price"] floatValue];
            float price = [tempDic[@"price"] floatValue];
            if (![tempDic[@"promotion_price"] isKindOfClass:[NSNull class]]) {
                if (promotion_price == 0.00) {
                    
                    cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%.2f",price];
                    
                }else{
                    cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%.2f",promotion_price];
                }
            }
            
            NSString *imageurl = tempDic[@"pic"]?:@"";
            if (![imageurl isKindOfClass:[NSNull class]]) {
                [cell.secondImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
            }else{
                
                cell.secondImageView.image = [UIImage imageNamed:@"icon_default"];
            }
            
            
        }else if(collectionView.tag == 6){
        
            NSDictionary *tempDic = watchArr[indexPath.row];
            cell.secondNameLab.text = tempDic[@"pname"]?:@"";
            float promotion_price = [tempDic[@"promotion_price"] floatValue];
            float price = [tempDic[@"price"] floatValue];
            if (![tempDic[@"promotion_price"] isKindOfClass:[NSNull class]]) {
                if (promotion_price == 0.00) {
                    
                    cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%.2f",price];
                    
                }else{
                    cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%.2f",promotion_price];
                }
            }
            
            NSString *imageurl = tempDic[@"pic"]?:@"";
            if (![imageurl isKindOfClass:[NSNull class]]) {
                [cell.secondImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
            }else{
                
                cell.secondImageView.image = [UIImage imageNamed:@"icon_default"];
            }
        }
        return cell;
    }
    
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        if (ishotSP == YES) {
            if (indexPath.row == 7) {
                [self pushToType:@"3" withUi:@"all"];
            }else{
                NSDictionary *tempDic = hotspArr[indexPath.row];
                [self pushToType:@"3" withUi:tempDic[@"catid"]?:@""];
            }
   
        }else{
            if (indexPath.row == 7) {
                [self pushToType:@"2" withUi:@"all"];
            }else{
                NSDictionary *tempDic = hotbrandArr[indexPath.row];
                [self pushToType:@"2" withUi:tempDic[@"brand_id"]?:@""];
            }
   
        }
    }else if (collectionView.tag == 5){
    
        NSDictionary *tempDic = beutyArr[indexPath.row];
        [self pushToType:@"1" withUi:tempDic[@"id"]?:@""];
        
    }else if (collectionView.tag == 6){
        
        NSDictionary *tempDic = watchArr[indexPath.row];
        [self pushToType:@"1" withUi:tempDic[@"id"]?:@""];
        
    }else if(collectionView.tag == 7){
        
        NSDictionary *tempDic = productArr[indexPath.row];
        [self pushToType:@"1" withUi:tempDic[@"id"]?:@""];
        
    }

}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
        return CGSizeMake(width, 120);
    }else if (collectionView.tag == 7){
        CGFloat cellW = (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2;
        return CGSizeMake(cellW,cellW*1.35);
    }else{
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
        return CGSizeMake(width, width*1.72);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 1) {
         return UIEdgeInsetsMake(CollectionViewCellMargin, CollectionViewCellMargin, 0, CollectionViewCellMargin);
    }else if (collectionView.tag == 7){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, CollectionViewCellMargin*2, 0, CollectionViewCellMargin*2);
   // return UIEdgeInsetsMake(CollectionViewCellMargin*2, CollectionViewCellMargin*2, CollectionViewCellMargin, CollectionViewCellMargin*2);
}


- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 1) {
        return 0.f;
    }else if (collectionView.tag == 7){
    
        return 0.f;
    }
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 7) {
        return 0.f;
    }
    return 0;
}

#pragma mark- 图片相关
- (void)imageUIInit {
    
    CGFloat imageScrollViewWidth = MAIN_SCREEN_WIDTH;
    CGFloat imageScrollViewHeight = _imageScrollView.bounds.size.height;
    
    for(int i = 0; i<_imageArray.count; i++) {
        if ([_imageArray[i][@"imgurl"] isKindOfClass:[NSNull class]]) {
            continue;
        }
    }
    for (int i=0; i<_imageArray.count; i++) {
        
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        NSLog(@"imageview == %@",imageview.sd_imageURL);
        
        // imageview.contentMode = UIViewContentModeScaleAspectFit;
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
    
    _pagecontrol.tintColor = [UIColor whiteColor];
    _pagecontrol.currentPageIndicatorTintColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
    
    
}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
   
    if (adimageArr && adimageArr.count>0) {
        NSDictionary *tempdic = adimageArr[tap.view.tag];
        [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
    }
    
}

//开启定时器
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

//设置当前页 实现自动滚动
- (void)nextImage
{
    int page = (int)_pagecontrol.currentPage;
    
    if (page == _imageArray.count-1) {
        
        page = 0;
        
    }else{
        
        page++;
        
    }
    
    CGFloat x = page * _imageScrollView.frame.size.width;
    [_imageScrollView  setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
//关闭定时器
- (void)removeTimer
 {
    [self.timer invalidate];
}

#pragma mark ScrollView代理方法开始
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    if (scrollView == _imageScrollView) {
        CGFloat scrollviewW =  scrollView.frame.size.width;
        CGFloat x = scrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        _pagecontrol.currentPage = page;
    }
    else{
        if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondViewController:withContentOffest:)]) {
        [self.secondDelegate secondViewController:self withContentOffest:scrollView.contentOffset.y];

        }
        
        if (scrollView.contentOffset.y > 200.0f) {
            self.backBtn.hidden = NO;
        }
        else{
            self.backBtn.hidden = YES;
        }
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    [self removeTimer];
    
    if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondViewController:withBeginOffest:)]) {
        [self.secondDelegate secondViewController:self withBeginOffest:scrollView.contentOffset.y];
    }
    
}
//拖拽结束后开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
    
    
}

#pragma end mark 代理方法结束
- (void)pushToType:(NSString *)index withUi:(NSString *)sender{
    
    if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondViewController:JavaScriptActionFourButton:withUi:)]) {
        [self.secondDelegate secondViewController:self JavaScriptActionFourButton:index withUi:sender];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

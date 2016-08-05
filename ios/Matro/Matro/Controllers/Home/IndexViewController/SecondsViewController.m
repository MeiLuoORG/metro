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
    
    _index_5_height = 724.0/750.0f*SIZE_WIDTH+40.0f;
    
    _index_6_height = 724.0/750.0f*SIZE_WIDTH+40.0f;
    
    _index_7_height = (460.0/750.0*SIZE_WIDTH)*5;
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
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
    [self loadYourlikeData];

}

//获取全球购数据
-(void)loadData{
  //  http://bbctest.matrojp.com/api.php?m=product&s=foreginbuy&method=display
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=foreginbuy&method=display&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"product" s:@"foreginbuy" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqual:@0]) {
            
            hotspArr = responseObject[@"data"][@"hotcategory"];
            hotbrandArr = responseObject[@"data"][@"hotbrand"];
            adimageArr = responseObject[@"data"][@"advertise"];
            newgoodsee1 = responseObject[@"data"][@"newgoodsee1"];
            newgoodsee2 = responseObject[@"data"][@"newgoodsee2"];
            newgoodsee3 = responseObject[@"data"][@"newgoodsee3"];
            beutytitleArr = responseObject[@"data"][@"beutytitle"];
            beutyadvertiseArr = responseObject[@"data"][@"beutyadvertise"];
            beutyArr = responseObject[@"data"][@"beuty"];
            watchtitleArr = responseObject[@"data"][@"watchtitle"];
            havewatchArr = responseObject[@"data"][@"havewatch"];
            watchArr = responseObject[@"data"][@"watch"];
            goodtitleArr = responseObject[@"data"][@"goodtitle"];
            if (adimageArr && adimageArr.count > 0) {
                NSString *adimage;
                for (NSDictionary *adDic in adimageArr) {
                    adimage = adDic[@"imgurl"];
                    [_imageArray addObject:adimage];
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
    
//http://bbctest.matrojp.com/api.php?m=product&s=guess_like&method=get_guess_like&start=0&limit=20&catid=11080601,11080201&brandid=
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=guess_like&method=get_guess_like&start=0&limit=8&catid=&brandid=&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"product" s:@"guess_like" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        
        if ([[responseObject objectForKey:@"code"] isEqual:@0]) {
            
            if (responseObject) {
                NSArray *arr = (NSArray*)responseObject[@"data"][@"product"];
                NSLog(@"arr===%@",arr);
                if (arr && arr.count > 0) {
                    
                    [productArr addObjectsFromArray:arr];
                }
            }
            NSLog(@"-----%@",productArr);
            
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
//            height = _index_5_height;
            height = 370;
            
        }
            break;
        case 6:{
//            height = _index_6_height;
            height = 370;
            
        }
            break;
        case 7:{
            height = _index_7_height - 80;
            
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
          
            UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 232)];
            _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 232)];
            _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake((MAIN_SCREEN_WIDTH-80)/2, 212, 80, 20)];
            
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
                FristTableViewCell.hotppLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
                FristTableViewCell.hotppView.hidden = YES;
            }else{
                FristTableViewCell.hotspLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
                FristTableViewCell.hotspView.hidden = YES;
                
            }
            
            FristTableViewCell.hotspClick = ^(){
                
                ishotSP = YES;
                FristTableViewCell.hotppLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
                FristTableViewCell.hotppView.hidden = YES;
                FristTableViewCell.hotspLab.textColor = [UIColor colorWithHexString:@"260E00"];
                FristTableViewCell.hotspView.hidden = NO;
                [self.tableview reloadData];
            };
            
            FristTableViewCell.hotppClick = ^(){
               
                ishotSP = NO;
                FristTableViewCell.hotppLab.textColor = [UIColor colorWithHexString:@"260E00"];
                FristTableViewCell.hotppView.hidden = NO;
                FristTableViewCell.hotspLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
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
            if (goodtitleArr && goodtitleArr.count > 0) {
                
                NSString *imageurl = goodtitleArr[0][@"imgurl"]?:@"";
                if (![imageurl isKindOfClass:[NSNull class]]) {
                    [YourlikeTableViewCell.likeHeadImage  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
                }else{
                    
                    YourlikeTableViewCell.likeHeadImage.image = [UIImage imageNamed:@"icon_default"];
                }
  
            }
            
            YourlikeTableViewCell.LikeCollectionView.delegate = self;
            YourlikeTableViewCell.LikeCollectionView.dataSource = self;
            YourlikeTableViewCell.LikeCollectionView.tag = 7;
            [YourlikeTableViewCell.LikeCollectionView registerNib:[UINib  nibWithNibName:@"MLYourlikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER];
            YourlikeTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
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
            NSLog(@"111%@",tempdic);
            [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
        }
    }else if(indexPath.row == 3){
    
        if (newgoodsee2 && newgoodsee2.count >0) {
            NSDictionary *tempdic = newgoodsee2[0];
            NSLog(@"222%@",tempdic);
            [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
        }
    }else if(indexPath.row == 4){
    
        if (newgoodsee3 && newgoodsee3.count >0) {
            NSDictionary *tempdic = newgoodsee3[0];
            NSLog(@"333%@",tempdic);
            [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
        }
    }
    
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1) {
        if (ishotSP == YES) {
            if (hotspArr.count < 8) {
                return hotspArr.count;
            }
            return 8;
            
        }else{
            if (hotbrandArr.count < 8) {
                return hotbrandArr.count;
            }
            return 8;
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
        cell.firstImageView.layer.cornerRadius = 40.f;
        cell.firstImageView.layer.masksToBounds = YES;
        if (ishotSP == YES) {
            NSDictionary *tempDic = hotspArr[indexPath.row];
            cell.firstNameLab.text = tempDic[@"mc"]?:@"";
            NSString *imageurl = tempDic[@"imgurl"]?:@"";
            if (![imageurl isKindOfClass:[NSNull class]]) {
                [cell.firstImageView  sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage: [UIImage imageNamed:@"icon_default"]];
            }else{
                
                cell.firstImageView.image = [UIImage imageNamed:@"icon_default"];
            }
            if (hotspArr.count > 6) {
                if (indexPath.row == 7) {
                    cell.firstNameLab.text = @"更多";
                    cell.firstImageView.image = [UIImage imageNamed:@"more_goods"];
                }
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
            
            if (hotspArr.count > 6) {
                if (indexPath.row == 7) {
                    cell.firstNameLab.text = @"更多";
                    cell.firstImageView.image = [UIImage imageNamed:@"more_goods"];
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
        return CGSizeMake(cellW,cellW*1.4);
    }
    float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
    return CGSizeMake(width, 140);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 1) {
         return UIEdgeInsetsMake(CollectionViewCellMargin, CollectionViewCellMargin, 0, CollectionViewCellMargin);
    }else if (collectionView.tag == 7){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(CollectionViewCellMargin*2, CollectionViewCellMargin*2, CollectionViewCellMargin, CollectionViewCellMargin*2);
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
        if ([_imageArray[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
    }
    for (int i=0; i<_imageArray.count; i++) {
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
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
    
    _pagecontrol.tintColor = [UIColor redColor];
    _pagecontrol.currentPageIndicatorTintColor = [UIColor yellowColor];
}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    
    NSLog(@"%ld",tap.view.tag);
    if (adimageArr && adimageArr.count>0) {
        NSDictionary *tempdic = adimageArr[tap.view.tag];
        [self pushToType:tempdic[@"ggtype"]?:@"" withUi:tempdic[@"ggv"]?:@""];
    }
    
}

#pragma end mark 代理方法结束

#pragma mark ScrollView代理方法开始
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll6+++");
    
    if (scrollView == _imageScrollView) {
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        _pagecontrol.currentPage = i - 1;
    }
    
    
    if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondViewController:withContentOffest:)]) {
        [self.secondDelegate secondViewController:self withContentOffest:scrollView.contentOffset.y];

    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    
    if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondViewController:withBeginOffest:)]) {
        [self.secondDelegate secondViewController:self withBeginOffest:scrollView.contentOffset.y];
    }
    
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
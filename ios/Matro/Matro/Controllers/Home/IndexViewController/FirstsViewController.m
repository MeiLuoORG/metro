//
//  FirstsViewController.m
//  Matro
//
//  Created by lang on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "FirstsViewController.h"

@interface FirstsViewController (){

    CGFloat _index_0_height;
    CGFloat _index_1_height;
    CGFloat _index_2_height;
    CGFloat _index_3_height;
    CGFloat _index_4_height;
    CGFloat _index_5_height;
    CGFloat _index_6_height;
    CGFloat _index_7_height;
    CGFloat _index_8_height;
    BOOL _Tend;
    
    NSString * _xinPinHuiString;
    NSArray * _newGoodARR;
    NSDictionary * _dataZongDic;
    NSDictionary * _likeDataZongDic;
    
    NSArray * _tuiJianGoodARR;
    NSArray * _meiGoodARR;
    NSArray * _daPaiGoodARR;
}

@end

@implementation FirstsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.lunXianImageARR = [[NSMutableArray alloc]init];
    self.index_2_GoodARR = [[NSMutableArray alloc]init];
    _newGoodARR = [[NSArray alloc]init];
    _dataZongDic = [[NSDictionary alloc]init];
    _likeDataZongDic = [[NSDictionary alloc]init];
    self.index_8_goodARR = [[NSMutableArray alloc]init];
    _tuiJianGoodARR = [[NSArray alloc]init];
    _daPaiGoodARR = [[NSArray alloc]init];
    _meiGoodARR = [[NSArray alloc]init];
    
    _index_0_height = 464.0f/750.0f*SIZE_WIDTH;

    _index_1_height = 80+5;//160.0f/750.0f*SIZE_WIDTH+5;

    _index_2_height = 430.0/750.0*SIZE_WIDTH; //40+170+5;//40+350.0/750.0f*SIZE_WIDTH;

    _index_3_height = 440.0/750.0f*SIZE_WIDTH;

    _index_4_height = 300.0/750.0f*SIZE_WIDTH+5;

    _index_5_height = (80.0+350.0+780.0)/750.0f*SIZE_WIDTH+5;

    _index_6_height = 800.0/750.0f*SIZE_WIDTH+5;

    _index_7_height = 830.0/750.0f*SIZE_WIDTH+5;

    float height_8 = 0.0f;
    if (self.index_8_goodARR.count % 2 == 0) {
        height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*(self.index_8_goodARR.count / 2);//80.0/750.0*SIZE_WIDTH+(460.0/750.0*SIZE_WIDTH+5)*4;
    }
    else{
        height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*((self.index_8_goodARR.count+1)/ 2);
    }
    
    _index_8_height = height_8;


    //[self loadIndex_0_View];
    //[self loadIndex_1_view];
    //[self loadIndex_2_view];
    //[self loadIndex_5_view];
    [self createTableviewML];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(index3ButtonLeftAction:) name:Index3Button_LEFT_NOTICIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(index3ButtonRightAction:) name:Index3Button_RIGHT_NOTICIFICATION object:nil];
    
    [self loadJieKouShuJi];
    [self shouyeCaiNiLikeSWithIndex:1 withPagesize:8];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleSchedule) userInfo:nil repeats:YES];

    self.backTopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backTopButton setFrame:CGRectMake(SIZE_WIDTH-40, self.view.frame.size.height-45-49-22, 25, 25)];
    [self.backTopButton setBackgroundImage:[UIImage imageNamed:@"backTop.png"] forState:UIControlStateNormal];
    [self.backTopButton addTarget:self action:@selector(backTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backTopButton];
    self.backTopButton.hidden = YES;
    
    self.likePage = 1;
    
    self.firstImageURLStr = @"";
    self.secondImageURLStr = @"";
    self.threeImageURLStr = @"";
    self.fourImageURLStr = @"";
}

- (void)backTopButtonAction:(UIButton *)sender{

    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    /*
    NSNull * null = [NSNull null];
    //NSString * str = null;
    if ([str isEqualToString:@"dd"]) {
    }
    */
}

#pragma mark  请求接口数据  开始
/**/
- (void)loadJieKouShuJi{

    //http://bbctest.matrojp.com/api.php?m=product&s=webframe&method=display
    NSString * url = [NSString stringWithFormat:@"%@/api.php?m=product&s=webframe&method=display",ZHOULU_ML_BASE_URLString];
    [MLHttpManager get:url params:nil m:@"product" s:@"webframe" success:^(id responseObject) {
        NSLog(@"请求首页 接口的数据为：%@",responseObject);
        
        NSDictionary * result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dataDic = result[@"data"];
                _dataZongDic = result[@"data"];
             //1.0首页轮显
                if ([dataDic[@"advertise"] isKindOfClass:[NSArray class]]) {
                    NSArray * adARR = dataDic[@"advertise"];
                    if (adARR.count > 0) {
                        [self.lunXianImageARR removeAllObjects];
                        for (int i =0 ; i< adARR.count; i++) {
                            NSDictionary * adDic = adARR[i];
                            [self.lunXianImageARR addObject:adDic];
                        }
                    }
                }
                //4个按钮
                if ([dataDic[@"mark"] isKindOfClass:[NSArray class]]) {
                    NSArray * fARR = dataDic[@"mark"];
                    for (int i = 0; i < fARR.count; i++) {
                        if (i == 0) {
                            self.firstImageURLStr = fARR[0][@"imgurl"];
                        }
                        if (i == 1) {
                            self.secondImageURLStr = fARR[1][@"imgurl"];
                        }
                        if (i == 2) {
                            self.threeImageURLStr = fARR[2][@"imgurl"];
                        }
                        if (i == 3) {
                            self.fourImageURLStr = fARR[3][@"imgurl"];
                        }
                        
                    }
                    
                }
                
            //3.0  新品会
                //[self.index_2_titleImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                if ([dataDic[@"newgoodtitle"] isKindOfClass:[NSArray class]]) {
                    NSArray * newgoodtitleARR = dataDic[@"newgoodtitle"];
                    if (newgoodtitleARR.count > 0) {
                        NSDictionary * newGoodDic = newgoodtitleARR[0];
                        _xinPinHuiString = newGoodDic[@"imgurl"];
                    }
                }
                if ([dataDic[@"newgood"] isKindOfClass:[NSArray class]]) {
                    NSArray * newGoodArr = dataDic[@"newgood"];
                    if (newGoodArr.count > 0) {
                        
                        _newGoodARR = dataDic[@"newgood"];
                        //[self.index_2_CollectionView reloadData];
                    }
                }
                
                //为你推荐  商品
                if ([dataDic[@"foryou"] isKindOfClass:[NSArray class]]) {
                    //NSArray * forArr = dataDic[@"foryou"];
                    _tuiJianGoodARR = dataDic[@"foryou"];
                    
                }
                
                //大牌 商品watch
                if ([dataDic[@"watch"] isKindOfClass:[NSArray class]]) {
                    //NSArray * forArr = dataDic[@"foryou"];
                    _daPaiGoodARR = dataDic[@"watch"];
                    
                }
                
                
                //你那么美  商品 beuty
                if ([dataDic[@"beuty"] isKindOfClass:[NSArray class]]) {
                    //NSArray * forArr = dataDic[@"foryou"];
                    _meiGoodARR = dataDic[@"beuty"];
                    
                }
                
            }
            [self.tableview reloadData];
        }
        [self jieShuShuaXin];
    } failure:^(NSError *error) {
        [self jieShuShuaXin];
        [MBProgressHUD showSuccess:REQUEST_ERROR_ZL toView:self.view];
    }];
    

}
//首页猜你喜欢

- (void)shouyeCaiNiLikeSWithIndex:(int) index withPagesize:(int) size{
    NSString *urls = [NSString stringWithFormat:@"%@/api.php?m=product&s=webframe&method=good&pageindex=%d&pagesize=%d",ZHOULU_ML_BASE_URLString,index,size];
    [MLHttpManager get:urls params:nil m:@"product" s:@"webframe" success:^(id responseObject) {
        NSLog(@"请求首页 彩泥喜欢数据接口的数据为：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
                //NSDictionary * dataDic = result[@"data"];
                _likeDataZongDic = result[@"data"];
                if ([_likeDataZongDic[@"good"] isKindOfClass:[NSArray class]]) {
                    //self.index_8_goodARR = _likeDataZongDic[@"good"];
                    [self.index_8_goodARR addObjectsFromArray:_likeDataZongDic[@"good"]];
                    [self.tableview reloadData];
                    //[self.index_8_CollectionView reloadData];
                    NSNumber *count = _likeDataZongDic[@"retcount"];
                    NSLog(@"count====%@",count);
                    if ([count isEqualToNumber:@0] ) {
                        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableview.footer;
                        footer.stateLabel.text = @"没有更多了";
                        //[self jieShuShuaXin];
                        //[self.tableview.footer endRefreshing];
                        return ;
                    }
                    
                }
            }
        }
        [self jieShuShuaXin];
    } failure:^(NSError *error) {
        [self jieShuShuaXin];
        [MBProgressHUD showSuccess:REQUEST_ERROR_ZL toView:self.view];
    }];
}


#pragma end mark 请求家口数据 结束
- (void)createTableviewML{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-49.0-60) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    
    
    UIImage * image1 = [UIImage imageNamed:@"0001"];
    UIImage * image2 = [UIImage imageNamed:@"0002"];
    UIImage * image3 = [UIImage imageNamed:@"0003"];
    UIImage * image4 = [UIImage imageNamed:@"0004"];
    UIImage * image5 = [UIImage imageNamed:@"0005"];
    UIImage * image6 = [UIImage imageNamed:@"0006"];
    NSArray * arr = @[image1,image2,image3,image4,image5,image6];
    NSMutableArray * arrM = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<14; i++) {
        UIImage * imagesss = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png",@"100",i]];
        [arrM addObject:imagesss];
    }
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置普通状态的动画图片 (idleImages 是图片)
    [header setImages:arrM forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:arrM forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:arrM forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    // 设置header
     self.tableview.header = header;
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerShuaXin];
        [self.tableview.footer endRefreshing];
    }];
    
    
    
}
//头部刷新执行的方法
- (void)loadNewData{
    NSLog(@"头部刷新执行的方法");
    [self loadJieKouShuJi];
    [self.index_8_goodARR removeAllObjects];
    [self shouyeCaiNiLikeSWithIndex:1 withPagesize:8];
    self.likePage = 1;
}

- (void)footerShuaXin{
    self.likePage++;
    NSLog(@"首页猜你的页面index；%d",self.likePage);
    [self shouyeCaiNiLikeSWithIndex:self.likePage withPagesize:8];
}

- (void)jieShuShuaXin{
    NSLog(@"结束刷新");
    [self.tableview.header endRefreshing];
    [self.tableview.footer endRefreshing];
}

//=================加载轮显视图  第一个======Start
#pragma mark index_0_view加载方法
- (void)loadIndex_0_View{
    
    self.lunXianView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
    self.lunXianScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
    self.lunXianPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SIZE_WIDTH/2.0-40, _index_0_height-20, 80, 20)];
    self.pageControl = [[ZLPageControl alloc]initWithFrame:CGRectMake(SIZE_WIDTH-100, _index_0_height-20, 100, 20)];
    self.pageControl.userInteractionEnabled = NO;
    
    [self.lunXianView addSubview:self.lunXianScrollView];
    //[self.lunXianView addSubview: self.lunXianPageControl];
    [self.lunXianView addSubview:self.pageControl];
    
    if (![self.lunXianImageARR isKindOfClass:[NSNull class]]) {//防崩溃
        [self imageUIInit];
    }
}


#pragma mark- 图片相关
- (void)imageUIInit {
    
    CGFloat imageScrollViewWidth = MAIN_SCREEN_WIDTH;
    CGFloat imageScrollViewHeight = self.lunXianScrollView.bounds.size.height;
    
    for(int i = 0; i<self.lunXianImageARR.count; i++) {
        if ([self.lunXianImageARR[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
    }
    for (int i=0; i<self.lunXianImageARR.count; i++) {
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        NSString * urlStr = self.lunXianImageARR[i][@"imgurl"];
        
        if ([urlStr hasSuffix:@"webp"]) {
            [imageview setZLWebPImageWithURLStr:urlStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [imageview sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        }
        NSLog(@"imageview == %@",imageview.sd_imageURL);
        
        // imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [imageview addGestureRecognizer:singleTap];
        [self.lunXianScrollView addSubview:imageview];
    }
    
    self.lunXianScrollView.contentSize = CGSizeMake(imageScrollViewWidth*self.lunXianImageARR.count, 0);
    self.lunXianScrollView.bounces = NO;
    self.lunXianScrollView.pagingEnabled = YES;
    self.lunXianScrollView.delegate = self;
    self.lunXianScrollView.showsHorizontalScrollIndicator = NO;
    
    self.lunXianPageControl.numberOfPages = self.lunXianImageARR.count;
    self.pageControl.numberOfPages = self.lunXianImageARR.count;
   
    
    self.lunXianPageControl.tintColor = [UIColor whiteColor];
    self.lunXianPageControl.currentPageIndicatorTintColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    NSString * sender = @"";
    NSString * title = @"";
    NSString * type = self.lunXianImageARR[tap.view.tag][@"ggtype"];
    if ([type isEqualToString:@"4"]) {
        sender = self.lunXianImageARR[tap.view.tag][@"url"];
        title = self.lunXianImageARR[tap.view.tag][@"title"];
    }else{
    
       sender = self.lunXianImageARR[tap.view.tag][@"ggv"];
    }
    [self pushToType:type withUi:sender withTitle:title];
    
}
//=================加载轮显视图  第一个======End
#pragma end mark
#pragma mark index_1_view加载方法
- (void)loadIndex_1_view{
    __weak typeof(self)  weakSelf = self;
    self.fourButtonView = [[FourButtonsView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 80)];
    
    
    if ([self.firstImageURLStr hasSuffix:@"webp"]) {
        [self.fourButtonView.firstImageView setZLWebPImageWithURLStr:self.firstImageURLStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
    } else {
        [self.fourButtonView.firstImageView sd_setImageWithURL:[NSURL URLWithString:self.firstImageURLStr] placeholderImage:PLACEHOLDER_IMAGE];
    }
    if ([self.secondImageURLStr hasSuffix:@"webp"]) {
        [self.fourButtonView.secondImageView setZLWebPImageWithURLStr:self.secondImageURLStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
    } else {
        [self.fourButtonView.secondImageView sd_setImageWithURL:[NSURL URLWithString:self.secondImageURLStr] placeholderImage:PLACEHOLDER_IMAGE];
    }
    if ([self.threeImageURLStr hasSuffix:@"webp"]) {
        [self.fourButtonView.thirdImageView setZLWebPImageWithURLStr:self.threeImageURLStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
    } else {
        [self.fourButtonView.thirdImageView sd_setImageWithURL:[NSURL URLWithString:self.threeImageURLStr] placeholderImage:PLACEHOLDER_IMAGE];
    }
    
    //
    if ([self.fourImageURLStr hasSuffix:@"webp"]) {
        [self.fourButtonView.fourImageView setZLWebPImageWithURLStr:self.fourImageURLStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
    } else {
        [self.fourButtonView.fourImageView sd_setImageWithURL:[NSURL URLWithString:self.fourImageURLStr] placeholderImage:PLACEHOLDER_IMAGE];
    }
    //
    
    
    
    [self.fourButtonView fourButtonBlockAction:^(NSInteger tag) {
       
        NSString * sender = [NSString stringWithFormat:@"%ld",tag-1];
        [weakSelf pushToType:@"9" withUi:sender withTitle:nil];
        
    }];
    //self.fourButtonView.backgroundColor = [UIColor blueColor];
    //self.fourButtonView = [[NSBundle mainBundle] loadNibNamed:@"FourButtonsView" owner:nil options:nil][0];
    //[self.fourButtonView setFrame:CGRectMake(0, 0, SIZE_WIDTH, 85)];
}

#pragma end mark
#pragma mark index_2_View
- (void)loadIndex_2_view{

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
    layout.itemSize = CGSizeMake(100.0f, 140.0f);
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 1.0f;
    self.index_2_CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 120.0/1125.0*SIZE_WIDTH, SIZE_WIDTH,350.0/750.0*SIZE_WIDTH) collectionViewLayout:layout];
    self.index_2_CollectionView.tag = 101;
    self.index_2_CollectionView.delegate = self;
    self.index_2_CollectionView.dataSource = self;
    self.index_2_CollectionView.backgroundColor = [UIColor whiteColor];
    self.index_2_CollectionView.showsHorizontalScrollIndicator = NO;
    [self.index_2_CollectionView registerNib:[UINib nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
    //[self.view addSubview:self.index_2_CollectionView];
    
    

}

#pragma mark CollectionViewDelegate方法
//放回 卡片数量
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return self.index_2_GoodARR.count;
    NSInteger  num = 0;
    if (collectionView.tag == 101) {
        num = _newGoodARR.count;
        NSLog(@"返回的新产品个数为：%ld",num);
    }
    else if(collectionView.tag == 102){
    
        num = _tuiJianGoodARR.count;
    }
    else if(collectionView.tag == 103){
        
        num = _meiGoodARR.count;
    }
    else if(collectionView.tag == 104){
        
        num = _daPaiGoodARR.count;
    }
    else if(collectionView.tag == 105){
        
        num = self.index_8_goodARR.count;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //static NSString * cellID = SecondCCELL_IDENTIFIER;
    


    if (collectionView.tag == 105) {

        MLYourlikeCollectionViewCell * cell = (MLYourlikeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER forIndexPath:indexPath];
        //if ([_likeDataZongDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dics = self.index_8_goodARR[indexPath.row];
        NSString * urls = dics[@"pic"];
        float P_Price = [dics[@"promotion_price"] floatValue];
        int amout = [dics[@"amount"] intValue];
        NSString *price = dics[@"price"];
        NSString * name = dics[@"pname"];
        
        
        if ([urls hasSuffix:@"webp"]) {
            [cell.likeImage setZLWebPImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [cell.likeImage sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:PLACEHOLDER_IMAGE];
        }
        if (amout < 1) {
            cell.shouqingLabel.hidden = NO;
        }
        else{
            cell.shouqingLabel.hidden = YES;
        }
        if (P_Price == 0) {
            cell.likePriceLab.text = [NSString stringWithFormat:@"￥%@",price];
            cell.cuxiaoPriceLabel.hidden = YES;
        }else{
            cell.likePriceLab.text = [NSString stringWithFormat:@"￥%.2f",P_Price];
            cell.cuxiaoPriceLabel.text = [NSString stringWithFormat:@"￥%@",price];
        }
        cell.likeNameLab.text = name;
        //}
        
        return cell;
    }
    else{
        
        MLSecondCollectionViewCell * cell = (MLSecondCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SecondCCELL_IDENTIFIER forIndexPath:indexPath];

        if (collectionView.tag == 101) {
            NSDictionary * goodDic = _newGoodARR[indexPath.row];
            
            NSString * urlStr = goodDic[@"pic"];
            NSString * name = goodDic[@"pname"];
            NSString * pname;
            if (name.length > 6) {
                pname = [name substringToIndex:5];
            }
            NSString * price = goodDic[@"price"];
            
            //
           
            if ([urlStr hasSuffix:@"webp"]) {
                 [cell.secondImageView setZLWebPImageWithURLStr:urlStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
            }
            cell.secondNameLab.text = pname;
            cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%@",price];
        }
        if (collectionView.tag == 102) {
            NSDictionary * goodDic = _tuiJianGoodARR[indexPath.row];
            
            NSString * urlStr = goodDic[@"pic"];
            NSString * name = goodDic[@"pname"];
            NSString * pname;
            if (name.length > 6) {
                pname = [name substringToIndex:5];
            }
            NSString * price = goodDic[@"price"];
            
            //
            
            if ([urlStr hasSuffix:@"webp"]) {
                [cell.secondImageView setZLWebPImageWithURLStr:urlStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
            }
            cell.secondNameLab.text = pname;
            cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%@",price];
        }
        if (collectionView.tag == 103) {
            NSDictionary * goodDic = _meiGoodARR[indexPath.row];
            
            NSString * urlStr = goodDic[@"pic"];
            NSString * name = goodDic[@"pname"];
            NSString * pname;
            if (name.length > 6) {
                pname = [name substringToIndex:5];
            }
            NSString * price = goodDic[@"price"];
            
            //
            
            if ([urlStr hasSuffix:@"webp"]) {
                [cell.secondImageView setZLWebPImageWithURLStr:urlStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
            }
            cell.secondNameLab.text = pname;
            cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%@",price];
        }
        if (collectionView.tag == 104) {
            NSDictionary * goodDic = _daPaiGoodARR[indexPath.row];
            
            NSString * urlStr = goodDic[@"pic"];
            NSString * name = goodDic[@"pname"];
            NSString * pname;
            if (name.length > 6) {
                pname = [name substringToIndex:5];
            }
            NSString * price = goodDic[@"price"];
            
            //
            
            if ([urlStr hasSuffix:@"webp"]) {
                [cell.secondImageView setZLWebPImageWithURLStr:urlStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
            }
            cell.secondNameLab.text = pname;
            cell.secondPriceLab.text = [NSString stringWithFormat:@"￥%@",price];
        }
        return cell;
    }
    
    
    //UICollectionViewCell * cell2 = [collectionView cellForItemAtIndexPath:indexPath];
    /*
    PinPaiModelZl * model = [_pinPaiARR objectAtIndex:indexPath.row];
    NSURL * url = [NSURL URLWithString:model.logo];
    [cell.imageViewzl sd_setImageWithURL:url placeholderImage:PLACEHOLDER_IMAGE];
    */
    
    /*
     [cell.spImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"login_title"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
     
     }];
     
     cell.spNameLabel.text = @"金螳螂建筑装饰有限公司电子商务";
     cell.jiaGeInfoLabel.text = @"￥13649.9";
     
     */
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (collectionView.tag == 1) {
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
        return CGSizeMake(width, 120);
    }else if (collectionView.tag == 7){
        CGFloat cellW = (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2;
        return CGSizeMake(cellW,cellW*1.4);
    }
     */
    float width = 0.0;
    float height = 0.0;
    if (collectionView.tag == 105) {
        width =  (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0;
        //height = 460.0/750.0*SIZE_WIDTH;
        height = 1.35*width;
    }
    else{
        width =  (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*5))/4.0);
        height = 1.6*width;//350.0/750.0*SIZE_WIDTH;
    }
    
    return CGSizeMake(width,height);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    /*
    if (collectionView.tag == 1) {
        return UIEdgeInsetsMake(CollectionViewCellMargin, CollectionViewCellMargin, 0, CollectionViewCellMargin);
    }else if (collectionView.tag == 7){
        return UIEdgeInsetsMake(0, 0, CollectionViewCellMargin, 0);
    }
    return UIEdgeInsetsMake(CollectionViewCellMargin*2, CollectionViewCellMargin*2, CollectionViewCellMargin, CollectionViewCellMargin*2);
     */

    if (collectionView.tag == 105) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 105){
        
        return -2.f;
    }
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 105) {
        return 0.f;
    }
    return 0.0f;
}
 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了第几个：%ld",indexPath.row);
    
    if (collectionView.tag == 101) {
        NSDictionary * goodDic = _newGoodARR[indexPath.row];
        NSString * sender = goodDic[@"id"];
        [self pushToType:@"1" withUi:sender withTitle:nil];
    }
    if (collectionView.tag == 102) {
        NSDictionary * goodDic = _tuiJianGoodARR[indexPath.row];
        NSString * sender = goodDic[@"id"];
        [self pushToType:@"1" withUi:sender withTitle:nil];
    }
    if (collectionView.tag == 103) {
        NSDictionary * goodDic = _meiGoodARR[indexPath.row];
        NSString * sender = goodDic[@"id"];
        [self pushToType:@"1" withUi:sender withTitle:nil];
    }
    if (collectionView.tag == 104) {
        NSDictionary * goodDic = _daPaiGoodARR[indexPath.row];
        NSString * sender = goodDic[@"id"];
        [self pushToType:@"1" withUi:sender withTitle:nil];
    }
    if (collectionView.tag == 105) {
        NSDictionary * dics = self.index_8_goodARR[indexPath.row];
        NSString * sender = dics[@"id"];
        [self pushToType:@"1" withUi:sender withTitle:nil];
    }
    /*
    PinPaiModelZl * model = [_pinPaiARR objectAtIndex:indexPath.row];
    PinPaiSPListViewController *vc =[[PinPaiSPListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = model.id;
    vc.title = model.name;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = YES;
    */
}


#pragma end mark
#pragma mark Index3ButtonAction 
- (void)index3ButtonLeftAction:(id)sender{
    
    NSLog(@"左边");
    if ([_dataZongDic[@"newgoodadvertise"] isKindOfClass:[NSArray class]]) {
        NSArray * newArrs = _dataZongDic[@"newgoodadvertise"];
        if (newArrs.count >= 2) {
            NSDictionary * goodDic1 = newArrs[0];
            NSString * type = goodDic1[@"ggtype"];
            NSString * sender = @"";
            NSString * title = @"";
            if ([type isEqualToString:@"4"]) {
                sender  = goodDic1[@"url"];
                title = goodDic1[@"title"];
            }
            else{
                sender = goodDic1[@"ggv"];
            }
            
            [self pushToType:type withUi:sender withTitle:title];
        }
        
    }


}
-(void)index3ButtonRightAction:(id)sender{
    NSLog(@"右边");
    if ([_dataZongDic[@"newgoodadvertise"] isKindOfClass:[NSArray class]]) {
        NSArray * newArrs = _dataZongDic[@"newgoodadvertise"];
        if (newArrs.count >= 2) {
            NSDictionary * goodDic1 = newArrs[1];
            NSString * type = goodDic1[@"ggtype"];
            NSString * sender = @"";
            NSString * title = @"";
            
            if ([type isEqualToString:@"4"]) {
                sender = goodDic1[@"url"];
                title = goodDic1[@"title"];
            }
            else{
                sender = goodDic1[@"ggv"];
            }
            
            [self pushToType:type withUi:sender withTitle:title];
        }
        
    }

}

#pragma end mark
#pragma mark Index_5_View  开始
- (void)loadIndex_5_view{

    self.index_5_View = [[Index_5_View alloc]initWithFrame:CGRectMake(0, 120.0/1125.0*SIZE_WIDTH, SIZE_WIDTH, _index_5_height-5-120.0/1125.0*SIZE_WIDTH-350.0/750.0*SIZE_WIDTH)];
    [self.index_5_View.topButton addTarget:self action:@selector(index5TopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.index_5_View.leftButton addTarget:self action:@selector(index5LeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.index_5_View.rightButton addTarget:self action:@selector(index5RightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
    layout.itemSize = CGSizeMake((MAIN_SCREEN_WIDTH- (CollectionViewCellMargin*10))/4.0, 350.0/750.0*SIZE_WIDTH);
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 1.0f;
    self.index_5_CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.index_5_View.frame), SIZE_WIDTH,350.0/750.0*SIZE_WIDTH) collectionViewLayout:layout];
    self.index_5_CollectionView.tag = 102;
    self.index_5_CollectionView.delegate = self;
    self.index_5_CollectionView.dataSource = self;
    self.index_5_CollectionView.backgroundColor = [UIColor whiteColor];
    self.index_5_CollectionView.showsHorizontalScrollIndicator = NO;
    [self.index_5_CollectionView registerNib:[UINib nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
    
}

- (void)index5TopButtonAction:(UIButton *)sender{
    NSLog(@"点击了上  按钮");
    if ([_dataZongDic[@"foryoufull"] isKindOfClass:[NSArray class]]) {
        NSArray * arrd = _dataZongDic[@"foryoufull"];
        
        if (arrd.count > 0) {
            NSDictionary * goodDicss = arrd[0];

            NSString *type = goodDicss[@"ggtype"];
            NSString * sender = @"";
            NSString * tittle = @"";
            if ([type isEqualToString:@"4"]) {
                sender = goodDicss[@"url"];
                tittle = goodDicss[@"title"];
                
            }else{
                sender = goodDicss[@"ggv"];
            }
            
            
            [self pushToType:type withUi:sender withTitle:tittle];
        }
        
        
    }

}

- (void)index5LeftButtonAction:(UIButton *)sender{
    NSLog(@"点解了  左 按钮");
    if ([_dataZongDic[@"foryouadvertise"] isKindOfClass:[NSArray class]]) {
        NSArray * arrd = _dataZongDic[@"foryouadvertise"];
        
        if (arrd.count >= 2) {
            NSDictionary * goodDicss = arrd[0];
            NSString * type = goodDicss[@"ggtype"];
            NSString * sender = @"";
            NSString * title = @"";
            
            if ([type isEqualToString:@"4"]) {
                sender = goodDicss[@"url"];
                title = goodDicss[@"title"];
            }
            else{
                sender = goodDicss[@"ggv"];
            
            }
            
            [self pushToType:type withUi:sender withTitle:title];
        }
        
        
    }

}

- (void)index5RightButtonAction:(UIButton *)sender{
    NSLog(@"点击了 右  按钮");
    if ([_dataZongDic[@"foryouadvertise"] isKindOfClass:[NSArray class]]) {
        NSArray * arrd = _dataZongDic[@"foryouadvertise"];
        
        if (arrd.count >= 2) {
            NSDictionary * goodDicss = arrd[1];
            NSString * type = goodDicss[@"ggtype"];
            NSString * sender = @"";
            NSString * title = @"";
            if ([type isEqualToString:@"4"]) {
                sender = goodDicss[@"url"];
                title = goodDicss[@"title"];
            }
            else{
                sender = goodDicss[@"ggv"];
            
            }
            
            [self pushToType:type withUi:sender withTitle:title];
        }
        
        
    }
}



#pragma end mark



#pragma mark TableViewDelegate代理方法Start
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
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
            height = _index_1_height;
            
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
            height = _index_5_height;
            
        }
            break;
        case 6:{
            height = _index_6_height;
            
        }
            break;
        case 7:{
            height = _index_7_height;
            
        }
            break;
        case 8:{
            float height_8 = 0.0f;
            if (self.index_8_goodARR.count % 2 == 0) {
                height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*(self.index_8_goodARR.count / 2);//80.0/750.0*SIZE_WIDTH+(460.0/750.0*SIZE_WIDTH+5)*4;
            }
            else{
                height_8 = 80.0/750.0*SIZE_WIDTH+((MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2.0*1.35)*((self.index_8_goodARR.count+1)/2);
            }
            _index_8_height = height_8;
            height = _index_8_height;
        }
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"tableviewCellID";
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    switch (indexPath.row) {
        case 0:{
            
            [self loadIndex_0_View];
            [cell addSubview:self.lunXianView];
        }
            break;
        case 1:{
            [self loadIndex_1_view];
            cell.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
            [cell addSubview:self.fourButtonView];
        }
            
            break;
        case 2:{
//            self.index_2_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
//            self.index_2_titleLabel.text = @"新品惠";
//            self.index_2_titleLabel.font = [UIFont systemFontOfSize:12.0f];
//            self.index_2_titleLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
            self.index_2_titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 120.0/1125.0*SIZE_WIDTH)];
           //
           
            if ([_xinPinHuiString hasSuffix:@"webp"]) {
                 [self.index_2_titleImageView setZLWebPImageWithURLStr:_xinPinHuiString withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [self.index_2_titleImageView sd_setImageWithURL:[NSURL URLWithString:_xinPinHuiString] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
            }
            //[cell addSubview:self.index_2_titleLabel];
            [cell addSubview:self.index_2_titleImageView];
            
            [self loadIndex_2_view];
            
            [cell addSubview:self.index_2_CollectionView];
            
        }
            
            break;
        case 3:{
            static NSString *CellIdentifier = @"Index3TableViewCellID" ;
            cell = (Index3TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"Index3TableViewCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                cell.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
                
            }
            if ([_dataZongDic[@"newgoodadvertise"] isKindOfClass:[NSArray class]]) {
                NSArray * newArrs = _dataZongDic[@"newgoodadvertise"];
                if (newArrs.count >= 2) {
                    NSDictionary * goodDic1 = newArrs[0];
                    NSDictionary * goodDic2 = newArrs[1];
                    NSString * leftStr = goodDic1[@"imgurl"];
                    NSString * rightStr = goodDic2[@"imgurl"];

                    UIButton * leftBtn = (UIButton *)[cell viewWithTag:10];
                    UIButton * rightBtn = (UIButton *)[cell viewWithTag:11];


                    if ([leftStr hasSuffix:@"webp"]) {
                        [leftBtn setZLWebPButton_BackgroundImageWithURLStr:leftStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:leftStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                    if ([rightStr hasSuffix:@"webp"]) {
                        [rightBtn setZLWebPButton_BackgroundImageWithURLStr:rightStr withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [rightBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:rightStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                }
  
            }
            
            
        }
            
            break;
        case 4:{
            self.index_4_imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, _index_4_height-5)];
            self.index_4_imageview.userInteractionEnabled = YES;
            
            if ([_dataZongDic[@"newgoodsee"] isKindOfClass:[NSArray class]]) {
                
                NSArray * arr = _dataZongDic[@"newgoodsee"];
                if (arr.count > 0) {
                    NSDictionary * goodsDic = arr[0];
                    NSString * urls = goodsDic[@"imgurl"];
                    
                    if ([urls hasSuffix:@"webp"]) {
                        [self.index_4_imageview setZLWebPImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [self.index_4_imageview sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                }
                
            }

            
            [cell addSubview:self.index_4_imageview];
        }
            
            break;
        case 5:{
//            self.index_5_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
//            self.index_5_titleLabel.text = @"为你推荐";
//            self.index_5_titleLabel.font = [UIFont systemFontOfSize:12.0f];
//            self.index_5_titleLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
            self.index_5_titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, SIZE_WIDTH, 120.0/1125.0*SIZE_WIDTH)];
            if ([_dataZongDic[@"foryoutitle"] isKindOfClass:[NSArray class]]) {
                NSArray * arrd = _dataZongDic[@"foryoutitle"];
                
                if (arrd.count > 0) {
                    NSDictionary * goodDicss = arrd[0];
                    NSString * urls = goodDicss[@"imgurl"];
                    
                    
                    if ([urls hasSuffix:@"webp"]) {
                        [self.index_5_titleImageView setZLWebPImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [self.index_5_titleImageView sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                    
                }
                
                
            }

            //[cell addSubview:self.index_5_titleLabel];
            [cell addSubview:self.index_5_titleImageView];
            
            [self loadIndex_5_view];
            
            
            if ([_dataZongDic[@"foryoufull"] isKindOfClass:[NSArray class]]) {
                NSArray * arrd = _dataZongDic[@"foryoufull"];
                
                if (arrd.count > 0) {
                    NSDictionary * goodDicss = arrd[0];
                    NSString * urls = goodDicss[@"imgurl"];

                    
                    if ([urls hasSuffix:@"webp"]) {
                        [self.index_5_View.topButton setZLWebPButton_BackgroundImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                       [self.index_5_View.topButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urls] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                    
                }
                
                
            }
            if ([_dataZongDic[@"foryouadvertise"] isKindOfClass:[NSArray class]]) {
                NSArray * arrd = _dataZongDic[@"foryouadvertise"];
                
                if (arrd.count >= 2) {
                    NSDictionary * goodDicss = arrd[0];
                    NSString * urls = goodDicss[@"imgurl"];
                    NSDictionary * goodDicss2 = arrd[1];
                    NSString * urls2 = goodDicss2[@"imgurl"];
                    
                    
                    if ([urls hasSuffix:@"webp"]) {
                        [self.index_5_View.leftButton setZLWebPButton_BackgroundImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [self.index_5_View.leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urls] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                    if ([urls2 hasSuffix:@"webp"]) {
                        [self.index_5_View.rightButton setZLWebPButton_BackgroundImageWithURLStr:urls2 withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [self.index_5_View.rightButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urls2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                    
                     
                }
                
                
            }
            
            
            [cell addSubview:self.index_5_View];
            [cell addSubview:self.index_5_CollectionView];
            
        }
            
            break;
        case 6:{
            static NSString *SecondCellIdentifier = @"MLSecondTableViewCell";
            MLSecondTableViewCell *SecondTableViewCell = [tableView dequeueReusableCellWithIdentifier:SecondCellIdentifier];
            if (SecondTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: SecondCellIdentifier owner:self options:nil];
                SecondTableViewCell = [array objectAtIndex:0];
            }

            SecondTableViewCell.leftClickblock = ^(){
                NSLog(@"点击了左边的按钮");
                if ([_dataZongDic[@"beutyadvertise"] isKindOfClass:[NSArray class]]) {
                    NSArray * arrsd = _dataZongDic[@"beutyadvertise"];
                    if (arrsd.count >= 2) {
                        NSDictionary * beDic = arrsd[0];
                        NSString * type = beDic[@"ggtype"];
                        NSString * sender = @"";
                        NSString * title = @"";
                        if ([type isEqualToString:@"4"]) {
                            title = beDic[@"title"];
                            sender = beDic[@"url"];
                        }
                        else{
                            sender = beDic[@"ggv"];
                        }
                        
                        
                        [self pushToType:type withUi:sender withTitle:title];
                    }
                }

            };
            SecondTableViewCell.rightClickblock = ^(){
                NSLog(@"点击了右边的按钮");
                if ([_dataZongDic[@"beutyadvertise"] isKindOfClass:[NSArray class]]) {
                    NSArray * arrsd = _dataZongDic[@"beutyadvertise"];
                    if (arrsd.count >= 2) {
                        NSDictionary * beDic2 = arrsd[1];
                        NSString * type = beDic2[@"ggtype"];
                        NSString * sender = @"";
                        NSString * title = @"";
                        if ([type isEqualToString:@"4"]) {
                            title = beDic2[@"title"];
                            sender = beDic2[@"url"];
                        }
                        else{
                            sender = beDic2[@"ggv"];
                        }
                        
                        
                        [self pushToType:type withUi:sender withTitle:title];
                    }
                }

            };
            SecondTableViewCell.secondCollectionView.delegate = self;
            SecondTableViewCell.secondCollectionView.dataSource = self;
            SecondTableViewCell.secondCollectionView.tag = 103;
            [SecondTableViewCell.secondCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            SecondTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            
            if ([_dataZongDic[@"beutytitle"] isKindOfClass:[NSArray class]]) {
                NSArray * arrsd = _dataZongDic[@"beutytitle"];
                if (arrsd.count > 0) {
                    NSDictionary * beDic = arrsd[0];
                    NSString * urls = beDic[@"imgurl"];
                    
                    if ([urls hasSuffix:@"webp"]) {
                        [SecondTableViewCell.secondHeadimage setZLWebPImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [SecondTableViewCell.secondHeadimage sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                }
            }
            if ([_dataZongDic[@"beutyadvertise"] isKindOfClass:[NSArray class]]) {
                NSArray * arrsd = _dataZongDic[@"beutyadvertise"];
                if (arrsd.count >= 2) {
                    NSDictionary * beDic = arrsd[0];
                    NSString * urls = beDic[@"imgurl"];
                    
                    if ([urls hasSuffix:@"webp"]) {
                        [SecondTableViewCell.secondImage1 setZLWebPImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [SecondTableViewCell.secondImage1 sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                    
                    NSDictionary * beDic2 = arrsd[1];
                    NSString * urls2 = beDic2[@"imgurl"];
                    
                    if ([urls2 hasSuffix:@"webp"]) {
                        [SecondTableViewCell.secondImage2 setZLWebPImageWithURLStr:urls2 withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [SecondTableViewCell.secondImage2 sd_setImageWithURL:[NSURL URLWithString:urls2] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                }
            }
            
            
            
            
            cell = SecondTableViewCell;
            //return SecondTableViewCell;
        }
            
            break;
        case 7:{
            static NSString *ThirdCellIdentifier = @"MLThirdTableViewCell";
            MLThirdTableViewCell *ThirdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ThirdCellIdentifier];
            if (ThirdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ThirdCellIdentifier owner:self options:nil];
                ThirdTableViewCell = [array objectAtIndex:0];
            }
            
            ThirdTableViewCell.imageClickBlock = ^(){
                NSLog(@"点解了");
                if ([_dataZongDic[@"havewatch"] isKindOfClass:[NSArray class]]) {
                    NSArray * arrsd = _dataZongDic[@"havewatch"];
                    if (arrsd.count > 0) {
                        NSDictionary * beDic = arrsd[0];
                        NSString * urls = beDic[@"ggtype"];
                        NSString * sender = @"";
                        NSString * title = @"";
                        if ([urls isEqualToString:@"4"]) {
                            title = beDic[@"title"];
                            sender = beDic[@"url"];
                            
                        }else{
                            sender = beDic[@"ggv"];
                        }
                        
                        
                        [self pushToType:urls withUi:sender withTitle:title];

                    }
                }
            };
            
            ThirdTableViewCell.thirdCollectionView.delegate = self;
            ThirdTableViewCell.thirdCollectionView.dataSource = self;
            ThirdTableViewCell.thirdCollectionView.tag = 104;
            [ThirdTableViewCell.thirdCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            ThirdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            //return ThirdTableViewCell;
            
            if ([_dataZongDic[@"watchtitle"] isKindOfClass:[NSArray class]]) {
                NSArray * arrsd = _dataZongDic[@"watchtitle"];
                if (arrsd.count > 0) {
                    NSDictionary * beDic = arrsd[0];
                    NSString * urls = beDic[@"imgurl"];
                    
                    if ([urls hasSuffix:@"webp"]) {
                        [ThirdTableViewCell.thirdHeadImage setZLWebPImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [ThirdTableViewCell.thirdHeadImage sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                }
            }
            if ([_dataZongDic[@"havewatch"] isKindOfClass:[NSArray class]]) {
                NSArray * arrsd = _dataZongDic[@"havewatch"];
                if (arrsd.count > 0) {
                    NSDictionary * beDic = arrsd[0];
                    NSString * urls = beDic[@"imgurl"];
                    
                    if ([urls hasSuffix:@"webp"]) {
                        [ThirdTableViewCell.thirdImage setZLWebPImageWithURLStr:urls withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [ThirdTableViewCell.thirdImage sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    }
                }
            }

            cell = ThirdTableViewCell;
        }
            
            break;
        case 8:{
            static NSString *YourlikeCellIdentifier = @"MLYourlikeTableViewCell";
            MLYourlikeTableViewCell *YourlikeTableViewCell = [tableView dequeueReusableCellWithIdentifier:YourlikeCellIdentifier];
            if (YourlikeTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: YourlikeCellIdentifier owner:self options:nil];
                YourlikeTableViewCell = [array objectAtIndex:0];
            }
            
            if ([_likeDataZongDic[@"supertitle"] isKindOfClass:[NSArray class]]) {
                NSArray * arr = _likeDataZongDic[@"supertitle"];
               
                if (arr.count > 0) {
                     NSDictionary * dic = arr[0];
                    
                    
                    if ([dic[@"imgurl"] hasSuffix:@"webp"]) {
                        [YourlikeTableViewCell.likeHeadImage setZLWebPImageWithURLStr:dic[@"imgurl"] withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [YourlikeTableViewCell.likeHeadImage sd_setImageWithURL:[NSURL URLWithString:dic[@"imgurl"]] placeholderImage:PLACEHOLDER_IMAGE];
                    }
                }
                
            }
            
            
            YourlikeTableViewCell.LikeCollectionView.delegate = self;
            YourlikeTableViewCell.LikeCollectionView.dataSource = self;
            YourlikeTableViewCell.LikeCollectionView.tag = 105;
            [YourlikeTableViewCell.LikeCollectionView registerNib:[UINib  nibWithNibName:@"MLYourlikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER];
            self.index_8_CollectionView = YourlikeTableViewCell.LikeCollectionView;
            YourlikeTableViewCell.LikeCollectionView.bounces = NO;
            YourlikeTableViewCell.LikeCollectionView.scrollEnabled = NO;
            
            YourlikeTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            cell = YourlikeTableViewCell;
            //return YourlikeTableViewCell;
        }
            
            break;

        default:
            break;
    }

    return cell;;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 4) {
        if ([_dataZongDic[@"newgoodsee"] isKindOfClass:[NSArray class]]) {
            
            NSArray * arr = _dataZongDic[@"newgoodsee"];
            if (arr.count > 0) {
                NSDictionary * goodsDic = arr[0];
                //NSString * urls = goodsDic[@"imgurl"];
                NSString *type = goodsDic[@"ggtype"];
                NSString * sender = goodsDic[@"ggv"];
                
                NSString * title = @"";
                
                if ([type isEqualToString:@"4"]) {
                    sender = goodsDic[@"url"];
                    title = goodsDic[@"title"];
                }
                else{
                    sender = goodsDic[@"ggv"];
                }
                
                [self pushToType:type withUi:sender withTitle:title];
            }
            
        }

    }

}


#pragma end mark 代理方法结束



#pragma mark ScrollView代理方法开始
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.lunXianScrollView) {
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        self.lunXianPageControl.currentPage = i - 1;
        self.pageControl.currentPage = i-1;
    }
    else{
        if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:withContentOffest:)]) {
        [self.firstDelegate firstViewController:self withContentOffest:scrollView.contentOffset.y];
        }
        if(scrollView.contentOffset.y+20 < self.historyOffestY){
        
        
        }
        else{
        
        
        }
        //NSLog(@"scrollView.contentOffset.y的值为：%f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y > 200.0f) {
            self.backTopButton.hidden = NO;
        }
        else{
            self.backTopButton.hidden = YES;
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    self.historyOffestY = scrollView.contentOffset.y;
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:withBeginOffest:)]) {
        [self.firstDelegate firstViewController:self withBeginOffest:scrollView.contentOffset.y];
    }
    
}
#pragma end mark 代理方法结束
- (void)pushToType:(NSString *)index withUi:(NSString *)sender withTitle:(NSString *)title{
    
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:JavaScriptActionFourButton:withUi:withTitle:)]) {
        [self.firstDelegate firstViewController:self JavaScriptActionFourButton:index withUi:sender withTitle:title];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//定时任务方法调用：（注意计算好最后一页循环滚动）

-(void)handleSchedule{
    
    self.lunXianPageControl.currentPage++;
    self.pageControl.currentPage++;
    if(_Tend){
        
        [self.lunXianScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        self.lunXianPageControl.currentPage=0;
        self.pageControl.currentPage = 0;
        
    }else{
        
        [self.lunXianScrollView  setContentOffset:CGPointMake(self.pageControl.currentPage*SIZE_WIDTH, 0) animated:YES];
        
    }
    
    if (self.pageControl.currentPage==self.pageControl.numberOfPages-1) {
        
        _Tend=YES;
        
    }else{
        
        _Tend=NO;
        
    }
    
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

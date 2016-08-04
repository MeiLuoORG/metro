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
    
    
    NSString * _xinPinHuiString;
    NSArray * _newGoodARR;
    NSDictionary * _dataZongDic;
}

@end

@implementation FirstsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _index_0_height = 464.0f/750.0f*SIZE_WIDTH;

    _index_1_height = 80+5;//160.0f/750.0f*SIZE_WIDTH+5;

    _index_2_height = 430.0/750.0*SIZE_WIDTH; //40+170+5;//40+350.0/750.0f*SIZE_WIDTH;

    _index_3_height = 440.0/750.0f*SIZE_WIDTH;

    _index_4_height = 300.0/750.0f*SIZE_WIDTH+5;

    _index_5_height = (80.0+350.0+780.0)/750.0f*SIZE_WIDTH+5;

    _index_6_height = 40+720.0/750.0f*SIZE_WIDTH+5;

    _index_7_height = 40+750.0/750.0f*SIZE_WIDTH+5;

    _index_8_height = 40.0+(460.0/750.0*SIZE_WIDTH+5)*4;

    self.lunXianImageARR = [[NSMutableArray alloc]init];
    self.index_2_GoodARR = [[NSMutableArray alloc]init];
    _newGoodARR = [[NSArray alloc]init];
    _dataZongDic = [[NSDictionary alloc]init];
    //[self loadIndex_0_View];
    [self loadIndex_1_view];
    //[self loadIndex_2_view];
    //[self loadIndex_5_view];
    [self createTableviewML];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(index3ButtonLeftAction:) name:Index3Button_LEFT_NOTICIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(index3ButtonRightAction:) name:Index3Button_RIGHT_NOTICIFICATION object:nil];
    
    [self loadJieKouShuJi];
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
                        
                        for (int i =0 ; i< adARR.count; i++) {
                            NSDictionary * adDic = adARR[i];
                            [self.lunXianImageARR addObject:adDic];
                            
                            
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
                        [self.index_2_CollectionView reloadData];
                    }
                }
                
                //4.0
                
                
            }
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
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
    
}
//=================加载轮显视图  第一个======Start
#pragma mark index_0_view加载方法
- (void)loadIndex_0_View{
    
    self.lunXianView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
    self.lunXianScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _index_0_height)];
    self.lunXianPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SIZE_WIDTH/2.0-40, _index_0_height-20, 80, 20)];
    
    [self.lunXianView addSubview:self.lunXianScrollView];
    [self.lunXianView addSubview: self.lunXianPageControl];
    
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
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_default"]];
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
    
    self.lunXianPageControl.tintColor = [UIColor whiteColor];
    self.lunXianPageControl.currentPageIndicatorTintColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    
    NSLog(@"轮显%ld",tap.view.tag);
    NSString * type = self.lunXianImageARR[tap.view.tag][@"ggtype"];
    NSString * sender = self.lunXianImageARR[tap.view.tag][@"ggv"];
    
    [self pushToType:type withUi:sender];
    
}
//=================加载轮显视图  第一个======End
#pragma end mark
#pragma mark index_1_view加载方法
- (void)loadIndex_1_view{
    __weak typeof(self)  weakSelf = self;
    self.fourButtonView = [[FourButtonsView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 80)];
    [self.fourButtonView fourButtonBlockAction:^(NSInteger tag) {
       
        NSString * sender = [NSString stringWithFormat:@"%ld",tag-1];
        [weakSelf pushToType:@"9" withUi:sender];
        
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
    NSInteger  num;
    if (collectionView.tag == 101) {
        num = _newGoodARR.count;
        NSLog(@"返回的新产品个数为：%ld",num);
    }
    else{
    
        num = 7;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = SecondCCELL_IDENTIFIER;
    
    MLSecondCollectionViewCell * cell = (MLSecondCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary * goodDic = _newGoodARR[indexPath.row];
    
    NSString * urlStr = goodDic[@"pic"];
    NSString * name = goodDic[@"pname"];
    NSString * pname;
    if (name.length > 6) {
        pname = [name substringToIndex:5];
    }
    NSString * price = goodDic[@"price"];
    
    [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
    cell.secondNameLab.text = pname;
    cell.secondPriceLab.text = price;
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
    return cell;
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
    if (collectionView.tag == 105) {
        width =  (MAIN_SCREEN_WIDTH - CollectionViewCellMargin)/2;
    }
    else{
        width =  (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
    }
    
    return CGSizeMake(width, width*1.4);
    
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
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 1) {
        return 0.f;
    }else if (collectionView.tag == 7){
        
        return 5.f;
    }
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 7) {
        return 5.f;
    }
    return 10.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了第几个：%ld",indexPath.row);
    
    if (collectionView.tag == 101) {
        NSDictionary * goodDic = _newGoodARR[indexPath.row];
        NSString * sender = goodDic[@"id"];
        [self pushToType:@"1" withUi:sender];
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
            NSString * sender = goodDic1[@"ggv"];
            
            [self pushToType:type withUi:sender];
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
            NSString * sender = goodDic1[@"ggv"];
            
            [self pushToType:type withUi:sender];
        }
        
    }

}

#pragma end mark
#pragma mark Index_5_View  开始
- (void)loadIndex_5_view{

    self.index_5_View = [[Index_5_View alloc]initWithFrame:CGRectMake(0, 120.0/1125.0*SIZE_WIDTH, SIZE_WIDTH, _index_5_height-120.0/1125.0*SIZE_WIDTH-350.0/750.0*SIZE_WIDTH-5)];
    [self.index_5_View.topButton addTarget:self action:@selector(index5TopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.index_5_View.leftButton addTarget:self action:@selector(index5LeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.index_5_View.rightButton addTarget:self action:@selector(index5RightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
    layout.itemSize = CGSizeMake(100.0f, 140.0f);
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 1.0f;
    self.index_5_CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.index_5_View.frame)+5, SIZE_WIDTH,140.0) collectionViewLayout:layout];
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
            NSString * sender = goodDicss[@"ggv"];

            [self pushToType:type withUi:sender];
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
            NSString * sender = goodDicss[@"ggv"];
            
            [self pushToType:type withUi:sender];
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
            NSString * sender = goodDicss[@"ggv"];
            
            [self pushToType:type withUi:sender];
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
           [self.index_2_titleImageView sd_setImageWithURL:[NSURL URLWithString:_xinPinHuiString] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
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
                    [leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:leftStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    [rightBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:rightStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    
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
                    [self.index_4_imageview sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
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
            self.index_5_titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, SIZE_WIDTH, 120.0/1225.0*SIZE_WIDTH)];
            if ([_dataZongDic[@"foryoutitle"] isKindOfClass:[NSArray class]]) {
                NSArray * arrd = _dataZongDic[@"foryoutitle"];
                
                if (arrd.count > 0) {
                    NSDictionary * goodDicss = arrd[0];
                    NSString * urls = goodDicss[@"imgurl"];
                    
                    [self.index_5_titleImageView sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                    
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

                    [self.index_5_View.topButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urls] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                }
                
                
            }
            if ([_dataZongDic[@"foryouadvertise"] isKindOfClass:[NSArray class]]) {
                NSArray * arrd = _dataZongDic[@"foryouadvertise"];
                
                if (arrd.count >= 2) {
                    NSDictionary * goodDicss = arrd[0];
                    NSString * urls = goodDicss[@"imgurl"];
                    NSDictionary * goodDicss2 = arrd[1];
                    NSString * urls2 = goodDicss2[@"imgurl"];
                    
                    [self.index_5_View.leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urls] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
                     [self.index_5_View.rightButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urls2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
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
            };
            SecondTableViewCell.rightClickblock = ^(){
                NSLog(@"点击了右边的按钮");
            };
            SecondTableViewCell.secondCollectionView.delegate = self;
            SecondTableViewCell.secondCollectionView.dataSource = self;
            SecondTableViewCell.secondCollectionView.tag = 103;
            [SecondTableViewCell.secondCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            SecondTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return SecondTableViewCell;
        }
            
            break;
        case 7:{
            static NSString *ThirdCellIdentifier = @"MLThirdTableViewCell";
            MLThirdTableViewCell *ThirdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ThirdCellIdentifier];
            if (ThirdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ThirdCellIdentifier owner:self options:nil];
                ThirdTableViewCell = [array objectAtIndex:0];
            }
            ThirdTableViewCell.thirdCollectionView.delegate = self;
            ThirdTableViewCell.thirdCollectionView.dataSource = self;
            ThirdTableViewCell.thirdCollectionView.tag = 104;
            [ThirdTableViewCell.thirdCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            ThirdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return ThirdTableViewCell;
        }
            
            break;
        case 8:{
            static NSString *YourlikeCellIdentifier = @"MLYourlikeTableViewCell";
            MLYourlikeTableViewCell *YourlikeTableViewCell = [tableView dequeueReusableCellWithIdentifier:YourlikeCellIdentifier];
            if (YourlikeTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: YourlikeCellIdentifier owner:self options:nil];
                YourlikeTableViewCell = [array objectAtIndex:0];
            }
            YourlikeTableViewCell.LikeCollectionView.delegate = self;
            YourlikeTableViewCell.LikeCollectionView.dataSource = self;
            YourlikeTableViewCell.LikeCollectionView.tag = 105;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 4) {
        if ([_dataZongDic[@"newgoodsee"] isKindOfClass:[NSArray class]]) {
            
            NSArray * arr = _dataZongDic[@"newgoodsee"];
            if (arr.count > 0) {
                NSDictionary * goodsDic = arr[0];
                NSString * urls = goodsDic[@"imgurl"];
                NSString *type = goodsDic[@"ggtype"];
                NSString * sender = goodsDic[@"ggv"];
                [self pushToType:type withUi:sender];
            }
            
        }

    }

}


#pragma end mark 代理方法结束



#pragma mark ScrollView代理方法开始
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll6+++");
    if (scrollView == self.lunXianScrollView) {
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        self.lunXianPageControl.currentPage = i - 1;
    }
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:withContentOffest:)]) {
        [self.firstDelegate firstViewController:self withContentOffest:scrollView.contentOffset.y];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:withBeginOffest:)]) {
        [self.firstDelegate firstViewController:self withBeginOffest:scrollView.contentOffset.y];
    }
    
}
#pragma end mark 代理方法结束
- (void)pushToType:(NSString *)index withUi:(NSString *)sender{
    
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:JavaScriptActionFourButton:withUi:)]) {
        [self.firstDelegate firstViewController:self JavaScriptActionFourButton:index withUi:sender];
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

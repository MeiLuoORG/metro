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
    
    NSMutableArray *_imageArray;

    
}
@property (strong,nonatomic)UIScrollView *imageScrollView;
@property (strong,nonatomic)UIPageControl *pagecontrol;

@end

@implementation SecondsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index_0_height = 464.0f/750.0f*SIZE_WIDTH;
    
    _index_1_height = 460.0f/750.0f*SIZE_WIDTH+5;
    
    _index_2_height = 300.0f/750.0f*SIZE_WIDTH+5;
    
    _index_3_height = 300.0f/750.0f*SIZE_WIDTH+5;
    
    _index_4_height = 300.0f/750.0f*SIZE_WIDTH+5;
    
    _index_5_height = 724.0/750.0f*SIZE_WIDTH+40.0f;
    
    _index_6_height = 724.0/750.0f*SIZE_WIDTH+40.0f;
    
    _index_7_height = 40.0+(460.0/750.0*SIZE_WIDTH+5)*5;
    

    [self createTableviewML];
    
}
- (void)createTableviewML{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-49.0-60) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    
}

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
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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

            _imageArray = [[NSMutableArray alloc]initWithObjects:@"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a4224ee4dd.jpg_1125X696-50.jpg",
                           @"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a42075eeae.jpg_1125X696-50.jpg",
                           @"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a41ed8ef5a.jpg_1125X696-50.jpg",
                           nil];
            
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
            FristTableViewCell.hotspClick = ^(){
                NSLog(@"热门商品");
            
            };
            
            FristTableViewCell.hotppClick = ^(){
                NSLog(@"热门品牌");
                
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
//            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 217.0f)];
//            view1.backgroundColor = [UIColor redColor];
//            [cell addSubview:view1];
            static NSString *ADCellIdentifier = @"MLAdTableViewCell";
            MLAdTableViewCell *AdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ADCellIdentifier];
            if (AdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ADCellIdentifier owner:self options:nil];
                AdTableViewCell = [array objectAtIndex:0];
            }
            AdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return AdTableViewCell;
            
            
        }
            break;
            
        case 3:{
//            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 440.0/750.0f*SIZE_WIDTH)];
//            view1.backgroundColor = [UIColor orangeColor];
//            [cell addSubview:view1];
            
            static NSString *ADCellIdentifier = @"MLAdTableViewCell";
            MLAdTableViewCell *AdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ADCellIdentifier];
            if (AdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ADCellIdentifier owner:self options:nil];
                AdTableViewCell = [array objectAtIndex:0];
            }
            AdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return AdTableViewCell;
        }
            break;
            
        case 4:{
//            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 300.0/750.0f*SIZE_WIDTH)];
//            view1.backgroundColor = [UIColor redColor];
//            [cell addSubview:view1];
            static NSString *ADCellIdentifier = @"MLAdTableViewCell";
            MLAdTableViewCell *AdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ADCellIdentifier];
            if (AdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ADCellIdentifier owner:self options:nil];
                AdTableViewCell = [array objectAtIndex:0];
            }
            AdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return AdTableViewCell;
        }
            
            break;
        case 5:{
//            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 300.0/750.0f*SIZE_WIDTH)];
//            view1.backgroundColor = [UIColor orangeColor];
//            [cell addSubview:view1];
            static NSString *SecondCellIdentifier = @"MLSecondTableViewCell";
            MLSecondTableViewCell *SecondTableViewCell = [tableView dequeueReusableCellWithIdentifier:SecondCellIdentifier];
            if (SecondTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: SecondCellIdentifier owner:self options:nil];
                SecondTableViewCell = [array objectAtIndex:0];
            }
            SecondTableViewCell.secondCollectionView.delegate = self;
            SecondTableViewCell.secondCollectionView.dataSource = self;
            SecondTableViewCell.secondCollectionView.tag = 5;
            [SecondTableViewCell.secondCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            SecondTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return SecondTableViewCell;
        }
            
            break;
        case 6:{
//            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40+400.0/750.0f*SIZE_WIDTH+ 370.0/750.0f*SIZE_WIDTH+177.0+5)];
//            view1.backgroundColor = [UIColor redColor];
//            [cell addSubview:view1];
            
            static NSString *ThirdCellIdentifier = @"MLThirdTableViewCell";
            MLThirdTableViewCell *ThirdTableViewCell = [tableView dequeueReusableCellWithIdentifier:ThirdCellIdentifier];
            if (ThirdTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: ThirdCellIdentifier owner:self options:nil];
                ThirdTableViewCell = [array objectAtIndex:0];
            }
            ThirdTableViewCell.thirdCollectionView.delegate = self;
            ThirdTableViewCell.thirdCollectionView.dataSource = self;
            ThirdTableViewCell.thirdCollectionView.tag = 6;
            [ThirdTableViewCell.thirdCollectionView registerNib:[UINib  nibWithNibName:@"MLSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SecondCCELL_IDENTIFIER];
            ThirdTableViewCell.selectionStyle = UITableViewCellAccessoryNone;
            return ThirdTableViewCell;
        }
            
            break;
        case 7:{
//            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40+370.0/750.0f*SIZE_WIDTH+177.0+5)];
//            view1.backgroundColor = [UIColor orangeColor];
//            [cell addSubview:view1];
            
            static NSString *YourlikeCellIdentifier = @"MLYourlikeTableViewCell";
            MLYourlikeTableViewCell *YourlikeTableViewCell = [tableView dequeueReusableCellWithIdentifier:YourlikeCellIdentifier];
            if (YourlikeTableViewCell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: YourlikeCellIdentifier owner:self options:nil];
                YourlikeTableViewCell = [array objectAtIndex:0];
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


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        MLFristCollectionViewCell *cell = (MLFristCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FristCCELL_IDENTIFIER forIndexPath:indexPath];
        
        return cell;
    }else if(collectionView.tag == 7){
        
        MLYourlikeCollectionViewCell *cell = (MLYourlikeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:YourlikeCCELL_IDENTIFIER forIndexPath:indexPath];
        
        return cell;
        
    }else{

        MLSecondCollectionViewCell *cell = (MLSecondCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SecondCCELL_IDENTIFIER forIndexPath:indexPath];
        
        return cell;
    }
    
    
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

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
        return UIEdgeInsetsMake(0, 0, CollectionViewCellMargin, 0);
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
    
        return 5.f;
    }
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 7) {
        return 5.f;
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

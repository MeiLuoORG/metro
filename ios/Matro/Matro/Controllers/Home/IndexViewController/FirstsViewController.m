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
    
}

@end

@implementation FirstsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _index_0_height = 464.0f/750.0f*SIZE_WIDTH;

    _index_1_height = 80+5;//160.0f/750.0f*SIZE_WIDTH+5;

    _index_2_height = 40+170+5;//40+350.0/750.0f*SIZE_WIDTH;

    _index_3_height = 440.0/750.0f*SIZE_WIDTH;

    _index_4_height = 300.0/750.0f*SIZE_WIDTH+5;

    _index_5_height = 40+780.0/750.0f*SIZE_WIDTH+175+5;

    _index_6_height = 40+720.0/750.0f*SIZE_WIDTH+5;

    _index_7_height = 40+750.0/750.0f*SIZE_WIDTH+5;

    _index_8_height = 40.0+(460.0/750.0*SIZE_WIDTH+5)*4;

    //self.lunXianImageARR = [[NSMutableArray alloc]init];
    self.lunXianImageARR = [[NSMutableArray alloc]initWithObjects:@"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a4224ee4dd.jpg_1125X696-50.jpg",
                   @"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a42075eeae.jpg_1125X696-50.jpg",
                   @"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a41ed8ef5a.jpg_1125X696-50.jpg",
                   nil];
    self.index_2_GoodARR = [[NSMutableArray alloc]init];
    [self loadIndex_0_View];
    [self loadIndex_1_view];
    [self loadIndex_2_view];
    
    [self createTableviewML];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(index3ButtonLeftAction:) name:Index3Button_LEFT_NOTICIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(index3ButtonRightAction:) name:Index3Button_RIGHT_NOTICIFICATION object:nil];
}

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
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.lunXianImageARR[i]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
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
    self.index_2_CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, SIZE_WIDTH,140.0) collectionViewLayout:layout];
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
    return 7;
}

- (MLSecondCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = SecondCCELL_IDENTIFIER;
    
    MLSecondCollectionViewCell * cell = (MLSecondCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
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
    float width = 100.0f;
    float height = 140.0f;
    CGSize size = CGSizeMake(width, height);
    return size;
    
}
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了第几个：%ld",indexPath.row);
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

}
-(void)index3ButtonRightAction:(id)sender{
    NSLog(@"右边");

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
            [cell addSubview:self.lunXianView];
            
            
        }
            break;
        case 1:{
            cell.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
            [cell addSubview:self.fourButtonView];
        }
            
            break;
        case 2:{
            self.index_2_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
            self.index_2_titleLabel.text = @"新品惠";
            self.index_2_titleLabel.font = [UIFont systemFontOfSize:12.0f];
            self.index_2_titleLabel.textColor = [HFSUtility hexStringToColor:Main_textNormalBackgroundColor];
            self.index_2_titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(130, 10, 100, 20)];
            [self.index_2_titleImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
            [cell addSubview:self.index_2_titleLabel];
            [cell addSubview:self.index_2_titleImageView];
            
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
            
        }
            
            break;
        case 4:{
            self.index_4_imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, _index_4_height-5)];
            self.index_4_imageview.userInteractionEnabled = YES;
            [self.index_4_imageview sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:PlaceholderImage_Name]];
            
            [cell addSubview:self.index_4_imageview];
        }
            
            break;
        case 5:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH,_index_5_height)];
            view1.backgroundColor = [UIColor orangeColor];
            [cell addSubview:view1];
        }
            
            break;
        case 6:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH,_index_6_height)];
            view1.backgroundColor = [UIColor redColor];
            [cell addSubview:view1];
        }
            
            break;
        case 7:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH,_index_7_height)];
            view1.backgroundColor = [UIColor orangeColor];
            [cell addSubview:view1];
        }
            
            break;
        case 8:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, _index_8_height)];
            view1.backgroundColor = [UIColor redColor];
            [cell addSubview:view1];
        }
            
            break;

        default:
            break;
    }

    return cell;;
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

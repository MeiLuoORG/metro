//
//  MLPingjiaListViewController.m
//  Matro
//
//  Created by Matro on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPingjiaListViewController.h"
#import "MLCommentTableViewCell.h"
#import "MJRefresh.h"
#import "MLpingjiaImgViewCell.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "UIView+BlankPage.h"
#import "UIImageView+WebCache.h"
#import "MLpingjiaViewController.h"
#import "CommonHeader.h"
#import "MLGoodsComViewController.h"
#import "MLProductComDetailViewController.h"
#define CollectionViewCellMargin 10.0f//间隔10
@interface MLPingjiaListViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *commentList;//评价列表
    NSMutableArray *imageList;
    NSString *picstr;
    float Hight;
    
}
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *commentCollectionView;
@property (nonatomic,assign)PingjiaType type;


@end

static NSInteger pageIndex = 1;
static float height;
@implementation MLPingjiaListViewController
- (instancetype)initWithPingjiaType:(PingjiaType)PingjiaType{
    if (self = [super init]) {
        self.type = PingjiaType;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.title isEqualToString:@"全部"]) {
        self.type = PingjiaType_All;
    }else if ([self.title isEqualToString:@"好评"]){
        self.type = PingjiaType_Haoping;
    }else if ([self.title isEqualToString:@"中评"]){
        self.type = PingjiaType_Zhongping;
    }else if([self.title isEqualToString:@"差评"]){
        self.type = PingjiaType_Chaping;
    }else if([self.title isEqualToString:@"晒图"]){
        self.type = PingjiaType_Shaitu;
    }
    
    switch (self.type) {
        case PingjiaType_All:
            self.title = @"全部";
            break;
        case PingjiaType_Haoping:
            self.title = @"好评";
            break;
        case PingjiaType_Zhongping:
            self.title = @"中评";
            break;
        case PingjiaType_Chaping:
            self.title = @"差评";
            break;
        case PingjiaType_Shaitu:
            self.title = @"晒图";
            break;
        default:
            break;
    }
    
    
    self.commentCollectionView.hidden = YES;
    self.commentTableView.backgroundColor = RGBA(245, 245, 245, 1);
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    commentList = [NSMutableArray array];
    imageList = [NSMutableArray array];
    
     self.commentTableView.header = [self refreshHeaderWith: self.commentTableView];
    
     self.commentTableView.footer = [self loadMoreDataFooterWith: self.commentTableView];
    
    /*
    self.commentTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        
        [self loadData];
        [self.commentTableView reloadData];
    }];
    self.commentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
        [self.commentTableView reloadData];
    }];
     */
    

    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[MLpingjiaViewController class]]) {
            MLpingjiaViewController *pingjiavc = (MLpingjiaViewController *)vc;
            self.paramDic = pingjiavc.paramDic;
            break;
            
        }
    }
    
    
    [self loadData ];
     [self.commentTableView.header beginRefreshing];
    
}



#pragma mark 获取数据

- (void)loadData{
    
    
    NSLog(@"1111%@",_paramDic);

    NSString *url;
    switch (self.type) {
        case PingjiaType_All:
        {
            url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment&method=list&id=%@&page_size=10&cur_page=%@&type=&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.paramDic[@"id"],[NSNumber numberWithInteger:pageIndex],vCFBundleShortVersionStr];
        }
            break;
        case PingjiaType_Haoping:
        {
            url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment&method=list&id=%@&page_size=10&cur_page=%@&type=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.paramDic[@"id"],[NSNumber numberWithInteger:pageIndex],@"good",vCFBundleShortVersionStr];
        }
            break;
        case PingjiaType_Zhongping:
        {
            url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment&method=list&id=%@&page_size=10&cur_page=%@&type=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.paramDic[@"id"],[NSNumber numberWithInteger:pageIndex],@"normal",vCFBundleShortVersionStr];
        }
            break;
        case PingjiaType_Chaping:
        {
            url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment&method=list&id=%@&page_size=10&cur_page=%@&type=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.paramDic[@"id"],[NSNumber numberWithInteger:pageIndex],@"bad",vCFBundleShortVersionStr];
        }
            break;
        case PingjiaType_Shaitu:
        {
            url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment&method=list&id=%@&page_size=10&cur_page=%@&type=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,self.paramDic[@"id"],[NSNumber numberWithInteger:pageIndex],@"picture",vCFBundleShortVersionStr];
        }
            break;
        default:
            break;
    }
    
    [[HFSServiceClient sharedJSONClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.commentTableView.header endRefreshing];
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"responseObject===%@",responseObject);
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
           commentList = data[@"list"];
            
            NSNumber *count = data[@"count"];
            if ([count isEqualToNumber:@0] ) {
                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.commentTableView.footer;
                footer.stateLabel.text = @"没有更多了";
                [self.commentTableView.footer endRefreshing];
                return ;
            }
            
            if (commentList.count>0) {
                pageIndex ++;
                
            }
            [self.commentTableView reloadData];
        }
        
        [self.view configBlankPage:EaseBlankPageTypePingjia hasData:(commentList.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"还没有评价");
        };
            
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.commentTableView.header endRefreshing];
        
         
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return commentList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MLCommentTableViewCell" ;
    MLCommentTableViewCell *cell = (MLCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.imageHead.layer.cornerRadius = 14.f;
    cell.imageHead.layer.masksToBounds = YES;
    if (indexPath.row >commentList.count) {
        return nil;
    }
    NSDictionary *tempDic = commentList[indexPath.row];
    NSNumber *star = tempDic[@"stars"];
    UIImage *image1 = [UIImage imageNamed:@"Star_big2"];
    
    
    
    if (star.intValue == 0) {
        
        cell.star1.image = image1;
        cell.star2.image = image1;
        cell.star3.image = image1;
        cell.star4.image = image1;
        cell.star5.image = image1;
    }else if (star.intValue == 1){
        
        cell.star2.image = image1;
        cell.star3.image = image1;
        cell.star4.image = image1;
        cell.star5.image = image1;
        
    }else if (star.intValue == 2){
        
        cell.star3.image = image1;
        cell.star4.image = image1;
        cell.star5.image = image1;
        
    }else if (star.intValue == 3){
        
        cell.star4.image = image1;
        cell.star5.image = image1;
        
    }else if (star.intValue == 4){
        
        cell.star5.image = image1;
        
    }else if (star.intValue == 5){
        
        
    }
    
    
    cell.userName.text = tempDic[@"user"];
    cell.timeLab.text = tempDic[@"uptime"];
    cell.pingjiaLab.text = tempDic[@"con"];
    imageList  = tempDic[@"photos"];
    NSString *imgstr = tempDic[@"logo"];
    if (![imgstr isKindOfClass:[NSNull class]]) {
        [cell.imageHead sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    }
    else{
        cell.imageHead.image = [UIImage imageNamed:@"icon_default"];
    }
    picstr = tempDic[@"pic"];
   
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    
    CGSize theSize = [cell.pingjiaLab.text boundingRectWithSize:CGSizeMake(MAIN_SCREEN_WIDTH, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    
    height = theSize.height;
    NSLog(@"%f",height);
    if (imageList.count == 0) {
        Hight = 100 + height;
        cell.collectH.constant = 0;
    }
    else{
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin + 1 * 5))/5);
        float height1 = width;
        Hight = height1 + 100 +height;
    }
    cell.imgCollectionView.delegate = self;
    cell.imgCollectionView.dataSource = self;
    cell.imgCollectionView.tag = indexPath.section;
    [cell.imgCollectionView registerNib:[UINib  nibWithNibName:@"MLpingjiaImgViewCell" bundle:nil] forCellWithReuseIdentifier:@"MLpingjiaImgViewCell"];
    return cell;
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return Hight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = commentList[indexPath.row];
    
    MLProductComDetailViewController *vc = [[MLProductComDetailViewController alloc]init];
    vc.comment_id = dic[@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageList.count;
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLpingjiaImgViewCell *cell = (MLpingjiaImgViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MLpingjiaImgViewCell" forIndexPath:indexPath];
    NSDictionary *tempDic = imageList[indexPath.row];
    NSString *src = tempDic[@"src"];
    
    if (![src isKindOfClass:[NSNull class]]) {
        
       [cell.imageCell sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        
    }else{
        cell.imageCell.image = [UIImage imageNamed:@"icon_default"];
        
    }
    
    
    return cell;
    
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*4))/5);
    float height = width;
    return CGSizeMake(width, height);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 5, 0);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}


-(MJRefreshNormalHeader *)refreshHeaderWith:(UIScrollView *)scrollView {
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [self loadData];
        [scrollView.header endRefreshing];
    }];
    
    return refreshHeader;
}

-(MJRefreshAutoNormalFooter *)loadMoreDataFooterWith:(UIScrollView *)scrollView {
    MJRefreshAutoNormalFooter *loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
        [scrollView.footer endRefreshing];
    }];
    
    return loadMoreFooter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

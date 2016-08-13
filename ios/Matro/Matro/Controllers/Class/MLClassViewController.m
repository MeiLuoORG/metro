//
//  MLClassViewController.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLClassViewController.h"
#import "MLGoodsListViewController.h"
#import "MLSearchViewController.h"

#import "AppDelegate.h"
#import "MLClass.h"
#import "MLSecondClass.h"
#import "MLClassInfo.h"
#import "MLClassHeader.h"
#import "MLClassTableViewCell.h"
#import "MLClassCollectionViewCell.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "UIImage+HeinQi.h"
#import "UIColor+HeinQi.h"
 
#import "YAScrollSegmentControl.h"//顶部第一大类选项按钮
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJExtension.h"
#import "MLClassInfo.h"

#import "SYQRCodeViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLPinpaiCollectionViewCell.h"
#import "PinPaiSPListViewController.h"
#import "MLPPCollectionViewCell.h"
#import "MLShopInfoViewController.h"
#import "CommonHeader.h"
#import "MLHttpManager.h"
#import "MLActiveWebViewController.h"

#define HEADER_IDENTIFIER @"MLClassHeader"//第二大类用tableview的header来显示
#define CCELL_IDENTIFIER @"MLClassCollectionViewCell"//第三大类用tableview的cell来显示

#define CollectionViewCellMargin 5.0f//间隔10

@interface MLClassViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,YAScrollSegmentControlDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SearchDelegate>{
    
    NSArray *_classTitleArray;//第一大类数组
    NSArray *actimageArr;//第一大类大图片字典
    NSMutableArray *_classSecondArray;//第二大类数组
    
    NSMutableDictionary *brandDic;
    NSMutableArray *brandArr;//品牌
    
    UITextField *searchText;
    UIImageView *imageview;
    
}

@property (strong, nonatomic) UISearchBar *searchBar;


@property (strong, nonatomic) IBOutlet YAScrollSegmentControl *topScrollSegmentControl;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@end

@implementation MLClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"分类";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"260E00"]}];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sousuozhou"] style:UIBarButtonItemStylePlain target:self action:@selector(handleSingleTap:)];
    brandArr = [NSMutableArray array];
    brandDic = [NSMutableDictionary dictionary];
    _classSecondArray = [NSMutableArray array];
    actimageArr = [NSArray array];

    [_tableView registerNib:[UINib nibWithNibName:@"MLClassHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    
    //头部类别设置
    _topScrollSegmentControl.backgroundColor = [UIColor whiteColor];
    _topScrollSegmentControl.tintColor = [UIColor whiteColor];
    [_topScrollSegmentControl setTitleColor:[UIColor colorWithHexString:@"C29F8C"] forState:UIControlStateSelected];
    [_topScrollSegmentControl setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateNormal];
//    [_topScrollSegmentControl setBackgroundImage:[UIImage imageNamed:@"sel_type_g2"] forState:UIControlStateSelected];
//    [_topScrollSegmentControl setBackgroundImage:[UIImage imageNamed:@"sel_type_w"]  forState:UIControlStateNormal];
    
    _topScrollSegmentControl.delegate = self;
    [_topScrollSegmentControl setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    _topScrollSegmentControl.selectedIndex = 0;
    
    float height = MAIN_SCREEN_WIDTH*8/15;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, height)];
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, height)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:imageview];
    self.tableView.tableHeaderView = view;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerAction:)];
    [view addGestureRecognizer:singleTap];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(nothing)];
    self.navigationItem.leftBarButtonItem = left;
    
   // [self loadAllClass];
}

-(void)nothing{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showLoadingView];
    [self loadAllClass];
    
}



//分类点击事件（大图片）
-(void)headerAction:(UITapGestureRecognizer *)tap{
    NSLog(@"actimageDic1111===%@",actimageArr);
    if (actimageArr.count >0) {
        NSDictionary *tempDic = actimageArr[0];
        
        NSString *ggtype = tempDic[@"ggtype"];
        NSString *ggv = tempDic[@"ggv"];
        if ([ggtype isEqualToString:@"1"]) {
            MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
            vc.paramDic = @{@"id":ggv};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([ggtype isEqualToString:@"2"]){
            
            PinPaiSPListViewController *vc =[[PinPaiSPListViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            vc.searchString = ggv;
            vc.title = @"品牌馆";
            [self.navigationController pushViewController:vc animated:NO];
            self.hidesBottomBarWhenPushed = NO;
            
        }else if([ggtype isEqualToString:@"3"]){
            
            MLGoodsListViewController * vc = [[MLGoodsListViewController alloc]init];
            vc.filterParam = @{@"flid":ggv};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([ggtype isEqualToString:@"4"]){
            
            MLActiveWebViewController *vc = [[MLActiveWebViewController alloc]init];
            vc.title = @"热门活动";
            vc.link = ggv;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([ggtype isEqualToString:@"5"]){
            
            MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
            NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            vc.store_link = [NSString stringWithFormat:@"%@/store?sid=%@&uid=%@",DianPuURL_URLString,ggv,phone];
            vc.uid = ggv;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([ggtype isEqualToString:@"9"]){
            //频道
//            MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
//            NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
//            vc.store_link = [NSString stringWithFormat:@"%@/store?sid=%@&uid=%@",DianPuURL_URLString,ggv,phone];
//            vc.uid = ggv;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else{
        
        
    }
    
  
}

//搜索器的UIView的点击事件
-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    
    MLSearchViewController *searchViewController = [[MLSearchViewController alloc]init];
    searchViewController.delegate = self;
    searchViewController.activeViewController = self;
    MLNavigationController *searchNavigationViewController = [[MLNavigationController alloc]initWithRootViewController:searchViewController];
    
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    [rootViewController addChildViewController:searchNavigationViewController];
    [rootViewController.view addSubview:searchNavigationViewController.view];
    
    
}


#pragma mark- 获取一级分类
- (void)loadAllClass {

    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=category&s=list&method=top&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"category" s:@"list" success:^(id responseObject){
        [self closeLoadingView];
        NSLog(@"responseObject===%@",responseObject);
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *arr = responseObject[@"data"][@"ret"];
        
        _classTitleArray = [MTLJSONAdapter modelsOfClass:[MLClass class] fromJSONArray:arr error:nil];
        NSMutableArray *tempTitleArr = [NSMutableArray array];
        for (MLClass *title in _classTitleArray) {
            [tempTitleArr addObject:title.MC];
        }
        //标题按钮的使用的仅仅是大类里面的标题，在点击事件里面还是要用MLClass的
        _topScrollSegmentControl.buttons = tempTitleArr;
        
    } failure:^(NSError *error){
        [self closeLoadingView];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
    
    }];
    
    
    
}
#pragma mark- 获取二级、三级分类
- (void)loadDateSubClass:(NSInteger)index{

    MLClass *title = _classTitleArray[index];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=category&s=list&method=next&code=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,title.CODE,vCFBundleShortVersionStr];

    
    [MLHttpManager get:urlStr params:nil m:@"category" s:@"list" success:^(id responseObject){
        [self closeLoadingView];
        NSLog(@"responseObject===%@",responseObject);
        [_classSecondArray removeAllObjects];
        
        actimageArr = responseObject[@"data"][@"advertise"];
        if (actimageArr .count >0) {
            NSDictionary *actimageDic = actimageArr[0];
            NSString *imgurl = actimageDic[@"imgurl"];
            if (![imgurl isKindOfClass:[NSNull class]]) {
                [imageview sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
            }else{
                
                imageview.image = [UIImage imageNamed:@"icon_default"];
            }
            
        }else{
            
            imageview.image = [UIImage imageNamed:@"icon_default"];
        }
        
        NSArray *arr = responseObject[@"data"][@"ret"];
        brandDic = responseObject[@"data"][@"brandtitle"];
        brandArr = responseObject[@"data"][@"brand"];
        _classSecondArray = [[MTLJSONAdapter modelsOfClass:[MLSecondClass class] fromJSONArray:arr error:nil] mutableCopy];
        [MLSecondClass mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"SecondaryClassification_Ggw":[MLClassInfo class]};
        }];
        
        [_classSecondArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLSecondClass *model = (MLSecondClass*)obj;
            
            if (!model.SecondaryClassification_Ggw || [model.SecondaryClassification_Ggw isKindOfClass:[NSNull class]]) {
                [_classSecondArray removeObject:model];
            }
        }];

        [_tableView reloadData];
        
    } failure:^(NSError *error){
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    
}


#pragma mark- UITableViewDataSource And UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (brandArr.count > 0) {
        return _classSecondArray.count+1;//当前一级分类下有多少个二级分类就返回多少个Sections 并且加上一个品牌的section
    }
     
    return _classSecondArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    
    if (section == _classSecondArray.count ) {
        if (brandArr.count >0) {
            return 1;
        }else{
            return 0;
        }
        
    }else{
        
        MLSecondClass * secondClass = _classSecondArray[section];
        
        if (secondClass.ThreeClassificationList.count == 0 || !secondClass.ThreeClassificationList || [secondClass.ThreeClassificationList isEqual:[NSNull null]]) {
            return 0;
        }
    }
    
    return 1;//二级分下只有一个cell，当二级分类下没有三级分类的时候返回0
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLClassTableViewCell";
    
    MLClassTableViewCell *cell = (MLClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    //三级分类的cell上是个collectionView，用tag==section来判断是哪一个collectionView
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
   
    cell.collectionView.tag = indexPath.section;
    if (indexPath.section == _classSecondArray.count) {
        
         [cell.collectionView registerNib:[UINib  nibWithNibName:@"MLPPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MLPPCollectionViewCell"];
    }
    
    [cell.collectionView registerNib:[UINib  nibWithNibName:@"MLClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CCELL_IDENTIFIER];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _classSecondArray.count) {
        long int count = brandArr.count;
        NSLog(@"count===%ld",count);
        long int i;
        if (count%4==0) {
            i = count / 4;
        }else{
            i = (count+3) / 4;
        }
  
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
        float height = width;
        return (height*i + 5*i + 10);
    }
    
   // MLSecondClass * secondClass = _classSecondArray[tableView.tag];
    MLSecondClass * secondClass = _classSecondArray[indexPath.section];
    long int count = secondClass.ThreeClassificationList.count;
    NSLog(@"count===%ld",count);
    long int i;
    
    if (count%4==0) {
        i = count / 4;
    }else{
        i = (count+3) / 4;
    }

    float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
    float height = width ;
    return (height*i + 5*i + 5);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MLClassHeader *headerView = [[MLClassHeader alloc]initWithReuseIdentifier:HEADER_IDENTIFIER];
//    MLSecondClass *headerClass = _classSecondArray[section];
//    MLClassInfo *headerinfo = headerClass.SecondaryClassification_Ggw;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerAction:)];
//    tap.cancelsTouchesInView = NO;
//    tap.delegate = self;
//    headerView.secondTitle.tag = section;
//    [headerView.secondTitle addGestureRecognizer:tap];
    
    
//    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-20 * (CGFloat)M_PI / 180), 1, 0, 0);
    
    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize:14 ]. fontName matrix :matrix];
    UIFont *font = [ UIFont fontWithDescriptor :desc size :14];
    
    headerView.commentLab.text = @"|RECOMMEND ";
    headerView.commentLab.font = font;

    if (section == _classSecondArray.count) {
        if (![brandDic isKindOfClass:[NSString class]] && ![brandDic[@"mc"]isEqualToString:@""]) {
            
            headerView.secondTitle.text = [NSString stringWithFormat:@"%@",brandDic[@"mc"]];
        }else{
        
            headerView.secondTitle.text = @"推荐品牌";
        }

    }else{
        
        MLSecondClass *headerClass = _classSecondArray[section];
        MLClassInfo *headerinfo = headerClass.SecondaryClassification_Ggw;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerAction:)];
        tap.cancelsTouchesInView = NO;
        tap.delegate = self;
        headerView.secondTitle.tag = section;
        [headerView.secondTitle addGestureRecognizer:tap];
        headerView.secondTitle.text = [NSString stringWithFormat:@"%@",headerinfo.mc];
    }
    
    
    return headerView;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    
    view.backgroundColor = RGBA(245, 245, 245, 1);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 5.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    if (collectionView.tag == _classSecondArray.count) {
        return  brandArr.count;
    }
    
    MLSecondClass * secondClass = _classSecondArray[collectionView.tag];
    
    return secondClass.ThreeClassificationList.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView.tag == _classSecondArray.count) {
        
        MLPPCollectionViewCell *cell = (MLPPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MLPPCollectionViewCell" forIndexPath:indexPath];
        
        NSDictionary *tempdic = brandArr[indexPath.row];
        
        if (![tempdic[@"imgurl"] isKindOfClass:[NSNull class]]) {
            [cell.ppImg sd_setImageWithURL:[NSURL URLWithString:tempdic[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
            
        }
        return cell;
    }
    MLClassCollectionViewCell *cell = (MLClassCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CCELL_IDENTIFIER forIndexPath:indexPath];
    MLSecondClass * secondClass = _classSecondArray[collectionView.tag];
    NSDictionary *dic = secondClass.ThreeClassificationList[indexPath.row];
    MLClassInfo *iteminfo = [MTLJSONAdapter modelOfClass:[MLClassInfo class] fromJSONDictionary:dic error:nil];
    
    
    cell.CNameLabel.text = iteminfo.mc;
    if (![iteminfo.imgurl isKindOfClass:[NSNull class]]) {
        [cell.classImageView sd_setImageWithURL:[NSURL URLWithString:iteminfo.imgurl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        
    }
    
    return cell;
     
}




#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == _classSecondArray.count) {
        PinPaiSPListViewController * vc = [[PinPaiSPListViewController alloc]init];
        NSDictionary *dic = brandArr[indexPath.row];
        vc.title = dic[@"name"];
        vc.searchString = dic[@"brand_id"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else{
    
    MLGoodsListViewController * vc = [[MLGoodsListViewController alloc]init];
    MLSecondClass * secondClass = _classSecondArray[collectionView.tag];
    NSDictionary *dic = secondClass.ThreeClassificationList[indexPath.row];
    NSLog(@"dic===%@",dic);
        
//    NSString  *selectTitle = dic[@"mc"];
//    vc.filterParam = @{@"keyword":selectTitle};
        
    NSString *catid = dic[@"catid"];
    vc.filterParam = @{@"flid":catid};
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
   
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == _classSecondArray.count) {
        
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
        float height = width;
        return CGSizeMake(width, height);
    }
    else{
        float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
        float height = width;
        return CGSizeMake(width, height);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == _classSecondArray.count) {
        
        return UIEdgeInsetsMake(CollectionViewCellMargin, CollectionViewCellMargin*3, CollectionViewCellMargin*2, CollectionViewCellMargin*3);
    }
    return UIEdgeInsetsMake(CollectionViewCellMargin, CollectionViewCellMargin, CollectionViewCellMargin, CollectionViewCellMargin);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == _classSecondArray.count) {
        
        return 5.0f;
    }
    return 0.f;
}


#pragma mark- YAScrollSegmentControlDelegate
- (void)didSelectItemAtIndex:(NSInteger)index;{

    NSLog(@"%@",_topScrollSegmentControl.buttons[index]);
    /*
    for (MLClass *title in _classTitleArray) {
        if ([_topScrollSegmentControl.buttons[index] isEqualToString:title.MC]) {
            [imageview sd_setImageWithURL:[NSURL URLWithString:title.imgurl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
            
        }
    }
    */
    //根据所选的一级大类来刷新二三级大类
    [self showLoadingView];
    [self loadDateSubClass:index];
    
}

#pragma mark-SearchDelegate

-(void)SearchText:(NSString *)text{
    MLGoodsListViewController *vc =[[MLGoodsListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = text;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark扫描二维码
- (void)scanning{
    //开始捕获
    //扫描二维码
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        NSLog(@"%@",qrString);
        
        //扫除结果后处理字符串
        //        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        [aqrvc dismissViewControllerAnimated:NO completion:^{
            if (qrString.length>0) {
                NSString *JMSP_ID = [self jiexi:@"JMSP_ID" webaddress:qrString];
                NSString *ZCSP = nil;
                if([qrString rangeOfString:@"products_hwg"].location !=NSNotFound)//_roaldSearchText
                {
                    ZCSP = @"5";
                }
                else
                {
                    ZCSP = @"0";
                }
                if (JMSP_ID.length>0&&ZCSP) {
                    MLGoodsDetailsViewController *detailVc = [[MLGoodsDetailsViewController alloc]init];
                    detailVc.paramDic = @{@"JMSP_ID":JMSP_ID?:@"",@"ZCSP":ZCSP};
                    detailVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detailVc animated:YES];
                }
                                
            }
            
        }];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){//扫描失败
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){//取消扫描
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
    
}


-(NSString *)jiexi:(NSString *)CS webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    // NSString *webaddress=@"http://www.baidu.com/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        //NSRange matchRange = [match range];
        //NSString *tagString = [webaddress substringWithRange:matchRange];  // 整个匹配串
        //        NSRange r1 = [match rangeAtIndex:1];
        //        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {    // 由时分组1可能没有找到相应的匹配，用这种办法来判断
        //            //NSString *tagName = [webaddress substringWithRange:r1];  // 分组1所对应的串
        //            return @"";
        //        }
        
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        //    NSLog(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return @"";
}

@end

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


#define HEADER_IDENTIFIER @"MLClassHeader"//第二大类用tableview的header来显示
#define CCELL_IDENTIFIER @"MLClassCollectionViewCell"//第三大类用tableview的cell来显示

#define CollectionViewCellMargin 5.0f//间隔10

@interface MLClassViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,YAScrollSegmentControlDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SearchDelegate>{
    
    NSArray *_classTitleArray;//第一大类数组
    NSMutableArray *_classSecondArray;//第二大类数组
    UITextField *searchText;
}

@property (strong, nonatomic) UISearchBar *searchBar;


@property (strong, nonatomic) IBOutlet YAScrollSegmentControl *topScrollSegmentControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MLClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _tableView.estimatedRowHeight = 44.0;
//    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shouyesaoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(scanning)];
    
    //添加边框和提示
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)] ;
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Magnifying-Class"]];
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(imgW + 4, 2, textW, H)];
    searchText.enabled = NO;
    [frameView addSubview:searchImg];
    [frameView addSubview:searchText];
    searchImg.frame = CGRectMake(4 , 4, imgW, imgW);
    searchText.frame = CGRectMake(imgW + 6, 4, textW, H);
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"寻找你想要的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
//    searchText.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
//    searchText.layer.borderWidth = 1.f;
//    searchText.layer.masksToBounds = YES;
    
    self.navigationItem.titleView = frameView;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [frameView addGestureRecognizer:singleTap];

    
    [_tableView registerNib:[UINib nibWithNibName:@"MLClassHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    
    //头部类别设置
    _topScrollSegmentControl.backgroundColor = [UIColor whiteColor];
    _topScrollSegmentControl.tintColor = [UIColor whiteColor];
    [_topScrollSegmentControl setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateSelected];
    [_topScrollSegmentControl setTitleColor:[UIColor colorWithHexString:@"0E0E0E"] forState:UIControlStateNormal];
    [_topScrollSegmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor] size:self.view.frame.size] forState:UIControlStateSelected];
    [_topScrollSegmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.view.frame.size] forState:UIControlStateNormal];
    _topScrollSegmentControl.delegate = self;
    [_topScrollSegmentControl setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
//    _topScrollSegmentControl.buttons = @[@"推荐",@"母婴",@"食品保健",@"家居厨具",@"玩具"];
    _topScrollSegmentControl.selectedIndex = 0;
    
    [self loadAllClass];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}



//分类点击事件（大图片）
-(void)headerAction:(UITapGestureRecognizer *)tap{
    MLGoodsListViewController * vc = [[MLGoodsListViewController alloc]init];
    
    
    MLSecondClass *headerClass = _classSecondArray[tap.view.tag];
    
    
    NSArray *array = [headerClass.SecondaryClassification_Ggw.MC componentsSeparatedByString:@"="];
    
    if(array.count>0){
        NSString *result = [array lastObject];
        result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        vc.filterParam = @{@"spflcode":result};
        
    }
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ajax/app/index.ashx?op=allfirst&webframecode=0303",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = (NSArray *)responseObject;
        _classTitleArray = [MTLJSONAdapter modelsOfClass:[MLClass class] fromJSONArray:arr error:nil];
        NSMutableArray *tempTitleArr = [NSMutableArray array];
        for (MLClass *title in _classTitleArray) {
            [tempTitleArr addObject:title.MC];
        }
        //标题按钮的使用的仅仅是大类里面的标题，在点击事件里面还是要用 MLClass 的
        _topScrollSegmentControl.buttons = tempTitleArr;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}
#pragma mark- 获取二级、三级分类
- (void)loadDateSubClass:(NSInteger)index{
    
    MLClass *title = _classTitleArray[index];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ajax/app/index.ashx?op=child&webframecode=%@",SERVICE_GETBASE_URL,title.CODE];
    
   HFSServiceClient  *_client = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
    
    _client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",  @"text/plain",nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
    if (!accessToken) {
        accessToken = @"";
    }
    [_client.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [_client GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [_classSecondArray removeAllObjects];
        
//        _classSecondArray = [[MTLJSONAdapter modelsOfClass:[MLSecondClass class] fromJSONArray:arr error:nil] mutableCopy];
        
        [MLSecondClass mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"SecondaryClassification_Ggw":[MLClassInfo class]};
        }];
        
        _classSecondArray = [MLSecondClass mj_objectArrayWithKeyValuesArray:responseObject];
        [_classSecondArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLSecondClass *model = (MLSecondClass*)obj;
           
            if (!model.SecondaryClassification_Ggw || [model.SecondaryClassification_Ggw isKindOfClass:[NSNull class]]) {
                [_classSecondArray removeObject:model];
            }
        }];
        
        
            
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}


#pragma mark- UITableViewDataSource And UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _classSecondArray.count;//当前一级分类下有多少个二级分类就返回多少个Sections
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    MLSecondClass * secondClass = _classSecondArray[section];
    if (secondClass.ThreeClassificationList.count == 0 || !secondClass.ThreeClassificationList || [secondClass.ThreeClassificationList isEqual:[NSNull null]]) {
        return 0;
    }
    return 1;//二级分下只有一个cell，当二级分类下没有三级分类的时候返回0
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLClassTableViewCell" ;
    MLClassTableViewCell *cell = (MLClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    //三级分类的cell上是个collectionView，用tag==section来判断是哪一个collectionView
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    cell.collectionView.tag = indexPath.section;
    
    [cell.collectionView registerNib:[UINib  nibWithNibName:@"MLClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CCELL_IDENTIFIER];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin + 1 * 5))/4);
    float height = width * 3/2;
    return height + 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
       return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MLClassHeader *headerView = [[MLClassHeader alloc]initWithReuseIdentifier:HEADER_IDENTIFIER];
    MLSecondClass *headerClass = _classSecondArray[section];
    MLClassInfo *headerinfo = headerClass.SecondaryClassification_Ggw;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerAction:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    headerView.headerImageView.tag = section;
    [headerView.headerImageView addGestureRecognizer:tap];
    [headerView.headerImageView sd_setImageWithURL:headerinfo.SRC placeholderImage:PLACEHOLDER_IMAGE];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    MLSecondClass * secondClass = _classSecondArray[collectionView.tag];
    return secondClass.ThreeClassificationList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLClassCollectionViewCell *cell = (MLClassCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CCELL_IDENTIFIER forIndexPath:indexPath];
    
    MLSecondClass * secondClass = _classSecondArray[collectionView.tag];
    NSDictionary *dic = secondClass.ThreeClassificationList[indexPath.row];
    MLClassInfo *iteminfo = [MTLJSONAdapter modelOfClass:[MLClassInfo class] fromJSONDictionary:[dic[@"Ggw"] firstObject] error:nil];
    //名字有间隔，用@"|"来分隔了中文名和英文名
    NSArray *nameArray = [iteminfo.TITLE componentsSeparatedByString:@"|"];
    NSLog(@"%@",nameArray);
    cell.CNameLabel.text = nameArray[0] ? nameArray[0] : @" ";
    if (nameArray.count>1) {
        cell.ENameLabel.text = nameArray[1] ? nameArray[1] : @" ";

    }
    [cell.classImageView sd_setImageWithURL:iteminfo.SRC placeholderImage:PLACEHOLDER_IMAGE];
    
    return cell;
}




#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLGoodsListViewController * vc = [[MLGoodsListViewController alloc]init];
    MLSecondClass * secondClass = _classSecondArray[collectionView.tag];
    NSDictionary *dic = secondClass.ThreeClassificationList[indexPath.row];
    NSArray *array = [dic objectForKey:@"Ggw"];
    NSDictionary *resultDic = [array firstObject];
    
    
    NSString *spfl = [resultDic objectForKey:@"MC"];
    
    NSArray *strArr = [spfl componentsSeparatedByString:@"="];
    if(strArr.count>0){
        NSString *result = [strArr lastObject];
        result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        vc.filterParam = @{@"spflcode":result?:@""};
        NSLog(@"vc.filterParam++++%@;result值为：%@",vc.filterParam,result);
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (((MAIN_SCREEN_WIDTH)  - (CollectionViewCellMargin*10))/4);
    float height = width * 3/2;
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(CollectionViewCellMargin, CollectionViewCellMargin, CollectionViewCellMargin, 0);
}


#pragma mark- YAScrollSegmentControlDelegate
- (void)didSelectItemAtIndex:(NSInteger)index{

    NSLog(@"%@",_topScrollSegmentControl.buttons[index]);
    
    //根据所选的一级大类来刷新二三级大类
    [self loadDateSubClass:index];
}

#pragma mark-SearchDelegate
-(void)SearchText:(NSString *)text{
    NSLog(@"%@",text);
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
        //[aqrvc dismissViewControllerAnimated:NO completion:nil];
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

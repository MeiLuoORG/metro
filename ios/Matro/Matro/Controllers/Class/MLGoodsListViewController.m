//
//  MLGoodsListViewController.m
//  Matro
//
//  Created by NN on 16/3/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsListViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLSXView.h"

#import "HFSProductTableViewCell.h"
#import "HFSProductCollectionViewCell.h"

#import "HFSConstants.h"
#import "UIButton+HeinQi.h"
#import "UIColor+HeinQi.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MLClassInfo.h"
#import "UIImageView+WebCache.h"

#import "MJRefresh.h"
#import "SearchHistory.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MLSearchViewController.h"
#import "AppDelegate.h"
#import "CommonHeader.h"
#import "MLHttpManager.h"

#define SEARCH_PAGE_SIZE @10
#define HFSProductTableViewCellIdentifier @"HFSProductTableViewCellIdentifier"
#define HFSProductCollectionViewCellIdentifier @"HFSProductCollectionViewCellIdentifier"
#define CollectionViewCellMargin 5.0f

@interface MLGoodsListViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,NNSXDelegate,UITextFieldDelegate,UISearchBarDelegate,SearchDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *_productList;//当前商品列表的原数组，collectionView和tableView都共用
    BOOL _isCardView;//判断是否当前显示的是tableView还是collectionView
    
    UIControl * _blackControl;//显示分类筛选的时候黑底背景
    MLSXView * _sxView;//分类筛选的视图
    UITextField *searchText;
    NSDictionary *filterparamDic;
    NSManagedObjectContext *_context;
}
@property (strong, nonatomic) IBOutlet UIButton *xiaoliangButton;//销量排序
@property (strong, nonatomic) IBOutlet UIButton *jiageButtton;//价格排序
@property (strong, nonatomic) IBOutlet UIButton *shaixuanButton;//筛选
@property (strong, nonatomic) IBOutlet UIButton *changeButton;//更改显示方式，列表、卡片
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *blankView;
@end

static NSInteger page = 1;

@implementation MLGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.blankView.hidden = YES;
    _productList = [[NSMutableArray alloc]init];
    
    _isCardView = NO;//起始默认显示列表式
    
    [_tableView registerNib:[UINib nibWithNibName:@"HFSProductTableViewCell" bundle:nil] forCellReuseIdentifier:HFSProductTableViewCellIdentifier];
    [_tableView setTableFooterView:[[UIView alloc]init]];
    [_collectionView registerNib:[UINib  nibWithNibName:@"HFSProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HFSProductCollectionViewCellIdentifier];

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableView.header endRefreshing];
        
        [_tableView reloadData];
        
    }];
    
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_collectionView.header endRefreshing];
       
        [_collectionView reloadData];
        
    }];
    
    _tableView.footer = [self loadMoreDataFooterWith:_tableView];
    _collectionView.footer = [self loadMoreDataFooterWith:_collectionView];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self reloadData];
    [self goodsListUI];
    if (_filterParam) {
        [self getGoodsFromClass];
    }
    if (_searchString) {
        [self getGoodsList];
    }
     _context = [NSManagedObjectContext MR_defaultContext];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
 
    MLSearchViewController *searchViewController = [[MLSearchViewController alloc]init];
    searchViewController.delegate = self;
    searchViewController.activeViewController = self;
    //[searchViewController.delegate SearchText:textField.text];
    searchViewController.searchDic = @{@"keyWord":textField.text};
    MLNavigationController *searchNavigationViewController = [[MLNavigationController alloc]initWithRootViewController:searchViewController];
    
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    [rootViewController addChildViewController:searchNavigationViewController];
    [rootViewController.view addSubview:searchNavigationViewController.view];
    
}

-(void)getGoodsFromClass
{
    
    [self getGoodsList];

}



#pragma mark 搜索关键字获取数据
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)goodsListUI{
    
    //添加边框和提示
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)];
    frameView.layer.cornerRadius = 4.f;
    frameView.layer.masksToBounds = YES;
    frameView.backgroundColor = [UIColor whiteColor];
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW -20;
    
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuozhou"]];
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(6, 4, textW, H)];
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.delegate = self;
    [frameView addSubview:searchImg];
    [frameView addSubview:searchText];
    
    
    
    searchImg.frame = CGRectMake(textW - 45-15 , 4, imgW, imgW);
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"寻找你想要的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    if (_searchString) {
        searchText.text = _searchString;
    }
    
    self.navigationItem.titleView = frameView;

    
    [_jiageButtton changeImageAndTitle];
    
    _jiageButtton.imageView.hidden = YES;
    
    [_shaixuanButton changeImageAndTitle];
    
    [_xiaoliangButton setTitleColor:[UIColor colorWithHexString:@"F1653E"] forState:UIControlStateSelected];
    
    [_changeButton setImage:[UIImage imageNamed:@"liebiao1"] forState:UIControlStateNormal];
    [_changeButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateSelected];
    
    _blackControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH ,MAIN_SCREEN_HEIGHT)];
    _blackControl.backgroundColor = [UIColor blackColor];
    _blackControl.alpha = 0.4;
    _blackControl.hidden = YES;
    [_blackControl addTarget:self action:@selector(endEditingAction) forControlEvents:UIControlEventTouchUpInside];
 
    _sxView = [[MLSXView alloc]init];
    _sxView.frame = CGRectMake(MAIN_SCREEN_WIDTH, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
    _sxView.delegate = self;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackControl];
    [currentWindow addSubview:_sxView];
    
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [frameView addGestureRecognizer:singleTap];
    
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [_sxView addGestureRecognizer:tapGestureRecognizer];
    
    if (![self.currentFLname isEqualToString:@""]) {
        [_sxView postFenLeiName:self.currentFLname];
    }
    
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

-(void)nothingAction{
    
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


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_sxView endEditing:YES];
    
}

#pragma mark-SearchDelegate
-(void)SearchText:(NSString *)text{
    //    NSLog(@"%@",text);
    MLGoodsListViewController *vc =[[MLGoodsListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = text;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark- 刷新相关
//根据_isCardView来判断是_tableView还是_collectionView开始刷新
-(void)reloadData {
    if (_isCardView) {
        page = 1;
        [_collectionView reloadData];
        //[self getGoodsList];
//        [_collectionView.header beginRefreshing];
    } else {
        page = 1;
        //[self getGoodsList];
      //  [_tableView.header beginRefreshing];
        
    }
}
-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}
#warning 先加分页index，之后还会加别的  关键字搜索
- (void)getGoodsList{
    
    //    http://bbctest.matrojp.com/api.php?m=product&s=list&key=水&startprice=0&endprice=60&pageindex=1&pagesize=20&listtype=1&searchType=1&orderby=amount&sort=desc&brand_id=1853
    //    key : 产品搜索关键字
    //    startprice:价格区间开始值
    //    endprice:价格区间结束值
    //    pageindex: 第几页 (不传值，默认第1页)
    //    pagesize: 每页最大查询条数 (不传值，默认20条)
    //    listtype: 1 仅看有货; 2 促销商品; 3 全球购 (不传值, 即查询所有)
    //    brandid : 品牌id
    //    id: 分类id
    //    searchType:搜索类型  ( 如果有关键字搜索, searchType 是必传参数 , 1  )
    //    orderby: 排序:  amount 销量; clicks 人气 ; time 更新时间; price 价格
    //    sort : 排序方式 : desc 倒序; asc 正序
    //    code :  查询成功 或失败标记  0 标识查询成功 1表示查询失败
    //    data : 返回Json数据集合
    //    ret: 查询品牌结果集 ["商品id","商品名称","预计在多少天后开始发货","进货方式 1=>海外直邮 2=>仓库发货 3=>国内快递","原价","rmb符号", "价格"，"模块名","品牌","产品图",
    //              "公司名称","国家图片","国家名称"]
    //    retcount : 查询结果集条数
    //    sum: 不分页查询总条数
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    
    NSString *listtepy = @"";
    NSString *sort = @"desc";//排列方式
    NSString *orderby = @"amount";//默认销量
    NSString *spflid = @"";//商品分类id
    NSString *jgs = @"";
    NSString *jge = @"";
    NSString *ppid = @"";//品牌id
    NSLog(@"filterparamDic === %@",filterparamDic);
    if (filterparamDic) {
        
        if ([filterparamDic objectForKey:@"listtype"]) {
            listtepy = [filterparamDic objectForKey:@"listtype"];
        }
        
        if ([filterparamDic objectForKey:@"jgs"]) {
            jgs =[filterparamDic objectForKey:@"jgs"];
        }
        if ([filterparamDic objectForKey:@"jge"]) {
            jge =[filterparamDic objectForKey:@"jge"];
        }
        if ([filterparamDic objectForKey:@"orderby"]) {
            orderby =[filterparamDic objectForKey:@"orderby"];
        }
        if ([filterparamDic objectForKey:@"id"]) {
            spflid =[filterparamDic objectForKey:@"id"];
        }
        if ([filterparamDic objectForKey:@"brandid"]) {
            ppid =[filterparamDic objectForKey:@"brandid"];
        }
        if ([filterparamDic objectForKey:@"sort"]) {
            sort =[filterparamDic objectForKey:@"sort"];
        }
        
    }
    NSString *keystr;
    
    if (self.filterParam) {
        NSString *keyword = self.filterParam[@"keyword"]?:@"";
        
        keystr = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (self.filterParam[@"flid"]) {
            spflid  = self.filterParam[@"flid"]?:@"";
        }
    }else{
        keystr = [_searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@/api.php?m=product&s=list&key=%@&startprice=%@&endprice=%@&pageindex=%ld&pagesize=20&listtype=%@&searchType=1&orderby=%@&sort=%@&brand_id=%@&id=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,keystr,jgs,jge,(long)page,listtepy,orderby,sort,ppid,spflid,vCFBundleShortVersionStr];
    NSLog(@"str====%@",str);
    
    
    [MLHttpManager get:str params:nil m:@"product" s:@"list" success:^(id responseObject){
        
        NSLog(@"responseObject ====%@",responseObject);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        NSString *sum = responseObject[@"data"][@"sum"];
        if (sum.floatValue == 0) {
            
            [_productList removeAllObjects];
            self.blankView.hidden  = NO;
            
            [self.tableView reloadData];
            [self.collectionView reloadData];
            self.tableView.footer.hidden = YES;
            self.collectionView.footer.hidden = YES;
            
        }else{
            self.blankView.hidden = YES;
            self.tableView.footer.hidden = NO;
            self.collectionView.footer.hidden = NO;
            
            if (page==1) {
                
                [_productList removeAllObjects];
                
            }
            if (responseObject) {
                NSArray *ary;
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *resdic = responseObject[@"data"];
                    ary = (NSArray *)resdic[@"ret"];
                    
                    
                    NSNumber *count = resdic[@"retcount"];
                    NSLog(@"count====%@",count);
                    if ([count isEqualToNumber:@0] ) {
                        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.footer;
                        MJRefreshAutoNormalFooter *footer1 = (MJRefreshAutoNormalFooter *)self.collectionView.footer;
                        footer.stateLabel.text = @"没有更多了";
                        footer1.stateLabel.text = @"没有更多了";
                        
                        return ;
                    }
                }
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    ary = (NSArray *)responseObject;
                }
                
                if (ary && ary.count>0) {
                    [_productList addObjectsFromArray:ary];
                }

            }
            
            page ++;
            
            [_tableView reloadData];
            [_collectionView reloadData];
            
        }
        //[_hud show:YES];
        //[_hud hide:YES afterDelay:1];
        
    } failure:^( NSError *error){
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        NSLog(@"error===%@",error);
    }];
    
}
-(NSString*)UrlValueEncode:(NSString*)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)str,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}


-(MJRefreshNormalHeader *)refreshHeaderWith:(UIScrollView *)scrollView {
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getGoodsList];
        [scrollView.header endRefreshing];
    }];
    
    return refreshHeader;
}

-(MJRefreshAutoNormalFooter *)loadMoreDataFooterWith:(UIScrollView *)scrollView {
    MJRefreshAutoNormalFooter *loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self getGoodsList];
        [scrollView.footer endRefreshing];
    }];
    
    return loadMoreFooter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endEditingAction{
    [_sxView endEditing:YES];
}

#pragma mark- 功能按钮  销量、价格、筛选、切换

- (IBAction)listButtonAction:(id)sender {
    UIButton *button  = (UIButton * )sender;
    if (!filterparamDic) {
        filterparamDic = [NSMutableDictionary new];
    }
    NSString *typeStr = button.titleLabel.text;
    
    if ([typeStr isEqualToString:@"销量"]) {
        button.selected = !button.selected;
        if (button.selected) {
            
            [_xiaoliangButton setTitleColor:[UIColor colorWithHexString:@"F1653E"] forState:UIControlStateSelected];
            [_jiageButtton setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateNormal];
            [_jiageButtton setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateSelected];
            _jiageButtton.imageView.hidden= YES;
            [filterparamDic setValue:@"amount" forKey:@"orderby"];
            [filterparamDic setValue:@"desc" forKey:@"sort"];
            
        }else{
            
            [_xiaoliangButton setTitleColor:[UIColor colorWithHexString:@"F1653E"] forState:UIControlStateNormal];
            [_jiageButtton setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateNormal];
            [_jiageButtton setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateSelected];
            _jiageButtton.imageView.hidden= YES;
            [filterparamDic setValue:@"amount" forKey:@"orderby"];
            [filterparamDic setValue:@"desc" forKey:@"sort"];
            
        }
        
        page = 1;
        [self getGoodsList];
    }
    else if([typeStr isEqualToString:@"价格"])
    {
        _jiageButtton.imageView.hidden = NO;
        button.selected = !button.selected;
        if (button.selected) {
            [_xiaoliangButton setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateSelected];
            [_jiageButtton setTitleColor:[UIColor colorWithHexString:@"F1653E"] forState:UIControlStateSelected];
            [_jiageButtton setImage:[UIImage imageNamed:@"xiajianSelect"] forState:UIControlStateSelected];
            [filterparamDic setValue:@"price" forKey:@"orderby"];
            [filterparamDic setValue:@"desc" forKey:@"sort"];

        }else{
            [_xiaoliangButton setTitleColor:[UIColor colorWithHexString:@"260E00"] forState:UIControlStateNormal];
            [_jiageButtton setTitleColor:[UIColor colorWithHexString:@"F1653E"] forState:UIControlStateNormal];
            [_jiageButtton setImage:[UIImage imageNamed:@"jgshangjian"] forState:UIControlStateNormal];
            [filterparamDic setValue:@"price" forKey:@"orderby"];
            [filterparamDic setValue:@"asc" forKey:@"sort"];
        }
        page = 1;
        [self getGoodsList];

    }
    else if ([typeStr isEqualToString:@"筛选"]){
        button.selected = !button.selected;
        [UIView animateWithDuration:0.5 animations:^{
            if (_sxView.frame.origin.x == MAIN_SCREEN_WIDTH) {
                _sxView.frame = CGRectMake(60, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
                _blackControl.hidden = NO;
            }else{
                _sxView.frame = CGRectMake(MAIN_SCREEN_WIDTH, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
                _blackControl.hidden = YES;
            }
            if (searchText.text.length >0) {
                _sxView.keywords = searchText.text;
            }
            
            else{
                _sxView.spflCode = _filterParam[@"spflcode"];
            }
            
        }];
    }else{//切换显示
        button.selected = !button.selected;
        if (_isCardView) {
            _tableView.hidden = NO;
            _collectionView.hidden = YES; 
        } else {
            _tableView.hidden = YES;
            _collectionView.hidden = NO;
        }
        _isCardView = !_isCardView;
        [self reloadData];
    }
    
}


#pragma mark - UITableViewDelegate and  UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = RGBA(245, 245, 245, 1);
    return view;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 1.0f;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * view = [[UIView alloc]init];
//    view.backgroundColor = RGBA(245, 245, 245, 1);
//    return view;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *paramdic = _productList[indexPath.section];
    NSLog(@"paramdic ==== %@",paramdic);
    vc.paramDic = paramdic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _productList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HFSProductTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[HFSProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HFSProductTableViewCellIdentifier];
    }
    NSDictionary *tempdic = _productList[indexPath.section];
    if (tempdic) {
        NSString *pic = tempdic[@"pic"];
        if (![pic isKindOfClass:[NSNull class]]) {
            //[cell.productImageView sd_setImageWithURL:[NSURL URLWithString:pic]];
           
            if ([pic hasSuffix:@"webp"]) {
                [cell.productImageView setZLWebPImageWithURLStr:pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                 [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_default"]];
            }
        }else{
            cell.productImageView.image = [UIImage imageNamed:@"icon_default"];
        }
        if (_filterParam) {
           
            NSString *str = tempdic[@"pname"];
            NSString *aastr = @"&amp;";
            if ([str containsString:aastr]) {
                
                NSString * str2 = [str stringByReplacingOccurrencesOfString:aastr withString:@"&"];
                cell.productNameLabel.text = str?:@"";
            }else{
                
                cell.productNameLabel.text = str?:@"";
                
            }
            
            
        }
        else{
        
            NSString *str = tempdic[@"pname"];
            NSString *aastr = @"&amp;";
            if ([str containsString:aastr]) {
                
              NSString * str2 = [str stringByReplacingOccurrencesOfString:aastr withString:@"&"];
                cell.productNameLabel.text = str2?:@"";
                
            }else{
                
                cell.productNameLabel.text = str?:@"";
                
            }
        }
  
        float  originprice= [tempdic[@"promotion_price"] floatValue];
        
        if ( ![tempdic[@"promotion_price"] isKindOfClass:[NSNull class]]) {
            if (originprice == 0.00) {
                cell.cuxiaoPriceLabel.hidden = YES;
                float price = [tempdic[@"price"] floatValue];
                
                NSMutableAttributedString *pricestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",price]];
                
                [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
                [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pricestr.length - 2, 2)];
                
                cell.currentPriceLabel.attributedText = pricestr;
            }
            else{
                cell.cuxiaoPriceLabel.hidden = NO;
                float price = [tempdic[@"price"] floatValue];
                
                NSMutableAttributedString *pricestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",originprice]];
                
                [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
                [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pricestr.length - 2, 2)];
                
                cell.currentPriceLabel.attributedText = pricestr;
                
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

        cell.isShouqing.hidden = YES;
        NSString *amount = tempdic[@"amount"];
        if ([tempdic[@"amount"]isEqual:@0] || amount.floatValue < 0) {
            cell.isShouqing.hidden = NO;
            cell.currentPriceLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            cell.productNameLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        }else{
            
            cell.isShouqing.hidden = YES;
            cell.currentPriceLabel.textColor = [UIColor colorWithHexString:@"F1653E"];
            cell.productNameLabel.textColor = [UIColor colorWithHexString:@"260E00"];
        }
        
    }
    
    return cell;
}

#pragma mark - UICollectionViewDataSource and  UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _productList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFSProductCollectionViewCell *cell = (HFSProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HFSProductCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempdic = _productList[indexPath.row];
    
    NSString *pic = tempdic[@"pic"];
    if (![pic isKindOfClass:[NSNull class]]) {
        
        
        if ([pic hasSuffix:@"webp"]) {
            [cell.productImgview setZLWebPImageWithURLStr:pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [cell.productImgview sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        }
        
    }else{
        cell.productImgview.image = [UIImage imageNamed:@"icon_default"];
    }
    
    if (_filterParam) {
    
        NSString *str = tempdic[@"pname"];
        NSString *aastr = @"&amp;";
        
        if ([str containsString:aastr]) {
            
            NSString * str2 = [str stringByReplacingOccurrencesOfString:aastr withString:@"&"];
            if (str.length <= 12) {
                
                cell.productnameLb.text = str2?:@"";
            }else{
                NSString *namestr = [str substringWithRange:NSMakeRange(0, 12)];
                cell.productnameLb.text = namestr?:@"";
            }
            
        }else{
            
            if (str.length <= 12) {
                
                cell.productnameLb.text = str?:@"";
            }else{
                NSString *namestr = [str substringWithRange:NSMakeRange(0, 12)];
                cell.productnameLb.text = namestr?:@"";
            }
            
        }

    }
    else{
       
        NSString *str = tempdic[@"pname"];
        NSString *aastr = @"&amp;";
        
        if ([str containsString:aastr]) {
            
            NSString * str2 = [str stringByReplacingOccurrencesOfString:aastr withString:@"&"];
            if (str.length <= 11) {
                
                cell.productnameLb.text = str2?:@"";
            }else{
                NSString *namestr = [str substringWithRange:NSMakeRange(0, 12)];
                cell.productnameLb.text = namestr?:@"";
            }
            
        }else{
            
            if (str.length <= 11) {
                
                cell.productnameLb.text = str?:@"";
            }else{
                NSString *namestr = [str substringWithRange:NSMakeRange(0, 12)];
                cell.productnameLb.text = namestr?:@"";
            }
            
        }
 
    }
    
    float  originprice= [tempdic[@"promotion_price"] floatValue];
    
    if ( ![tempdic[@"promotion_price"] isKindOfClass:[NSNull class]]) {
        if (originprice == 0.00) {
            cell.cuxiaoPrice.hidden = YES;
            float price = [tempdic[@"price"] floatValue];
            
            NSMutableAttributedString *pricestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",price]];
            
            [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
            [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pricestr.length - 2, 2)];
            
            cell.priceLb.attributedText = pricestr;
        }
        else{
            cell.cuxiaoPrice.hidden = NO;
            float price = [tempdic[@"price"] floatValue];
            
            NSMutableAttributedString *pricestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",originprice]];
            
            [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
            [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pricestr.length - 2, 2)];
            
            cell.priceLb.attributedText = pricestr;
            
            NSString *Pricestr = [NSString stringWithFormat:@"￥%.2f",price];
            NSAttributedString *attrStr =
            [[NSAttributedString alloc]initWithString:Pricestr
                                           attributes:
             @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
               NSForegroundColorAttributeName:[UIColor grayColor],
               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
               NSStrikethroughColorAttributeName:[UIColor grayColor]}];
            cell.cuxiaoPrice.attributedText=attrStr; //原价要划掉
        }
    }
    
    /*
    float price = [tempdic[@"price"] floatValue];
    
    NSMutableAttributedString *pricestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",price]];
    
    [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pricestr.length - 2, 2)];
    
    cell.priceLb.attributedText = pricestr;
     */

    cell.isShouqing.hidden = YES;
    NSString *amount = tempdic[@"amount"];
    if ([tempdic[@"amount"]isEqual:@0] || amount.floatValue <0) {
        cell.isShouqing.hidden = NO;
        cell.productnameLb.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        cell.priceLb.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    }else{
        
        cell.isShouqing.hidden = YES;
        cell.productnameLb.textColor = [UIColor colorWithHexString:@"260E00"];
        cell.priceLb.textColor = [UIColor colorWithHexString:@"F1653E"];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tempdic = _productList[indexPath.row];
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    vc.paramDic = tempdic;

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (collectionView.bounds.size.width - CollectionViewCellMargin) / 2;
    float height = width / 290 * 408;
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, CollectionViewCellMargin, 0);
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

#pragma mark- NNSXDelegate 筛选后重新call接口
- (void)blackAction:(NSDictionary*)paramdic{
    [UIView animateWithDuration:0.5 animations:^{
        if (_sxView.frame.origin.x == MAIN_SCREEN_WIDTH) {
            _sxView.frame = CGRectMake(60, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
            _blackControl.hidden = NO;
        }else{
            _sxView.frame = CGRectMake(MAIN_SCREEN_WIDTH, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
            _blackControl.hidden = YES;
        }
        _sxView.keywords = searchText.text;
    }];
    filterparamDic = paramdic;
    page = 1;
    
    [self getGoodsList];
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];
    if (aTextfield.text.length>0) {
        if (self.filterParam) {
            self.filterParam = nil;
        }
        _searchString = aTextfield.text;
        page = 1;
        [self getGoodsList];
        [self reloadData];
    }
    
    return YES;
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

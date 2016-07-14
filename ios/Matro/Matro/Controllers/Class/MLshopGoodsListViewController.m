//
//  MLshopGoodsListViewController.m
//  Matro
//
//  Created by Matro on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//
#import "MLshopGoodsListViewController.h"
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
#import "MLshopFLViewController.h"

#define SEARCH_PAGE_SIZE @10
#define HFSProductTableViewCellIdentifier @"HFSProductTableViewCellIdentifier"
#define HFSProductCollectionViewCellIdentifier @"HFSProductCollectionViewCellIdentifier"
#define CollectionViewCellMargin 5.0f

@interface MLshopGoodsListViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,NNSXDelegate,UITextFieldDelegate,UISearchBarDelegate,SearchDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>{
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

static NSInteger page = 0;

@implementation MLshopGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.blankView.hidden = YES;
    _productList = [[NSMutableArray alloc]init];
    
    _isCardView = NO;//起始默认显示列表式
    
    [_tableView registerNib:[UINib nibWithNibName:@"HFSProductTableViewCell" bundle:nil] forCellReuseIdentifier:HFSProductTableViewCellIdentifier];
    [_tableView setTableFooterView:[[UIView alloc]init]];
    [_collectionView registerNib:[UINib  nibWithNibName:@"HFSProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HFSProductCollectionViewCellIdentifier];
    
    _tableView.header = [self refreshHeaderWith:_tableView];
    _collectionView.header = [self refreshHeaderWith:_collectionView];
    
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
/*
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    MLSearchViewController *searchViewController = [[MLSearchViewController alloc]init];
    searchViewController.delegate = self;
    searchViewController.activeViewController = self;
    MLNavigationController *searchNavigationViewController = [[MLNavigationController alloc]initWithRootViewController:searchViewController];
    
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    [rootViewController addChildViewController:searchNavigationViewController];
    [rootViewController.view addSubview:searchNavigationViewController.view];
    
}
*/
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
    
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(6, 4, textW, H)];
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.enablesReturnKeyAutomatically = YES;
    searchText.delegate = self;
    searchText.enabled = YES;
    [frameView addSubview:searchImg];
    [frameView addSubview:searchText];

    searchImg.frame = CGRectMake(textW - 45 - 30 , 4, imgW, imgW);
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"搜索店内的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    /*
    if (_searchString) {
        searchText.text = _searchString;
    }
    */
    
    if (_filterParam) {
        searchText.text = _filterParam[@"keyword"];
    }
    
    self.navigationItem.titleView = frameView;
    
    
    UIButton *sxuanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sxuanBtn.frame = CGRectMake(0, 0, 20, 20);
    [sxuanBtn setBackgroundImage:[UIImage imageNamed:@"fenlei1"] forState:UIControlStateNormal];
    [sxuanBtn addTarget:self action:@selector(actsxuan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sxuanbtnItem = [[UIBarButtonItem alloc]initWithCustomView:sxuanBtn];
    self.navigationItem.rightBarButtonItem = sxuanbtnItem;
    
    [_jiageButtton changeImageAndTitle];
    /*
     [_jiageButtton setImage:[UIImage imageNamed:@"xiajian"] forState:UIControlStateNormal];
     [_jiageButtton setImage:[UIImage imageNamed:@"xiajianSelect"] forState:UIControlStateSelected];
     */
    [_shaixuanButton changeImageAndTitle];
    [_xiaoliangButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
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
    
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [searchText becomeFirstResponder];
    
}
//点击键盘上搜索按钮时
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"%@",textField.text);
    [searchText resignFirstResponder];
    
    _filterParam = @{@"keyword":textField.text};
    
    [_productList removeAllObjects];
    [self getGoodsList];
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
    
    return YES;
}

-(void)actsxuan{
    NSLog(@"11111");
    MLshopFLViewController *vc = [[MLshopFLViewController alloc]init];
    vc.uid = _filterParam[@"uid"];
    [self.navigationController pushViewController:vc animated:YES];
    
}



-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_sxView endEditing:YES];
    
}

#pragma mark- 刷新相关
//根据_isCardView来判断是_tableView还是_collectionView开始刷新
-(void)reloadData {
    if (_isCardView) {
        [_collectionView reloadData];
        [_collectionView.header beginRefreshing];
    } else {
        [_tableView.header beginRefreshing];
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

#warning   关键字搜索
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
    //sum: 不分页查询总条数
    
    NSString *listtepy=@"";
    //NSString *sort=@"";//排列方式
    NSString *orderby =@"amount";//默认销量
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
        
    }
    NSString *keystr;
    
    if (_filterParam) {
        
        NSString *keyword = self.filterParam[@"keyword"];
        keystr = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
    }
    
    NSString *str = [NSString stringWithFormat:@"%@/api.php?m=product&s=list&key=%@&startprice=%@&endprice=%@&pageindex=%ld&pagesize=20&listtype=%@&searchType=1&orderby=%@&sort=desc&brand_id=%@&id=%@&userid=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,keystr,jgs,jge,(long)page,listtepy,orderby,ppid,spflid,_uid,vCFBundleShortVersionStr];
    NSLog(@"str====%@",str);
    
    [[HFSServiceClient sharedJSONClient] GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject ====%@",responseObject);
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
            
            if (page==0) {
                
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
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
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
            
            [_xiaoliangButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [_jiageButtton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [_jiageButtton setImage:[UIImage imageNamed:@"xiajian"] forState:UIControlStateSelected];
            [filterparamDic setValue:@"amount" forKey:@"orderby"];
            
        }else{
            
            [_xiaoliangButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        page = 1;
        [self getGoodsList];
    }
    else if([typeStr isEqualToString:@"价格"])
    {
        button.selected = !button.selected;
        if (button.selected) {
            
            [_jiageButtton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [_jiageButtton setImage:[UIImage imageNamed:@"xiajianSelect"] forState:UIControlStateSelected];
            [_xiaoliangButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [filterparamDic setValue:@"price" forKey:@"orderby"];
            
            
        }else{
            
            [_jiageButtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_jiageButtton setImage:[UIImage imageNamed:@"xiajian"] forState:UIControlStateNormal];
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
            [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        }else{
            cell.productImageView.image = [UIImage imageNamed:@"icon_default"];
        }
        if (_filterParam) {
            
            NSString *str = tempdic[@"pname"];
            
            
            cell.productNameLabel.text = str?:@"";
        }
        else{
            
            NSString *str = tempdic[@"pname"];
            
            cell.productNameLabel.text =str?:@"";
        }
        
        float price = [tempdic[@"price"] floatValue];
        
        NSMutableAttributedString *pricestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",price]];
        
        [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
        [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pricestr.length - 2, 2)];
        
        cell.currentPriceLabel.attributedText = pricestr;
        
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
        
        [cell.productImgview sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        
    }else{
        cell.productImgview.image = [UIImage imageNamed:@"icon_default"];
    }
    
    if (_filterParam) {
        
        NSString *str = tempdic[@"pname"];
        if (str.length <= 12) {
            cell.productnameLb.text = str?:@"";
        }else{
            NSString *namestr = [str substringWithRange:NSMakeRange(0, 12)];
            cell.productnameLb.text = namestr?:@"";
        }
        
        
    }
    else{
        
        NSString *str = tempdic[@"pname"];
        if (str.length <= 11) {
            cell.productnameLb.text = str?:@"";
        }else{
            NSString *namestr = [str substringWithRange:NSMakeRange(0, 11)];
            cell.productnameLb.text = namestr?:@"";
        }
        
        
    }
    
    float price = [tempdic[@"price"] floatValue];
    
    NSMutableAttributedString *pricestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",price]];
    
    [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    [pricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(pricestr.length - 2, 2)];
    
    cell.priceLb.attributedText = pricestr;
    
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
/*
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
*/

@end


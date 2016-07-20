//
//  PinPaiZLViewController.m
//  Matro
//
//  Created by lang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "PinPaiZLViewController.h"
#import "MLHttpManager.h"
@interface PinPaiZLViewController ()

@end

@implementation PinPaiZLViewController{

    UICollectionView * _collectionView;
    
    UITableView * _tableView;
    //collectionView
    NSMutableArray * _pinPaiARR;
    
    UIButton * _indexButton;
    UIButton * _closeButton;
    //tableview
    NSMutableDictionary * _sectionDic;
    NSMutableArray * _sectionPinARR;
    NSMutableArray * _allKeysARR;
    NSMutableArray * _zongARR;
    
    int _currentPageIndex;
}

- (void)backBtnAction{

    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    _pinPaiARR = [[NSMutableArray alloc]init];
    _sectionDic = [[NSMutableDictionary alloc]init];
    _sectionPinARR = [[NSMutableArray alloc]init];
    _allKeysARR = [[NSMutableArray alloc]init];
    _zongARR = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    self.title = @"品牌馆";
    UIButton * fenXiangBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    fenXiangBtn.frame = CGRectMake(0, 0, 22, 22);
    [fenXiangBtn setBackgroundImage:[UIImage imageNamed:@"Share-1"] forState:UIControlStateNormal];
    [fenXiangBtn addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /*
    _messageBadgeView = [[JSBadgeView alloc]initWithParentView:_messageButton alignment:JSBadgeViewAlignmentTopRight];
    _messageBadgeView.badgeText = @"●";
    [_messageBadgeView setBadgeTextColor:[HFSUtility hexStringToColor:Main_textRedBackgroundColor]];
    [_messageBadgeView setBadgeBackgroundColor:[UIColor clearColor]];
    */
    UIBarButtonItem *message = [[UIBarButtonItem alloc]initWithCustomView:fenXiangBtn];
    UIView *s = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 22)];
    
    
    UIBarButtonItem *l = [[UIBarButtonItem alloc]initWithCustomView:s];
    
    
    UIButton * genDuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    genDuoBtn.frame = CGRectMake(0, 0, 22, 22);
    [genDuoBtn setImage:[UIImage imageNamed:@"gengduozl"] forState:UIControlStateNormal];
    genDuoBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 0, 9, 0);
    [genDuoBtn addTarget:self action:@selector(gengDuoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithCustomView:genDuoBtn];
    
    //self.navigationItem.rightBarButtonItems = @[setting,l,message];
    
    
    

    
    [self createCollecttionView];
    [self createTableViews];
    [self loadSearchButton];
    [self loadDataWithPageIndex:1 withPagesize:15];
    [self loadCloseButton];
}



- (void)createCollecttionView{
    _currentPageIndex = 1;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动方向
    layout.itemSize = CGSizeMake(SIZE_WIDTH /3.0f, SIZE_WIDTH /3.0f);
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 1.0f;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"ZLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectViewCell"];
    [self.view addSubview:_collectionView];
    
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        [self headerShuaXin];
    }];
    _collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerShuaXin];
    }];
//close-2
}

- (void)headerShuaXin{
    _currentPageIndex = 1;
    [_pinPaiARR removeAllObjects];
    [self loadDataWithPageIndex:1 withPagesize:15];
}
- (void)footerShuaXin{
    _currentPageIndex++;
    [self loadDataWithPageIndex:_currentPageIndex withPagesize:15];
}

- (void)createTableViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(SIZE_WIDTH, 0, SIZE_WIDTH, SIZE_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    //_tableView.backgroundColor = [HFSUtility hexStringToColor:@"260e00"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    //改变索引的颜色
    _tableView.sectionIndexColor = [UIColor whiteColor];
    //改变索引选中的背景颜色
    _tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:38.0/255.0f green:14.0f/255.0f blue:0.0 alpha:0.95];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    //加载数据
    [self loadTableViewData];
   
}
//加载 tableView的 数据
- (void)loadTableViewData{
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * urlStr = [NSString stringWithFormat:@"%@/api.php?m=brand&s=brand&method=list&pageindex=%d&pagesize=%d&type=0",ZHOULU_ML_BASE_URLString,1,20000];
    
    [MLHttpManager get:urlStr params:nil m:@"brand" s:@"brand" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary * result = (NSDictionary *)responseObject;
        NSLog(@"请求品牌馆：%@",result);
        NSDictionary * dataDic = result[@"data"];
        NSString * sumStr = dataDic[@"sum"];
        if (![sumStr isEqualToString:@"0"]) {
            NSArray * brandARR = dataDic[@"brand"];
            if (brandARR.count > 0 ) {
                for (NSDictionary * brandDic in brandARR) {
                    //[PinPaiModelZl modelWithDictionary:brandDic error:nil];
                    PinPaiModelZl * pinPaiModel = [[PinPaiModelZl alloc]init];
                    pinPaiModel.id = brandDic[@"id"];
                    pinPaiModel.char_index = brandDic[@"char_index"];
                    pinPaiModel.name = brandDic[@"name"];
                    pinPaiModel.ishot = brandDic[@"ishot"];
                    pinPaiModel.logo = brandDic[@"logo"];
                    
                    [_zongARR addObject:pinPaiModel];
                    
                }
                //数组排序
                [self arrPaiXuWith:_zongARR];
            }
        }
        else{
            _hud  = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"没有品牌信息";
            [_hud hide:YES afterDelay:1];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _hud  = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
    }];
    
    /*
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSDictionary * result = (NSDictionary *)responseObject;
        NSLog(@"请求品牌馆：%@",result);
        NSDictionary * dataDic = result[@"data"];
        NSString * sumStr = dataDic[@"sum"];
        if (![sumStr isEqualToString:@"0"]) {
            NSArray * brandARR = dataDic[@"brand"];
            if (brandARR.count > 0 ) {
                for (NSDictionary * brandDic in brandARR) {
                    //[PinPaiModelZl modelWithDictionary:brandDic error:nil];
                    PinPaiModelZl * pinPaiModel = [[PinPaiModelZl alloc]init];
                    pinPaiModel.id = brandDic[@"id"];
                    pinPaiModel.char_index = brandDic[@"char_index"];
                    pinPaiModel.name = brandDic[@"name"];
                    pinPaiModel.ishot = brandDic[@"ishot"];
                    pinPaiModel.logo = brandDic[@"logo"];
                    
                    [_zongARR addObject:pinPaiModel];
                    
                }
                //数组排序
                [self arrPaiXuWith:_zongARR];
            }
        }
        else{
            _hud  = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"没有品牌信息";
            [_hud hide:YES afterDelay:2];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _hud  = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
    }];

   */
}
//数组排序
- (void)arrPaiXuWith:(NSMutableArray *)zongArr{

    NSMutableArray * teshuArr = [[NSMutableArray alloc]init];
    for (PinPaiModelZl * model in zongArr) {
        model.char_index = model.char_index.uppercaseString;
        NSString * char_index = model.char_index;
        //数组是否包含某一对象
        //[dataArray indexOfObject:object] != NSNotFound
        if (![ZhengZePanDuan checkEnglishZiMu:char_index]) {
            [teshuArr addObject:model];
            [_sectionDic setObject:teshuArr forKey:@"#"];
        }
        else{
            if ([_sectionDic.allKeys containsObject:char_index]) {
                NSMutableArray * arr2 = _sectionDic[char_index];
                [arr2 addObject:model];
            }
            else{
                    NSMutableArray * arr = [[NSMutableArray alloc]init];
                    [arr addObject:model];
                    [_sectionDic setObject:arr forKey:char_index];

            }

        
        }
        
        
        
    }
    
    //首字母排序
    NSArray *keysArray = [_sectionDic allKeys];
    _allKeysARR = [NSMutableArray arrayWithArray:[keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }]];
    for (NSString *categoryId in _allKeysARR) {
        NSLog(@"字母排序结果：%@",categoryId);
        /*
        if ([categoryId isEqualToString:@"#"]) {
            [_allKeysARR removeObject:categoryId];
            [_allKeysARR insertObject:@"#" atIndex:_allKeysARR.count-1];
        }
        */
        //NSLog(@"[dict objectForKey:categoryId] === %@",[_sectionDic objectForKey:categoryId]);
    }
    
    [_tableView reloadData];
}



#pragma mark TableViewDelegate 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * key = [_allKeysARR objectAtIndex:section];
    NSArray * arr = _sectionDic[key];
    NSInteger count = arr.count;
    return count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allKeysARR.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"customTableViewcellid";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    /*
    PinPaiModelZl * pinPaiModel = [_pinPaiARR objectAtIndex:indexPath.row];
    cell.textLabel.text = pinPaiModel.name;
    cell.textLabel.textColor = [UIColor whiteColor];
     */
    /*
    NSString *attr = [NSString stringWithFormat:@"<font  size = \"13\">合计：<color value = \"#FF4E26\">￥%.2f</><font  size = \"11\"><color value = \"#999999\"> 共%li件，不含运费</></></>",allPrice,(long)goodsCount];
    cartFoot.detailLabel.attributedText = [attr createAttributedString];
    */
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSString * key = [_allKeysARR objectAtIndex:indexPath.section];
    NSArray * arr = _sectionDic[key];
    PinPaiModelZl * model = [arr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.name;
    
    
    cell.backgroundColor = [UIColor colorWithRed:38.0/255.0f green:14.0f/255.0f blue:0.0 alpha:0.95];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40.0f)];
    bkView.backgroundColor = [UIColor colorWithRed:38.0/255.0f green:14.0f/255.0f blue:0.0 alpha:0.95];
    
    UILabel * lael = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, 40, 30)];
    lael.text = @"A";
    lael.font = [UIFont systemFontOfSize:24.0f];
    lael.textColor = [UIColor whiteColor];
    [bkView addSubview:lael];
    
    lael.text = [_allKeysARR objectAtIndex:section];
    
    
    
    if (section == 0) {

    }
    
    return bkView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40.0f)];
    view.backgroundColor = [UIColor colorWithRed:38.0/255.0f green:14.0f/255.0f blue:0.0 alpha:0.95];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几个：%ld",indexPath.row);
    NSString * key = [_allKeysARR objectAtIndex:indexPath.section];
    NSArray * arr = _sectionDic[key];
    PinPaiModelZl * model = [arr objectAtIndex:indexPath.row];

    PinPaiSPListViewController *vc =[[PinPaiSPListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = model.id;
    vc.title = model.name;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = YES;
}

//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _allKeysARR;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    NSLog(@"%@-%ld",title,index);
    
    for(NSString *character in _allKeysARR)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}

#pragma end TableViewDelegate  代理犯法结束


- (void)loadSearchButton{
    _indexButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_indexButton setFrame:CGRectMake(SIZE_WIDTH-43, 8, 35, 35)];
    [_indexButton setBackgroundColor:[HFSUtility hexStringToColor:Main_textNormalBackgroundColor]];
    _indexButton.layer.cornerRadius = _indexButton.frame.size.width/2.0f;
    _indexButton.layer.masksToBounds = YES;
    [_indexButton setTitle:@"A-Z" forState:UIControlStateNormal];
    [_indexButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _indexButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_indexButton];
    
    _indexButton.hidden = YES;
}

- (void)loadCloseButton{

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setFrame:CGRectMake(SIZE_WIDTH-48, 15, 25, 25)];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"close-2"] forState:UIControlStateNormal];
    //[_closeButton setImage:[UIImage imageNamed:@"close-2"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.hidden = YES;
    [self.view addSubview:_closeButton];
    
}

- (void)searchButtonAction:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3f animations:^{
        _tableView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-64);
    } completion:^(BOOL finished) {
        _indexButton.hidden = YES;
        _closeButton.hidden = NO;
    }];

}

- (void)closeButtonAction:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3f animations:^{
        _tableView.frame  = CGRectMake(SIZE_WIDTH, 0, SIZE_WIDTH, SIZE_HEIGHT-64);
    } completion:^(BOOL finished) {
        _closeButton.hidden = YES;
        _indexButton.hidden = NO;
    }];
    //[_zongARR removeAllObjects];
}



- (void)loadDataWithPageIndex:(int) pageIndex withPagesize:(int) pageSize{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    /*
     HFSServiceClient
     client_type=[android|ios]
     语言的力量  11:45:15
     app_version=1.0
     */
        NSString * urlStr = [NSString stringWithFormat:@"%@/api.php?m=brand&s=brand&method=list&pageindex=%d&pagesize=%d&type=1&client_type=ios&app_version=%@",ZHOULU_ML_BASE_URLString,pageIndex,pageSize,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"brand" s:@"brand" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        
        NSDictionary * result = (NSDictionary *)responseObject;
        NSLog(@"请求品牌馆：%@",result);
        NSDictionary * dataDic = result[@"data"];
        NSString * sumStr = dataDic[@"sum"];
        if (![sumStr isEqualToString:@"0"]) {
            NSArray * brandARR = dataDic[@"brand"];
            if (brandARR.count > 0 ) {
                for (NSDictionary * brandDic in brandARR) {
                    //[PinPaiModelZl modelWithDictionary:brandDic error:nil];
                    PinPaiModelZl * pinPaiModel = [[PinPaiModelZl alloc]init];
                    pinPaiModel.id = brandDic[@"id"];
                    pinPaiModel.char_index = brandDic[@"char_index"];
                    pinPaiModel.name = brandDic[@"name"];
                    pinPaiModel.ishot = brandDic[@"ishot"];
                    pinPaiModel.logo = brandDic[@"logo"];
                    [_pinPaiARR addObject:pinPaiModel];
                    
                }
                _indexButton.hidden = NO;
                [_collectionView reloadData];
                
            }
            
            
        }
        else{
            _hud  = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"没有品牌信息";
            [_hud hide:YES afterDelay:2];
            
        }
    } failure:^(NSError *error) {
        _hud  = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"没有品牌信息";
        [_hud hide:YES afterDelay:1];
    }];
    
    /*
    
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        
        NSDictionary * result = (NSDictionary *)responseObject;
        NSLog(@"请求品牌馆：%@",result);
        NSDictionary * dataDic = result[@"data"];
        NSString * sumStr = dataDic[@"sum"];
        if (![sumStr isEqualToString:@"0"]) {
            NSArray * brandARR = dataDic[@"brand"];
            if (brandARR.count > 0 ) {
                for (NSDictionary * brandDic in brandARR) {
                    //[PinPaiModelZl modelWithDictionary:brandDic error:nil];
                    PinPaiModelZl * pinPaiModel = [[PinPaiModelZl alloc]init];
                    pinPaiModel.id = brandDic[@"id"];
                    pinPaiModel.char_index = brandDic[@"char_index"];
                    pinPaiModel.name = brandDic[@"name"];
                    pinPaiModel.ishot = brandDic[@"ishot"];
                    pinPaiModel.logo = brandDic[@"logo"];
                    [_pinPaiARR addObject:pinPaiModel];
                    
                }
                _indexButton.hidden = NO;
                [_collectionView reloadData];
                
            }
            
            
        }
        else{
            _hud  = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"没有品牌信息";
            [_hud hide:YES afterDelay:2];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _hud  = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
    }];
     */
    
    /*
    [[HFSServiceClient sharedClient] POST:BindCard_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
    }];
*/
}

- (NSString *)urlWithPageindex:(int)index withPageSize:(int)size{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api.php?m=brand&s=brand&method=list&pageindex=%d&pagesize=%d",ZHOULU_ML_BASE_URLString,index,size];
    return urlStr;

}


- (void)shareButtonAction:(UIButton *)sender{


}

- (void)gengDuoButtonAction:(UIButton *)sender{



}
//放回 卡片数量
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _pinPaiARR.count;
}

- (ZLCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"CustomCollectViewCell";
    
    ZLCollectionViewCell * cell = (ZLCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    //UICollectionViewCell * cell2 = [collectionView cellForItemAtIndexPath:indexPath];

    PinPaiModelZl * model = [_pinPaiARR objectAtIndex:indexPath.row];
    
    //NSURL * url = [NSURL URLWithString:@"http://61.155.212.169/img/SPXSM/o_1a6kr95qe19jmg057qc10m5169g5_M.jpg"];
    
    NSURL * url = [NSURL URLWithString:model.logo];
    
    [cell.imageViewzl sd_setImageWithURL:url placeholderImage:PLACEHOLDER_IMAGE];
    
    /*
    [cell.spImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"login_title"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    cell.spNameLabel.text = @"金螳螂建筑装饰有限公司电子商务";
    cell.jiaGeInfoLabel.text = @"￥13649.9";
     
     */
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = (SIZE_WIDTH)/3.0f-1.0f;
    float height = (SIZE_WIDTH)/3.0-1.0f;
    CGSize size = CGSizeMake(width, height);
    return size;
    
}
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了第几个：%ld",indexPath.row);
    PinPaiModelZl * model = [_pinPaiARR objectAtIndex:indexPath.row];
     PinPaiSPListViewController *vc =[[PinPaiSPListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = model.id;
    vc.title = model.name;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = YES;
    
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

//
//  PinPaiZLViewController.m
//  Matro
//
//  Created by lang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "PinPaiZLViewController.h"

@interface PinPaiZLViewController ()

@end

@implementation PinPaiZLViewController{

    UICollectionView * _collectionView;
    
    UITableView * _tableView;
    
    NSMutableArray * _pinPaiARR;
    
    UIButton * _indexButton;
    
    NSMutableDictionary * _sectionDic;
    NSMutableArray * _sectionPinARR;
    NSMutableArray * _allKeysARR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pinPaiARR = [[NSMutableArray alloc]init];
    _sectionDic = [[NSMutableDictionary alloc]init];
    _sectionPinARR = [[NSMutableArray alloc]init];
    _allKeysARR = [[NSMutableArray alloc]init];
    
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
    genDuoBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 0, 7, 0);
    [genDuoBtn addTarget:self action:@selector(gengDuoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithCustomView:genDuoBtn];
    
    self.navigationItem.rightBarButtonItems = @[setting,l,message];
    
    
    

    
    [self createCollecttionView];
    //[self createTableViews];
    [self loadSearchButton];
    [self loadData];
}

/*
 //首字母排序
 NSArray *keysArray = [dict allKeys];
 NSArray *resultArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
 
 return [obj1 compare:obj2 options:NSNumericSearch];
 }];
 for (NSString *categoryId in resultArray) {
 
 ⋯⋯
 NSLog(@"[dict objectForKey:categoryId] === %@",[dict objectForKey:categoryId]);
 }
 
 */

- (void)createCollecttionView{
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
        
    }];
    _collectionView.footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        
    }];

}

- (void)createTableViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    //_tableView.backgroundColor = [HFSUtility hexStringToColor:@"260e00"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];

}

#pragma mark TableViewDelegate 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
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
    return bkView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40.0f)];
    view.backgroundColor = [UIColor colorWithRed:38.0/255.0f green:14.0f/255.0f blue:0.0 alpha:0.95];
    
    return view;
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

- (void)searchButtonAction:(UIButton *)sender{



}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary * ret = @{@"method":@"list"};
    [MLHttpManager get:PinPaiGuanList_URLString params:ret m:@"brand" s:@"brand" success:^(id responseObject) {
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
                [_tableView reloadData];
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
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _hud  = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
        
    }];

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

    NSURL * url = [NSURL URLWithString:@"http://61.155.212.169/img/SPXSM/o_1a6kr95qe19jmg057qc10m5169g5_M.jpg"];
    
    [cell.imageViewzl sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"login-left"]];
    
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

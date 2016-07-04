//
//  MLShopCartViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopCartViewController.h"
#import "masonry.h"
#import "HFSConstants.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "MLShopCartCollectionViewCell.h"
#import "HFSServiceClient.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "HFSServiceClient.h"
#import "MLShopingCartlistModel.h"
#import "MLLikeHeadCollectionReusableView.h"
#import "MLCartFootCollectionReusableView.h"
#import "MLCartHeadCollectionReusableView.h"
#import "MLGoodsLikeCollectionViewCell.h"
#import "MLCheckBoxButton.h"
#import "UIView+BlankPage.h"
#import "MLLoginViewController.h"
#import "NSString+GONMarkup.h"
#import "MBProgressHUD+Add.h"
#import "MLShopCartMoreCell.h"
#import "MLGuessLikeModel.h"
#import "MLGoodsDetailsViewController.h"
#import "MLShopCartFootView.h"
#import "MLHttpManager.h"
#import "LingQuYouHuiQuanView.h"
#import "MLCommitOrderViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "OffLlineShopCart.h"
#import "CompanyInfo.h"
#import "MLOffLineShopCart.h"




@interface MLShopCartViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CPStepperDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *likeArray;
@property (nonatomic,strong)UIView *loginView;
@property (nonatomic,strong)MLShopingCartlistModel *shopCart;
@property (nonatomic,strong)MLShopCartFootView *footView;
@property (nonatomic,strong)LingQuYouHuiQuanView *lingQuQuanView;
@property (nonatomic,strong)NSMutableArray *offlineCart;
@property (nonatomic,assign)BOOL isLogin;



@end

static float allPrice = 0;
static NSInteger goodsCount;
static NSInteger pageIndex = 0;

@implementation MLShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    self.navigationItem.leftBarButtonItem = nil;
    _loginView = ({
        UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
        headView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"登录后，同步电脑和手机购物袋中的商品。";
        [headView addSubview:label];
        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:RGBA(174, 142, 93, 1)];
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:loginBtn];
        loginBtn.layer.masksToBounds = YES;
        loginBtn.layer.cornerRadius = 3.f;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.left.mas_equalTo(headView).offset(10);
            make.right.mas_equalTo(loginBtn).offset(-10);
        }];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headView).offset(8);
            make.bottom.mas_equalTo(headView).offset(-8);
            make.right.mas_equalTo(headView).offset(-10);
            make.width.mas_equalTo(70);
        }];
        [self.view addSubview:headView];
        headView;
    });

    
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = RGBA(245, 245, 245, 1);
        [collectionView registerNib:[UINib nibWithNibName:@"MLShopCartCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kShopCartCollectionViewCell];
        [collectionView registerNib:[UINib nibWithNibName:@"MLGoodsLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGoodsLikeCollectionViewCell];
                [self.view addSubview:collectionView];
        [collectionView registerNib:[UINib nibWithNibName:@"MLLikeHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLikeHeadCollectionReusableView];
        [collectionView registerNib:[UINib nibWithNibName:@"MLCartHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCartHeadCollectionReusableView];
//        [collectionView registerNib:[UINib nibWithNibName:@"MLCartFootCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCartFootCollectionReusableView];
        [collectionView registerNib:[UINib nibWithNibName:@"MLShopCartMoreCell" bundle:nil] forCellWithReuseIdentifier:@"MoreCell"];
        collectionView;
    });
    
    _footView = ({
        MLShopCartFootView *footView = [MLShopCartFootView footView];
        [footView.checkBox addTarget:self action:@selector(selectAllGoods:) forControlEvents:UIControlEventTouchUpInside];
        [footView.clearingBtn addTarget:self action:@selector(clearingAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:footView];
        footView;
    });
    
    
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(8);
        make.height.mas_equalTo(45);
    }];

    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginView.mas_bottom).offset(8);
        make.left.right.bottom.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
    
//    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self getDataSource];
//    }];
    
    [self configBlankPage];
    [self ctreateYOUHUIQuanView];
    
}




#pragma end mark


//领取优惠券视图
- (void)ctreateYOUHUIQuanView{
    
    __weak typeof (self) weakSelf = self;
    self.lingQuQuanView = [[LingQuYouHuiQuanView alloc]initWithFrame:CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT)];
    self.lingQuQuanView.quanARR = [[NSMutableArray alloc]init];
    [self.lingQuQuanView createView];
    [self.lingQuQuanView setHideBlockAction:^(BOOL success) {
        //查询 用户已经领取的优惠券
//        [weakSelf chaXunYiLingQuQuanList];
        
        [weakSelf.tabBarController.tabBar setHidden:NO];
        [UIView animateWithDuration:0.2f animations:^{
            weakSelf.lingQuQuanView.frame = CGRectMake(0, SIZE_HEIGHT, SIZE_WIDTH, SIZE_HEIGHT);
        } completion:^(BOOL finished) {
            [weakSelf.lingQuQuanView.quanARR removeAllObjects];
        }];
        
    }];
    [self.lingQuQuanView selectQuanBlockAction:^(BOOL success, YouHuiQuanModel *ret) {
        if (ret) {
            
        }
    }];
    
    [self.view addSubview:self.lingQuQuanView];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString  *loginid = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERID];
    [self.likeArray removeAllObjects];
    [self.offlineCart removeAllObjects];
    [self.collectionView reloadData];
    if (loginid) { //已登录情况
        self.isLogin = YES;
        NSArray *tmp = [OffLlineShopCart MR_findAll];
        if (tmp.count > 0) {
            for (OffLlineShopCart *cart in tmp) {
                [cart MR_deleteEntity];
            }
        }
 
        NSArray *cpAry = [CompanyInfo MR_findAll];
        if (cpAry.count > 0) {
            for (CompanyInfo *cp in cpAry) {
                [cp MR_deleteEntity];
            }
        }
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        [self getDataSource];
    }
    else{ //未登录情况
        self.isLogin = NO;
        NSArray *allCart = [CompanyInfo MR_findAll];
        NSMutableArray *tmp = [NSMutableArray array];
        for (CompanyInfo *cp in allCart) {
            MLOffLineShopCart *ofCart = [[MLOffLineShopCart alloc]init];
            ofCart.cpInfo = cp;
            [tmp addObject:ofCart];
        }
        self.offlineCart = nil;
        self.offlineCart = tmp;
        if (self.offlineCart.count > 0) {
            [self guessYourLike];
        }
        [self.collectionView reloadData];
    }
    [self configBlankPage];
    self.loginView.hidden = self.isLogin;
    [self countAllPrice];
}

- (void)getDataSource{
    
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=index",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"product" s:@"cart" success:^(id responseObject) {
        [self.collectionView.header endRefreshing];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqual:@0]) {
            self.shopCart = [MLShopingCartlistModel mj_objectWithKeyValues:result[@"data"][@"cart_list"]];
            [self countAllPrice];
            [self.collectionView reloadData];
            if (self.shopCart.cart.count > 0) {
                [self guessYourLike];
            }
            [self configBlankPage];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    

    
}

- (void)configBlankPage{
    __weak typeof(self) weakself = self;
    [self.view configBlankPage:EaseBlankPageTypeGouWuDai hasData:(self.isLogin? self.shopCart.cart.count>0:self.offlineCart.count>0)];
    self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType curType){
        [weakself.tabBarController setSelectedIndex:0];
    };
    
    if (self.shopCart.cart.count >0||self.offlineCart.count>0){ //如果有数据就显示 foot
        self.footView.hidden = NO;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.isLogin? self.view:self.loginView.mas_bottom).offset(8);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.footView.mas_top);
        }];
    }else{ //没数据就不显示
        self.footView.hidden = YES;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.isLogin? self.view:self.loginView.mas_bottom).offset(8);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }

}


#pragma mark -- UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isLogin) {
        if (section == self.shopCart.cart.count) {
            return self.likeArray.count;
        }
        else{
            MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:section];
            if (cart.isMore && !cart.isOpen) {
                return 3;
            }
            return cart.prolist.count;
        }

    }else{
        if (section == self.offlineCart.count) {
            return self.likeArray.count;
        }
        else{
            MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:section];
            if (cart.isMore && !cart.isOpen) {
                return 3;
            }
            return cart.goodsArray.count;
        }
    }
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //如果是购物车里面有东西就显示猜你喜欢
    if (self.isLogin) {
        return  self.shopCart.cart.count > 0?self.shopCart.cart.count + 1:0;
    }else{
        return self.offlineCart.count;
    }
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLogin) {
        if (indexPath.section == self.shopCart.cart.count) {
            MLGoodsLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsLikeCollectionViewCell forIndexPath:indexPath];
            MLGuessLikeModel *model = [self.likeArray objectAtIndex:indexPath.row];
            cell.likeModel = model;
            return cell;
        }
        else{
            MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:indexPath.section];
            if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
                MLShopCartMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreCell" forIndexPath:indexPath];
                [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",cart.prolist.count-2] forState:UIControlStateNormal];
                cell.moreActionBlock = ^(){
                    cart.isOpen = YES;
                    [self.collectionView reloadData];
                };
                
                return cell;
                
            }
            MLShopCartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCartCollectionViewCell forIndexPath:indexPath];
            MLProlistModel *model = [cart.prolist objectAtIndex:indexPath.row];
            cell.prolistModel = model;
            cell.checkBox.cartSelected = (model.is_check == 1);
            cell.countField.value = model.num;
            cell.countField.stepperDelegate = self;
            cell.countField.proList = model;
            cell.shopCartCheckBoxBlock = ^(BOOL isCheck){
                model.is_check = isCheck?1:0;
                if (isCheck) {//如果是选中 检测其他是否都为已选中状态
                    BOOL check_all = YES;
                    for (MLProlistModel *model in cart.prolist) {
                        if (model.is_check != 1) {
                            check_all = NO;
                        }
                    }
                    cart.select_All = check_all;
                }
                else{//如果是未选中状态 检测头部是否是未选中  如果是已选中 需要
                    
                }
                [self countAllPrice];
            };
            cell.shopCartDelBlock = ^(){ //购物车删除
                [self deleteGoods:model];
                [self.shopCart.cart removeObject:model];
                [self.collectionView reloadData];
                
            };
            return cell;
        }

    }else
    {  //离线购物车
        if (indexPath.section == self.offlineCart.count) {
            MLGoodsLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsLikeCollectionViewCell forIndexPath:indexPath];
            MLGuessLikeModel *model = [self.likeArray objectAtIndex:indexPath.row];
            cell.likeModel = model;
            return cell;
        }
        else{
            MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:indexPath.section];
            if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
                MLShopCartMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreCell" forIndexPath:indexPath];
                [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",cart.goodsArray.count-2] forState:UIControlStateNormal];
                cell.moreActionBlock = ^(){
                    cart.isOpen = YES;
                    [self.collectionView reloadData];
                };
                
                return cell;
            }
            MLShopCartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCartCollectionViewCell forIndexPath:indexPath];
            OffLlineShopCart *goods = [cart.goodsArray objectAtIndex:indexPath.row];
            cell.offlineCart = goods;
            cell.checkBox.cartSelected = (goods.is_check == 1);
            cell.countField.value = goods.num;
            cell.countField.stepperDelegate = self;
            cell.countField.proList = goods;
            cell.shopCartCheckBoxBlock = ^(BOOL isCheck){
                goods.is_check = isCheck?1:0;
                [self countAllPrice];
            };
            cell.shopCartDelBlock = ^(){ //购物车删除
                //先删除店铺下的 cart记录
                NSMutableArray *pids = [[cart.cpInfo.shopCart componentsSeparatedByString:@","] mutableCopy];
                [pids removeObject:goods.pid];
                if (pids.count > 0) { //说明还有其他商品
                    cart.isMore = pids.count>2;
                    cart.cpInfo.shopCart = [pids componentsJoinedByString:@","];
                    [cart.goodsArray removeObject:goods];
                }else{//没有其他商品 直接删除记录
                    [self.offlineCart removeObject:cart];
                    [cart.cpInfo MR_deleteEntity];
                }
                [goods MR_deleteEntity];
                [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
                [self countAllPrice];
                [self.collectionView reloadData];
                [self configBlankPage];
            };
            return cell;
        }

    }
   
}



- (void)addButtonClick:(id)prolist count:(int)textCount{

    if (self.isLogin) {//已登录
        [self changeNum:prolist AndCount:textCount];
    }
    else{//离线购物车
        OffLlineShopCart *model = (OffLlineShopCart *)prolist;
        model.num = textCount;
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        [self.collectionView reloadData];
        [self countAllPrice];
    }
    
    
}
- (void)subButtonClick:(id)prolist count:(int)textCount{
    
    if (self.isLogin) {//已登录
        [self changeNum:prolist AndCount:textCount];
    }
    else{//离线购物车
        OffLlineShopCart *model = (OffLlineShopCart *)prolist;
        model.num = textCount;
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        [self.collectionView reloadData];
        [self countAllPrice];
    }
}



#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果购物车里有数据
    if (self.isLogin) {
        if (indexPath.section == self.shopCart.cart.count) {
            CGFloat cellW = (MAIN_SCREEN_WIDTH - 8)/2;
            return CGSizeMake(cellW,cellW*1.4);
        }
        else{
            MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:indexPath.section];
            if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
                return CGSizeMake(MAIN_SCREEN_WIDTH, 40);
            }
            return CGSizeMake(MAIN_SCREEN_WIDTH, 117);
        }
    }else{
        if (indexPath.section == self.offlineCart.count) {
            CGFloat cellW = (MAIN_SCREEN_WIDTH - 8)/2;
            return CGSizeMake(cellW,cellW*1.4);
        }
        else{
            MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:indexPath.section];
            if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
                return CGSizeMake(MAIN_SCREEN_WIDTH, 40);
            }
            return CGSizeMake(MAIN_SCREEN_WIDTH, 117);
        }
    }
    
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0 , 8, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == self.shopCart.cart.count) {
        return 0;
    }
    return 1.f;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLogin) { //已登录点击猜你喜欢
        if (indexPath.section == self.shopCart.cart.count) {  //猜你喜欢点击
            MLGuessLikeModel *model = [self.likeArray objectAtIndex:indexPath.row];
            MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
            NSDictionary *params = @{@"id":model.ID};
            vc.paramDic = params;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{//未登录点击猜你喜欢
        if (indexPath.section  == self.offlineCart.count) {
            MLGuessLikeModel *model = [self.likeArray objectAtIndex:indexPath.row];
            MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
            NSDictionary *params = @{@"id":model.ID};
            vc.paramDic = params;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isLogin) {
        if (indexPath.section == self.shopCart.cart.count && [kind isEqualToString:UICollectionElementKindSectionHeader]) { //猜你喜欢
            MLLikeHeadCollectionReusableView *likeHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLikeHeadCollectionReusableView forIndexPath:indexPath];
            
            return likeHead;
        }
        else if([kind isEqualToString:UICollectionElementKindSectionHeader]){
            MLCartHeadCollectionReusableView *cartHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCartHeadCollectionReusableView forIndexPath:indexPath];
            MLShopingCartModel *model = [self.shopCart.cart objectAtIndex:indexPath.section];
            cartHead.checkBox.cartSelected = model.select_All;
            cartHead.shopingCart = model;
            cartHead.cartHeadBlock = ^(BOOL isSelect){
                
                [self countAllPrice];
                [self.collectionView reloadData];
                
            };
            __weak typeof(self) weakself = self;
            cartHead.youHuiBlock = ^(){ //展示优惠券列表
                
                [self.lingQuQuanView.quanARR removeAllObjects];
                //创建数据数组
                for (NSDictionary * quanDic in model.dpyhq) {
                    YouHuiQuanModel * model = [[YouHuiQuanModel alloc]init];
                    model.startTime = quanDic[@"YXQ_B"];
                    model.endTime = quanDic[@"YXQ_E"];
                    model.mingChengStr = quanDic[@"YHQMC"];
                    model.flag = quanDic[@"FLAG"];
                    model.jinE = quanDic[@"JE"];
                    model.quanBH = quanDic[@"JLBH"];
                    model.quanID = quanDic[@"YHQID"];
                    model.quanType = quanDic[@"CXLX"];
                    [self.lingQuQuanView.quanARR addObject:model];
                }
                [self.lingQuQuanView.tablieview reloadData];
                [UIView animateWithDuration:0.2f animations:^{
                    weakself.lingQuQuanView.frame = CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT);
                } completion:^(BOOL finished) {
                    [weakself.tabBarController.tabBar setHidden:YES];
                }];
            };
            return cartHead;
        }

    }
    else{
        if (indexPath.section == self.offlineCart.count && [kind isEqualToString:UICollectionElementKindSectionHeader]) { //猜你喜欢
            MLLikeHeadCollectionReusableView *likeHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLikeHeadCollectionReusableView forIndexPath:indexPath];
            
            return likeHead;
        }
        else if([kind isEqualToString:UICollectionElementKindSectionHeader]){
            MLCartHeadCollectionReusableView *cartHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCartHeadCollectionReusableView forIndexPath:indexPath];
            MLOffLineShopCart *model = [self.offlineCart objectAtIndex:indexPath.section];
            cartHead.titleLabel.text = model.cpInfo.company;
            cartHead.cartHeadBlock = ^(BOOL isSelect){
                [self countAllPrice];
                [self.collectionView reloadData];
            };
            cartHead.youhuiBtn.hidden = YES;
            return cartHead;
        }
    }
    return nil;
    
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.isLogin) {//在线状态
        if (section <= self.shopCart.cart.count) {
            CGSize size={MAIN_SCREEN_WIDTH,45};
            return size;
        }
    }
    else{//离线状态
        if (section<=self.offlineCart.count) {
            CGSize size={MAIN_SCREEN_WIDTH,45};
            return size;
        }
    }
     return CGSizeZero;
}



- (void)selectAllGoods:(MLCheckBoxButton *)sender{
    sender.cartSelected = !sender.cartSelected;
    
    if (self.isLogin) {//已登录
        for (MLShopingCartModel *model in self.shopCart.cart) {
            model.select_All = sender.cartSelected;
        }
    }else{ //未登录
        for (MLOffLineShopCart *model in self.offlineCart) {
            model.checkAll = sender.cartSelected;
        }
    }
    [self.collectionView reloadData];
    [self countAllPrice];
    
}



- (void)clearingAction{//结算操作
    if (self.isLogin) { //如果已登录 直接提交结算 未登录提示登录
        NSMutableArray *temp = [NSMutableArray array];
        for (MLShopingCartModel *model in self.shopCart.cart) {
            for (MLProlistModel *prolist in model.prolist) {
                if (prolist.is_check == 1) {
                    NSDictionary *dic = @{@"product_id":prolist.ID};
                    [temp addObject:dic];
                }
            }
        }
        if (temp.count == 0) {
            NSLog(@"还没有商品加入购物车");
            [MBProgressHUD showMessag:@"您还没有选择商品" toView:self.view];
        }
        else{ //发送下单请求
            NSMutableDictionary *tempdic = [NSMutableDictionary dictionary ];
            for (int i=0; i < temp.count; i++) {
                NSMutableArray *product_id = [NSMutableArray array];
                NSString *productid = temp[i][@"product_id"];
                [product_id addObject:productid];
                NSString *cart_list = [NSString stringWithFormat:@"product_id[%d]",i];
                [tempdic setObject:product_id forKey:cart_list];
                
            }
            NSLog(@"tempdic === %@",tempdic);
            MLCommitOrderViewController *vc = [[MLCommitOrderViewController alloc]init];
            vc.paramsDic = tempdic;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
//            [self confirmOrderWithProducts:[temp copy]];
        }

    }else{
        [self loginAction:nil];
    }
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil]; 
}





- (NSMutableArray *)likeArray{
    if (!_likeArray) {
        _likeArray = [NSMutableArray array];
        
    }
    return _likeArray;
}



- (void)countAllPrice{
    allPrice = 0.f;
    if (self.isLogin) {
        for (MLShopingCartModel *model in self.shopCart.cart) {
            for (MLProlistModel *prolist in model.prolist) {
                if (prolist.is_check == 1) {
                    allPrice+= prolist.pro_price * prolist.num;
                }
            }
        }
    }else{
        for (MLOffLineShopCart *model in self.offlineCart) {
            for (OffLlineShopCart *prolist in model.goodsArray) {
                if (prolist.is_check == 1) {
                    allPrice+= prolist.pro_price * prolist.num;
                }
            }
        }
    }

    NSString *attr = [NSString stringWithFormat:@"<font  size = \"14\">合计：<color value = \"#FF4E26\">￥%.2f</><font  size = \"12\"><color value = \"#999999\"> 不含运费</></></>",allPrice];
    self.footView.detailLabel.attributedText = [attr createAttributedString];
}

- (void)deleteGoods:(MLProlistModel *)goods{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=delete",MATROJP_BASE_URL];
    [MLHttpManager post:url params:@{@"cart_id":goods.ID} m:@"product" s:@"cart" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"删除成功" toView:self.view];
            [self getDataSource];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}

- (void)changeNum:(MLProlistModel *)prolist AndCount:(NSInteger)count{
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=modify",MATROJP_BASE_URL];
    [MLHttpManager post:urlStr params:@{@"id":prolist.ID,@"nums":[NSNumber numberWithInteger:count]} m:@"product" s:@"cart" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //修改成功
            //调用接口
            prolist.num = count;
            [self countAllPrice];
            [self.collectionView reloadData];
        }
        else
        {
            [self getDataSource];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}

- (void)confirmOrderWithProducts:(NSArray *)products{//创建订单
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=confirm_order",MATROJP_BASE_URL];
    [MLHttpManager post:urlStr params:products m:@"product" s:@"confirm_order" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            //订单提交成功   后续操作
            [MBProgressHUD showSuccess:@"订单提交成功，后续操作" toView:self.view];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
    
}


- (void)guessYourLike{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=guess_like&method=get_guess_like&start=%@&limit=10",MATROJP_BASE_URL,[NSNumber numberWithInteger:pageIndex]];
    [[HFSServiceClient sharedJSONClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [self.likeArray removeAllObjects];
            NSDictionary *data = result[@"data"];
            NSArray *product = data[@"product"];
            [self.likeArray addObjectsFromArray:[MLGuessLikeModel mj_objectArrayWithKeyValuesArray:product]];
            [self.collectionView reloadData];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}


- (NSMutableArray *)offlineCart{
    if (!_offlineCart) {
        _offlineCart = [NSMutableArray array];
        
    }
    return _offlineCart;
}




@end

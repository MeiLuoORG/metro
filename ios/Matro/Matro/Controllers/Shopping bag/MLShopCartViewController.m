//
//  MLShopCartViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/13.
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
//#import "MBProgressHUD+Add.h"
#import "UIView+BlankPage.h"
#import "MLLoginViewController.h"
#import "NSString+GONMarkup.h"
#import "MBProgressHUD+Add.h"

@interface MLShopCartViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CPStepperDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *likeArray;
@property (nonatomic,strong)UIView *loginView;
@property (nonatomic,strong)MLShopingCartlistModel *shopCart;
@end

static float allPrice = 0;
static NSInteger goodsCount;

@implementation MLShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
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
        [collectionView registerNib:[UINib nibWithNibName:@"MLCartFootCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCartFootCollectionReusableView];

        collectionView;
    });

    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(8);
        make.height.mas_equalTo(45);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginView.mas_bottom).offset(8);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.view configBlankPage:EaseBlankPageTypeGouWuDai hasData:(self.shopCart.cart.count>0)];
    [self getDataSource];
}


- (void)getDataSource{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=index",@"http://bbctest.matrojp.com"];
    [[HFSServiceClient sharedJSONClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([[result objectForKey:@"code"] isEqual:@0]) {
            self.shopCart = [MLShopingCartlistModel mj_objectWithKeyValues:result[@"data"][@"cart_list"]];
            [self.collectionView reloadData];
            [self.view configBlankPage:EaseBlankPageTypeGouWuDai hasData:(self.shopCart.cart.count>0)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络错误");  
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     NSString  *loginid = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERID];
    if (loginid) {
        [self showOrHiddenLoginView:NO];
    }
    else{
        [self showOrHiddenLoginView:YES];
    }
}

#pragma mark -- UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == self.shopCart.cart.count) {
        return self.likeArray.count;
    }
    else{
        
        MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:section];
        return cart.prolist.count;
    }
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //如果是购物车里面有东西就显示猜你喜欢
    return  self.shopCart.cart.count > 0?self.shopCart.cart.count + 1:0;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.shopCart.cart.count) {
        MLGoodsLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsLikeCollectionViewCell forIndexPath:indexPath];
        return cell;
    }
    else{
        MLShopCartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCartCollectionViewCell forIndexPath:indexPath];
        MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:indexPath.section];
        MLProlistModel *model = [cart.prolist objectAtIndex:indexPath.row];
        cell.prolistModel = model;
        cell.checkBox.cartSelected = (model.is_check == 1);
        cell.countField.value = model.num;
        cell.countField.stepperDelegate = self;
        cell.countField.proList = model;
        cell.shopCartCheckBoxBlock = ^(){
            [self countAllPrice];
        };
        cell.shopCartDelBlock = ^(){ //购物车删除
            [self deleteGoods:model];
            [self.shopCart.cart removeObject:model];
            [self.collectionView reloadData];
            
        };
        return cell;
    }

}



- (void)addButtonClick:(MLProlistModel *)prolist count:(int)textCount{

    [self changeNum:prolist AndCount:textCount];
    
    
    
}
- (void)subButtonClick:(MLProlistModel *)prolist count:(int)textCount{
    [self changeNum:prolist AndCount:textCount];
}



#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果购物车里有数据
//    if (self.shopCart.cart.count > 0) {
        if (indexPath.section == self.shopCart.cart.count) {
            CGFloat cellW = (MAIN_SCREEN_WIDTH - 8)/2;
            return CGSizeMake(cellW,cellW*1.4);
        }
        else{
            return CGSizeMake(MAIN_SCREEN_WIDTH, 125);//没有包邮情况
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
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == self.shopCart.cart.count && [kind isEqualToString:UICollectionElementKindSectionHeader]) { //猜你喜欢
        MLLikeHeadCollectionReusableView *likeHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLikeHeadCollectionReusableView forIndexPath:indexPath];
        
        return likeHead;
    }else if (indexPath.section == self.shopCart.cart.count - 1 && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
       MLCartFootCollectionReusableView *cartFoot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCartFootCollectionReusableView forIndexPath:indexPath];
        [cartFoot.checkBox addTarget:self action:@selector(selectAllGoods:) forControlEvents:UIControlEventTouchUpInside];
        [cartFoot.clearingBtn addTarget:self action:@selector(clearingAction) forControlEvents:UIControlEventTouchUpInside];
        NSString *attr = [NSString stringWithFormat:@"<font  size = \"13\">合计：<color value = \"#FF4E26\">￥%.2f</><font  size = \"11\"><color value = \"#999999\"> 共%li件，不含运费</></></>",allPrice,(long)goodsCount];
        cartFoot.detailLabel.attributedText = [attr createAttributedString];
        return cartFoot;
    }
    else{
        MLCartHeadCollectionReusableView *cartHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCartHeadCollectionReusableView forIndexPath:indexPath];
        MLShopingCartModel *model = [self.shopCart.cart objectAtIndex:indexPath.section];
        cartHead.checkBox.cartSelected = model.select_All;
        cartHead.shopingCart = model;
        cartHead.cartHeadBlock = ^(BOOL isSelect){
            [self countAllPrice];
        };
        
        
        return cartHead;
    }
    
    
    return nil;
    
}

- (void)selectAllGoods:(MLCheckBoxButton *)sender{
    sender.cartSelected = !sender.cartSelected;
    
    for (MLShopingCartModel *model in self.shopCart.cart) {
        model.select_All = sender.cartSelected;
    }
    [self countAllPrice];
    
}



- (void)clearingAction{//结算操作
    
    NSMutableArray *temp = [NSMutableArray array];
    for (MLShopingCartModel *model in self.shopCart.cart) {
        for (MLProlistModel *prolist in model.prolist) {
            if (prolist.is_check == 1) {
                NSDictionary *dic = @{@"product_id[]":prolist.ID};
                [temp addObject:dic];
            }
        }
    }
    if (temp.count == 0) {
        NSLog(@"还没有商品加入购物车");
        [MBProgressHUD showMessag:@"您还没有选择商品" toView:self.view];
    }
    else{ //发送下单请求
        [self confirmOrderWithProducts:[temp copy]];
    }
}


- (void)confirmOrderWithProducts:(NSArray *)products{//创建订单
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://bbctest.matrojp.com/api.php?m=product&s=confirm_order" parameters:products success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            //订单提交成功   后续操作
            [MBProgressHUD showSuccess:@"订单提交成功，后续操作" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}




//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section <= self.shopCart.cart.count) {
        CGSize size={MAIN_SCREEN_WIDTH,45};
        return size;
    }
    return CGSizeZero;
   
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == self.shopCart.cart.count - 1) {
        CGSize size={MAIN_SCREEN_WIDTH,50};
        return size;
    }
    return CGSizeZero;
}



- (void)loginAction:(id)sender{
    
    
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
    
}


- (void)showOrHiddenLoginView:(BOOL)isShow{
    self.loginView.hidden = !isShow;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(isShow? self.loginView.mas_bottom:self.view).offset(10);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}



- (NSMutableArray *)likeArray{
    if (!_likeArray) {
        _likeArray = [NSMutableArray array];
        [_likeArray addObject:@"1"];
        [_likeArray addObject:@"2"];
        [_likeArray addObject:@"1"];
        [_likeArray addObject:@"1"];
    }
    return _likeArray;
}



- (void)countAllPrice{
    goodsCount = 0;
    allPrice = 0.f;
    for (MLShopingCartModel *model in self.shopCart.cart) {
        for (MLProlistModel *prolist in model.prolist) {
            if (prolist.is_check == 1) {
                goodsCount ++;
                allPrice+= prolist.pro_price;
            }
        }
    }
    
    [self.collectionView reloadData];
}

- (void)deleteGoods:(MLProlistModel *)goods{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=delete",@"http://bbctest.matrojp.com"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:@{@"cart_id":goods.ID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            
            [self getDataSource];
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



- (void)changeNum:(MLProlistModel *)prolist AndCount:(NSInteger)count{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://bbctest.matrojp.com/api.php?m=product&s=cart&action=modify" parameters:@{@"id":prolist.ID,@"nums":[NSNumber numberWithInteger:count]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //修改成功
            NSDictionary *data = result[@"data"];
            NSString *price = data[@"price"];
            prolist.pro_price = [price floatValue];
            //调用接口
            prolist.num = count;
            [self.collectionView reloadData];
            [self countAllPrice];
        }
        else
        {
            [self getDataSource];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showMessag:@"" toView:self.view];
    }];
}





@end

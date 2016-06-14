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
#import "HFSProductCollectionViewCell.h"

#import "Masonry.h"

@interface MLShopCartViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *likeArray;
@property (nonatomic,strong)NSMutableArray *cartArray;
@property (nonatomic,strong)UIView *loginView;

@end

static BOOL showLogin;
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
        [collectionView registerNib:[UINib nibWithNibName:@"HFSProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCollectionViewCell];
                [self.view addSubview:collectionView];
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
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == self.cartArray.count) {
        return self.likeArray.count;
    }
    else{
        NSArray *arr = [self.cartArray objectAtIndex:section];
        return arr.count;
    }
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //如果是购物车里面有东西就显示猜你喜欢
    return  self.cartArray.count > 0?self.cartArray.count + 1:0;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.cartArray.count) {
        HFSProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCollectionViewCell forIndexPath:indexPath];
        return cell;
    }
    else{
        MLShopCartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCartCollectionViewCell forIndexPath:indexPath];
        return cell;
//        HFSProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCollectionViewCell forIndexPath:indexPath];
//        return cell;
    }

}



#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果购物车里有数据
    if (self.cartArray.count > 0) {
        if (indexPath.section == self.cartArray.count) {
            CGFloat cellW = (MAIN_SCREEN_WIDTH - 10)/2;
            return CGSizeMake(cellW,cellW*1.3);
        }
        else{
            return CGSizeMake(MAIN_SCREEN_WIDTH, 150);
        }
    }
    return CGSizeZero;
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (self.cartArray.count>0) {
        if (section == self.cartArray.count) {
            return UIEdgeInsetsMake(0, 0, 5, 5);
        }
        else{
            return UIEdgeInsetsMake(0, 0 , 0, 0);
        }
    }
    return UIEdgeInsetsZero;
    
    
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
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
    
    if (indexPath.section == self.cartArray.count) { //猜你喜欢
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UICollectionReusableView *likeHead = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 40)];
            UILabel *label = [[UILabel alloc]initWithFrame:likeHead.bounds];
            label.text = @"猜你喜欢";
            label.textAlignment = NSTextAlignmentCenter;
            [likeHead addSubview:label];

            
        }
        
    }
    return nil;
    
}


- (void)loginAction:(id)sender{
    showLogin = !showLogin;
    [self showOrHiddenLoginView:showLogin];
}


- (void)showOrHiddenLoginView:(BOOL)isShow{
    self.loginView.hidden = !isShow;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(isShow? self.loginView.mas_bottom:self.view);
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

- (NSMutableArray *)cartArray{
    if (!_cartArray) {
        _cartArray = [NSMutableArray array];
        [_cartArray addObject:@[@"1",@"1"]];
        [_cartArray addObject:@[@"1",@"1",@"1"]];
        [_cartArray addObject:@[@"1"]];
        
    }
    return _cartArray;
}



@end

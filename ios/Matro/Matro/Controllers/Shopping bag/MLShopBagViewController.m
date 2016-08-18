//
//  MLShopBagViewController.m
//  Matro
//
//  Created by MR.Huang on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopBagViewController.h"
#import "masonry.h"
#import "HFSConstants.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "HFSServiceClient.h"
#import "MLShopingCartlistModel.h"
#import "MLGoodsLikeCollectionViewCell.h"
#import "MLCheckBoxButton.h"
#import "UIView+BlankPage.h"
#import "MLLoginViewController.h"
#import "NSString+GONMarkup.h"
#import "MBProgressHUD+Add.h"
#import "MLGuessLikeModel.h"
#import "MLGoodsDetailsViewController.h"
#import "MLShopCartFootView.h"
#import "MLHttpManager.h"
#import "LingQuYouHuiQuanView.h"
#import <MagicalRecord/MagicalRecord.h>
#import "OffLlineShopCart.h"
#import "CompanyInfo.h"
#import "MLOffLineShopCart.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLMoreTableViewCell.h"
#import "MLOrderCenterTableViewCell.h"
#import "MGSwipeButton.h"
#import "MLShopBagHeaderView.h"
#import "MLShopBagTableViewCell.h"
#import "MLLikeHeadCollectionReusableView.h"
#import "MLOrderSubmitViewController.h"
#import "MLCommitOrderListModel.h"
#import "MLShopInfoViewController.h"
#import "CommonHeader.h"
#import "MLShopBagCloseTableViewCell.h"
#import "UIColor+HeinQi.h"

@interface MLShopBagViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,CPStepperDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLShopCartFootView *footView;
@property (nonatomic,strong)LingQuYouHuiQuanView *lingQuQuanView;
@property (nonatomic,strong)NSMutableArray *likeArray;
@property (nonatomic,strong)UIView *loginView;
@property (nonatomic,strong)NSMutableArray *offlineCart;
@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,strong)MLShopingCartlistModel *shopCart;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (strong, nonatomic) UIBarButtonItem * rightBarButtonzl;
@end
static float allPrice = 0;
static NSInteger pageIndex = 0;

@implementation MLShopBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"购物袋";
    
    /*
     zhoulu修改 START
     */
    
    
    self.rightBarButtonzl = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBianjiButtonAction:)];
    self.rightBarButtonzl.tintColor = [UIColor colorWithHexString:@"ae8e5d"];//625046
    
    self.navigationItem.rightBarButtonItem = self.rightBarButtonzl;
    //self.navigationItem.rightBarButtonItem = nil;
    /*
     ZHOULU 修改 END
     */

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"260E00"]}];
    _loginView = ({
        UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
        headView.backgroundColor = RGBA(245, 245, 245, 1);
        UIView *centerView = [[UIView alloc]initWithFrame:CGRectZero];
        centerView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:centerView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"登录后，同步电脑和手机购物袋中的商品。";
        [centerView addSubview:label];
        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:RGBA(174, 142, 93, 1)];
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [centerView addSubview:loginBtn];
        loginBtn.layer.masksToBounds = YES;
        loginBtn.layer.cornerRadius = 3.f;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(centerView);
            make.left.mas_equalTo(centerView).offset(10);
            make.right.mas_equalTo(loginBtn).offset(-10);
        }];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(centerView).offset(8);
            make.bottom.mas_equalTo(centerView).offset(-8);
            make.right.mas_equalTo(headView).offset(-10);
            make.width.mas_equalTo(70);
        }];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.height.mas_equalTo(45);
            make.left.right.equalTo(headView);
        }];
        [self.view addSubview:headView];
        headView;
    });
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"MLShopBagTableViewCell" bundle:nil] forCellReuseIdentifier:kShopBagTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLShopBagCloseTableViewCell" bundle:nil] forCellReuseIdentifier:@"CloseCell"];
        [tableView registerClass:[MLShopBagHeaderView class] forHeaderFooterViewReuseIdentifier:@"headView"];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat cellW = (MAIN_SCREEN_WIDTH - 2*8)/2;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, (5*(cellW*1.4+16) + 45)) collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"MLGoodsLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGoodsLikeCollectionViewCell];
        [collectionView registerNib:[UINib nibWithNibName:@"MLLikeHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLikeHeadCollectionReusableView];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = RGBA(245, 245, 245, 1);
        collectionView.scrollEnabled = NO;
        collectionView;
    });
    
    self.tableView.tableFooterView = self.collectionView;
    _footView = ({
        MLShopCartFootView *footView = [MLShopCartFootView footView];
        [footView.checkBox addTarget:self action:@selector(selectAllGoods:) forControlEvents:UIControlEventTouchUpInside];
        [footView.clearingBtn addTarget:self action:@selector(clearingAction) forControlEvents:UIControlEventTouchUpInside];
        [footView.deleteButton addTarget:self action:@selector(shanchuShangpin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:footView];
        footView;
    });
    
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(45+16);
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginView.mas_bottom).offset(8);
        make.left.right.bottom.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[self showLoadingView];
    //[self configBlankPage];
    [self ctreateYOUHUIQuanView];
    
}
/*
 zhoulu修改 START
 */
- (void)rightBianjiButtonAction:(id)sender{
    NSLog(@"点击了编辑按钮");
    if ([self.rightBarButtonzl.title isEqualToString:@"编辑"]) {
        self.rightBarButtonzl.title  = @"完成";
        
        self.footView.clearingBtn.hidden = YES;
        self.footView.detailLabel.hidden = YES;
        self.footView.deleteButton.hidden = NO;
    }
    else{
        self.rightBarButtonzl.title = @"编辑";
        self.footView.clearingBtn.hidden = NO;
        self.footView.detailLabel.hidden = NO;
        self.footView.deleteButton.hidden = YES;
    }
}

- (void)shanchuShangpin:(UIButton *)sender{
    NSLog(@"删除按钮");
    if (self.isLogin == YES) {//登录状态
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
        else{
            NSMutableDictionary *tempdic = [NSMutableDictionary dictionary ];
            for (int i=0; i < temp.count; i++) {
                NSString *productid = temp[i][@"product_id"];
                NSString *cart_list = [NSString stringWithFormat:@"product_id[%d]",i];
                [tempdic setObject:productid forKey:cart_list];
            }
            NSLog(@"购物车中的选中商品信息：%@",tempdic);
            NSArray * allIDArr = tempdic.allValues;
            NSString * str  = @"";
            for (int i = 0;i < allIDArr.count;i++) {
                if (i == allIDArr.count - 1) {
                    str = [str stringByAppendingString:allIDArr[i]];
                }
                else{
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",allIDArr[i]]];
                }
            }
            NSLog(@"删除的商品的ID串：%@+",str);
            if (str && ![str isEqualToString:@""]) {
                [self shanChuGOOD:str];
            }
            
            //[self.shopCart.cart removeObject:model];
            self.footView.checkBox.cartSelected = NO;
            [self.tableView reloadData];
            
        }
    }
    else{//未登录 状态
    
        //离线购物车
        //MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:indexPath.section];
        NSMutableArray *temp = [NSMutableArray array];
        NSMutableArray *cartTemp = [NSMutableArray array];
        for (MLOffLineShopCart * cartzl in self.offlineCart) {
            for (OffLlineShopCart * goods in cartzl.goodsArray) {
                if (goods.is_check == 1) {
                    
                    [temp addObject:goods];
                    [cartTemp addObject:cartzl];
                }
                
            }
        }
        if (temp.count == 0) {
            NSLog(@"还没有商品加入购物车");
            [MBProgressHUD showMessag:@"您还没有选择商品" toView:self.view];
        }
        NSLog(@"离线购物车的选中的商品为个数为：%ld-----%ld",temp.count,cartTemp.count);
        for (int i = 0; i<temp.count; i++) {
            MLOffLineShopCart * cartzl = [cartTemp objectAtIndex:i];
            NSMutableArray *pids = [[cartzl.cpInfo.shopCart componentsSeparatedByString:@","] mutableCopy];
            
            OffLlineShopCart * good = [temp objectAtIndex:i];
            [pids removeObject:good.pid];
            
            if (pids.count > 0) { //说明还有其他商品
                cartzl.isMore = pids.count>2;
                cartzl.cpInfo.shopCart = [pids componentsJoinedByString:@","];
                [cartzl.goodsArray removeObject:good];
            }else{//没有其他商品 直接删除记录
                [self.offlineCart removeObject:cartzl];
                [cartzl.cpInfo MR_deleteEntity];
            }
            
            [good MR_deleteEntity];
        }
         
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        NSArray *all = [CompanyInfo MR_findAll];
        if (all.count == 0) {
            [self.likeArray removeAllObjects];
            [self.collectionView reloadData];
            
        }
        [self countAllPrice];
        [self.tableView reloadData];
        [self configBlankPage];
    
    }

    
}

/*
 ZHOULU x修改 END
 */


#pragma mark UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.likeArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MLGoodsLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsLikeCollectionViewCell forIndexPath:indexPath];
    MLGuessLikeModel *model = [self.likeArray objectAtIndex:indexPath.row];
    cell.likeModel = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellW = (MAIN_SCREEN_WIDTH - 6)/2;
    return CGSizeMake(cellW,cellW*1.4);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLGuessLikeModel *model = [self.likeArray objectAtIndex:indexPath.row];
    MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *params = @{@"id":model.ID?:@"",@"userid":model.userid?:@""};
    vc.paramDic = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { //猜你喜欢
        MLLikeHeadCollectionReusableView *likeHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLikeHeadCollectionReusableView forIndexPath:indexPath];
         return likeHead;
    }
    return nil;
}



//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//返回头headerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.likeArray.count > 0 && self.shopCart.cart.count > 0) {
        CGSize size={MAIN_SCREEN_WIDTH,45};
        return size;
    }
    CGSize size={0,0};
    return size;
}

#pragma mark UITableViewDelgate

//防止 sectionHeader 悬浮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 45;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(self.isLogin){
    
        if (self.shopCart.cart.count> 0) {
            self.navigationItem.rightBarButtonItem = self.rightBarButtonzl;
        }
        else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }else{
        if (self.offlineCart.count > 0) {
            self.navigationItem.rightBarButtonItem = self.rightBarButtonzl;
        }
        else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    
    }
    
   return  self.isLogin?self.shopCart.cart.count:self.offlineCart.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isLogin) {
        MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:section];
        if (cart.isMore) {
            if (cart.isOpen) {
                return cart.prolist.count + 1;
            }else{
                return 3;
            }
        }
        return cart.prolist.count;
        
      }else{
        MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:section];
          if (cart.isMore) {
              if (cart.isOpen) {
                  return cart.goodsArray.count + 1;
              }else{
                  return 3;
              }
          }
        return cart.goodsArray.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isLogin) {
       __block  MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:indexPath.section];
        if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
            MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
            [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",cart.prolist.count-2] forState:UIControlStateNormal];
            cell.moreActionBlock = ^(){
                cart.isOpen = YES;
                [self.tableView reloadData];
            };
            return cell;
        }
        if (cart.isMore && cart.isOpen && indexPath.row == cart.prolist.count) { //点击收齐操作
            MLShopBagCloseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CloseCell" forIndexPath:indexPath];
//            cell.closeAction  = ^(){
//                cart.isOpen = NO;
//                [self.tableView reloadData];
//            };
            return cell;
        }
        MLShopBagTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:kShopBagTableViewCell forIndexPath:indexPath];
        __block  MLProlistModel *model = [cart.prolist objectAtIndex:indexPath.row];
        cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
        cell.rightExpansion.buttonIndex = -1;
        cell.rightExpansion.fillOnTrigger = YES;
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * sender){
            [self deleteGoods:model];
            [self.shopCart.cart removeObject:model];
            self.footView.checkBox.cartSelected = NO;
            [self.tableView reloadData];
            return YES;
        }];
        cell.rightButtons = @[button];
        cell.prolistModel = model;
        cell.checkBox.cartSelected = (model.is_check == 1);
        cell.countField.value = model.num;
        cell.countField.stepperDelegate = self;
        cell.countField.proList = model;
        cell.shopCartCheckBoxBlock = ^(BOOL isCheck){ //添加反向选择
            model.is_check = isCheck?1:0;
            BOOL isAll = YES;
            for (MLProlistModel *model in cart.prolist) {
                if (model.is_check == 0) {
                    isAll = NO;
                    break;
                }
            }
            cart.select_All = isAll;
            BOOL isCartAll = YES;
            for (MLShopingCartModel *cart in self.shopCart.cart) {
                if (cart.select_All == NO) {
                    isCartAll = NO;
                }
            }
            self.footView.checkBox.cartSelected = isCartAll;
            [self countAllPrice];
            [self.tableView reloadData];
        };
        //设置底部线条
        
        if ( (indexPath.row == cart.prolist.count-1)) {
            cell.line.hidden = YES;
        }else{
            cell.line.hidden = NO;
        }
        return cell;
    }else
    {  //离线购物车
        MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:indexPath.section];
        if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
            MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
            [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",cart.goodsArray.count-2] forState:UIControlStateNormal];
            cell.moreActionBlock = ^(){
                cart.isOpen = YES;
                [self.tableView reloadData];
            };
            
            return cell;
        }
        if (cart.isMore && cart.isOpen && indexPath.row == cart.goodsArray.count) { //点击收齐操作
            MLShopBagCloseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CloseCell" forIndexPath:indexPath];
            return cell;
        }
        MLShopBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopBagTableViewCell forIndexPath:indexPath];
        OffLlineShopCart *goods = [cart.goodsArray objectAtIndex:indexPath.row];
        cell.offlineCart = goods;
        cell.checkBox.cartSelected = (goods.is_check == 1);
        cell.countField.value = goods.num;
        cell.countField.stepperDelegate = self;
        cell.countField.proList = goods;
       
        cell.shopCartCheckBoxBlock = ^(BOOL isCheck){
            goods.is_check = isCheck?1:0;
            BOOL isAll = YES;
            for (OffLlineShopCart *good in cart.goodsArray) {
                if (good.is_check == 0) {
                    isAll = NO;
                    break;
                }
            }
            cart.checkAll = isAll;
            BOOL isCartAll = YES;
            for (MLOffLineShopCart *cart in self.offlineCart) {
                if (cart.checkAll == NO) {
                    isCartAll = NO;
                }
            }
            self.footView.checkBox.cartSelected = isCartAll;
            [self countAllPrice];
            [self.tableView reloadData];
        };
        cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
        cell.rightExpansion.buttonIndex = -1;
        cell.rightExpansion.fillOnTrigger = YES;
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * sender){
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
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            NSArray *all = [CompanyInfo MR_findAll];
            if (all.count == 0) {
                [self.likeArray removeAllObjects];
                [self.collectionView reloadData];

            }
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //[self showLoadingView];
            [self countAllPrice];
            [self.tableView reloadData];
            [self configBlankPage];
            return YES;
        }];
      cell.rightButtons = @[button];
        //设置底部线条
        if (indexPath.row == cart.goodsArray.count-1) {
            cell.line.hidden = YES;
        }else{
            cell.line.hidden = NO;
        }
        return cell;
    }
}





- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MLShopBagHeaderView *cartHead = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headView"];
    if (!cartHead) {
        cartHead = [[MLShopBagHeaderView alloc]initWithReuseIdentifier:@"headView"];
    }
    if (self.isLogin) {
        MLShopingCartModel *model = [self.shopCart.cart objectAtIndex:section];
        cartHead.checkBox.cartSelected = model.select_All;
        cartHead.shopingCart = model;
        cartHead.shopClick = ^(){ //点击店铺事件
            MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
            vc.uid = model.sell_userid;
            vc.shopparamDic = @{@"userid":model.sell_userid,@"company":@""};
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cartHead.cartHeadBlock = ^(BOOL isSelect){
            model.select_All = isSelect;
            for (MLProlistModel *sek in model.prolist) {
                sek.is_check = isSelect?1:0;
            }
            BOOL isCartAll = YES;
            for (MLShopingCartModel *cart in self.shopCart.cart) {
                if (cart.select_All == NO) {
                    isCartAll = NO;
                }
            }
            self.footView.checkBox.cartSelected = isCartAll;
            [self countAllPrice];
            [self.tableView reloadData];
            
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
        
    }else{
        MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:section];
        cartHead.titleLabel.text = [NSString stringWithFormat:@"%@ ",cart.cpInfo.company];
        cartHead.youhuiBtn.hidden = YES;
        cartHead.checkBox.cartSelected = cart.checkAll;
        cartHead.shopClick = ^(){ //点击店铺事件
            MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
            vc.uid = cart.cpInfo.cid;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cartHead.cartHeadBlock = ^(BOOL isSelect){
            cart.checkAll = isSelect;
            for (OffLlineShopCart *model in cart.goodsArray) {
                model.is_check = isSelect?1:0;
            }
            BOOL isCartAll = YES;
            for (MLOffLineShopCart *cart in self.offlineCart) {
                if (cart.checkAll == NO) {
                    isCartAll = NO;
                }
            }
            self.footView.checkBox.cartSelected = isCartAll;
            [self countAllPrice];
            [self.tableView reloadData];
        };
    }
    return cartHead;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isLogin) {
        MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:indexPath.section];
        if (cart.isMore && cart.isOpen && indexPath.row == cart.prolist.count) {
            return 40;
        }
        if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
            return 40;
            
        }
        return 125;
    }
    else{
        MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:indexPath.section];
        if (cart.isMore && !cart.isOpen && indexPath.row == 2){
            return 40;
        }
        if (cart.isMore && cart.isOpen && indexPath.row == cart.goodsArray.count) {
            return 40;
        }
        return 125;
    }
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isLogin) {
          MLOffLineShopCart *cart = [self.offlineCart objectAtIndex:indexPath.section];
        if (cart.isMore && cart.isOpen && indexPath.row == cart.goodsArray.count) {
            cart.isOpen = NO;
            [self.tableView reloadData];
            return;
        }
        if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
            return;
            
        }
 
        OffLlineShopCart *model = [cart.goodsArray objectAtIndex:indexPath.row];
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
        NSDictionary *params = @{@"id":model.pid?:@"",@"userid":model.company_id?:@""};
        vc.paramDic = params;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
       
    }
    else{
        MLShopingCartModel *cart = [self.shopCart.cart objectAtIndex:indexPath.section];
        if (cart.isMore && cart.isOpen && indexPath.row == cart.prolist.count) {
            cart.isOpen = NO;
            [self.tableView reloadData];
            return;
        }
        if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
            return;
            
        }
        MLProlistModel *model = [cart.prolist objectAtIndex:indexPath.row];
        
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
        NSDictionary *params = @{@"id":model.pid?:@"",@"userid":model.sell_userid?:@""};
        vc.paramDic = params;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


#pragma 基本操作
/**
 *  数量操作点击事件
 *
 */
- (void)addField:(CPStepper *)field  ButtonClick:(id)prolist  count:(int)textCount{
    if (self.isLogin) {//已登录
        
        [self changeNum:prolist AndCount:textCount];
    }
    else{//离线购物车
        OffLlineShopCart *model = (OffLlineShopCart *)prolist;
        model.num = textCount;
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        [self.tableView reloadData];
        [self countAllPrice];
    }
}
- (void)showFieldErrorMessage{
     [MBProgressHUD showSuccess:@"已达到最大购买量" toView:self.view];
}


- (void)subButtonClick:(id)prolist count:(int)textCount{

    if (self.isLogin) {//已登录
        [self changeNum:prolist AndCount:textCount];
    }
    else{//离线购物车
        OffLlineShopCart *model = (OffLlineShopCart *)prolist;
        model.num = textCount;
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        [self.tableView reloadData];
        [self countAllPrice];
    }
}

/**
 *  点击全选按钮操作
 *
 *  @param sender 
 */
- (void)selectAllGoods:(MLCheckBoxButton *)sender{
    sender.cartSelected = !sender.cartSelected;
    
    if (self.isLogin) {//已登录
        for (MLShopingCartModel *model in self.shopCart.cart) {
            model.select_All = sender.cartSelected;
            for (MLProlistModel *pro in model.prolist) {
                pro.is_check = sender.cartSelected;
            }
        }
    }else{ //未登录
        for (MLOffLineShopCart *model in self.offlineCart) {
            model.checkAll = sender.cartSelected;
            for (OffLlineShopCart *prolist in model.goodsArray) {
                prolist.is_check = sender.cartSelected;
            }
        }
    }
    [self.tableView reloadData];
    [self countAllPrice];
    
}


- (void)countAllPrice{
    allPrice = 0.f;
    //[self closeLoadingView];
    if (self.isLogin) {
        for (MLShopingCartModel *model in self.shopCart.cart) {
            for (MLProlistModel *prolist in model.prolist) {
                if (prolist.is_check == 1) {
                    allPrice+= prolist.realPrice * prolist.num;
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
    
    NSString *attr = [NSString stringWithFormat:@"<font  size = \"14\">合计：<color value = \"#FF4E26\">￥%.2f</><font  size = \"13\"><color value = \"#999999\"> 不含运费</></></>",allPrice];
    self.footView.detailLabel.attributedText = [attr createAttributedString];
}

- (void)configBlankPage{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[self closeLoadingView];
    __weak typeof(self) weakself = self;
/*
    if (self.view.blankPage) {
        self.view.blankPage.hidden = YES;//zhoulu 修改
    }
 */
    [self.view configBlankPage:EaseBlankPageTypeGouWuDai hasData:(self.isLogin? self.shopCart.cart.count>0:self.offlineCart.count>0)];
    self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType curType){
        [weakself.tabBarController setSelectedIndex:0];
    };
    
    if (self.isLogin? self.shopCart.cart.count>0:self.offlineCart.count>0){ //如果有数据就显示 foot
        self.footView.hidden = NO;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.isLogin? self.view:self.loginView.mas_bottom).offset(0);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.footView.mas_top);
        }];
    }else{ //没数据就不显示
        self.footView.hidden = YES;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.isLogin? self.view:self.loginView.mas_bottom).offset(8);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }
    
}

//领取优惠券视图
- (void)ctreateYOUHUIQuanView{
    //[self closeLoadingView];
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


- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.blankPage.hidden = YES;
    self.footView.hidden = YES;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    NSString  *loginid = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERID];
    [self.likeArray removeAllObjects];
    [self.offlineCart removeAllObjects];
    [self.shopCart.cart removeAllObjects];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    if (loginid) { //已登录情况

        self.isLogin = YES;
        [self showLoadingView];
        //[self getDataSource];
        [self performSelector:@selector(loginAfter1) withObject:nil afterDelay:1.0];
        
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
            [self showLoadingView];
            [self guessYourLike];
        }
        else{
            [self closeLoadingView];
        }
        //[self.tableView reloadData];
        [self configBlankPage];
    }
    self.footView.checkBox.cartSelected = NO;
    if (!self.isLogin) {  //遍历所有商品  取消选中
        for (MLOffLineShopCart *cp in self.offlineCart) {
            for (OffLlineShopCart *cart in cp.goodsArray) {
                cart.is_check = 0;
            }
        }
    }
    
    //[self configBlankPage];
    self.loginView.hidden = self.isLogin;
    [self countAllPrice];
    
    self.rightBarButtonzl.title = @"完成";
    [self rightBianjiButtonAction:self.rightBarButtonzl];
}

- (void)loginAfter1{

    
    
    [self addShopCart];
    
}


/**
 *  获取购物车商品
 */
- (void)getDataSource{
    
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=index",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"product" s:@"cart" success:^(id responseObject) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        //[self closeLoadingView];
        NSLog(@"data===%@",responseObject);
        
        [self.tableView.header endRefreshing];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqual:@0]) {
            self.shopCart = [MLShopingCartlistModel mj_objectWithKeyValues:result[@"data"][@"cart_list"]];
            [self countAllPrice];
            [self.tableView reloadData];
            if (self.shopCart.cart.count > 0) {
                [self guessYourLike];
            }else{
                [self closeLoadingView];
                [self configBlankPage];
            }
        }else{
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
            [self configBlankPage];
            [self closeLoadingView];
        }
        //[self configBlankPage];
    } failure:^(NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [self.tableView.header endRefreshing];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}

/**
 *  获取猜你喜欢数据
 */
- (void)guessYourLike{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=guess_like&method=get_guess_like&start=%@&limit=10",MATROJP_BASE_URL,[NSNumber numberWithInteger:pageIndex]];
    
    [MLHttpManager get:url params:nil m:@"product" s:@"guess_like" success:^(id responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [self.likeArray removeAllObjects];
            NSDictionary *data = result[@"data"];
            NSArray *product = data[@"product"];
            [self.likeArray addObjectsFromArray:[MLGuessLikeModel mj_objectArrayWithKeyValuesArray:product]];
            [self.collectionView reloadData];
            
            if (self.isLogin == NO) {
                [self.tableView reloadData];
            }
            
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
        [self closeLoadingView];
        [self configBlankPage];
    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
         [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
    /*
    [[HFSServiceClient sharedJSONClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
    */
}

/**
 *  结算按钮点击操作
 */
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
                NSString *productid = temp[i][@"product_id"];
                NSString *cart_list = [NSString stringWithFormat:@"product_id[%d]",i];
                [tempdic setObject:productid forKey:cart_list];
                
            }
            
            [self confirmOrderWithProducts:tempdic];
        }
        
    }else{
        [self loginAction:nil];
    }
}

/**
 *  更改商品数量
 *
 *  @param prolist
 *  @param count
 */
- (void)changeNum:(MLProlistModel *)prolist AndCount:(NSInteger)count{
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=modify",MATROJP_BASE_URL];
    [MLHttpManager post:urlStr params:@{@"id":prolist.ID,@"nums":[NSNumber numberWithInteger:count]} m:@"product" s:@"cart" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //修改成功
            //调用接口
            prolist.num = count;
            [self countAllPrice];
            [self.tableView reloadData];
        }
        else
        {
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
            [self getDataSource];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


/**
 *  删除购物车商品
 *
 *  @param goods
 */
- (void)deleteGoods:(MLProlistModel *)goods{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=delete",MATROJP_BASE_URL];
    [MLHttpManager post:url params:@{@"cart_id":goods.ID} m:@"product" s:@"cart" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"删除成功" toView:self.view];
            [self.likeArray removeAllObjects];
            [self.collectionView reloadData];
            [self getDataSource];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}
/*
 删除 商品 zhoulu  xiugai  START
 */
- (void) shanChuGOOD:(NSString * )goodIDstring{

    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=delete",MATROJP_BASE_URL];
    [MLHttpManager post:url params:@{@"cart_id":goodIDstring} m:@"product" s:@"cart" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"删除成功" toView:self.view];
            [self.likeArray removeAllObjects];
            [self.collectionView reloadData];
            [self getDataSource];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self closeLoadingView];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    

}


/*
 删除 商品 zhoulu  xiugai END
 */

/**
 *  生成订单操作
 *
 *  @param products
 */
- (void)confirmOrderWithProducts:(NSDictionary *)products{//创建订单
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoadingView];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=confirm_order",MATROJP_BASE_URL];
    [MLHttpManager post:urlStr params:products m:@"product" s:@"confirm_order" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            //订单提交成功   后续操作
            NSDictionary *data = result[@"data"];
            MLCommitOrderListModel *model = [MLCommitOrderListModel mj_objectWithKeyValues:data];
            MLOrderSubmitViewController *vc = [[MLOrderSubmitViewController alloc]init];
            vc.order_info = model;
            vc.params = products;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self closeLoadingView];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}



- (NSMutableArray *)offlineCart{
    if (!_offlineCart) {
        _offlineCart = [NSMutableArray array];
        
    }
    return _offlineCart;
}



- (NSMutableArray *)likeArray{
    if (!_likeArray) {
        _likeArray = [NSMutableArray array];
        
    }
    return _likeArray;
}

//同步购物车
- (void)addShopCart{
    NSArray *cartArray = [OffLlineShopCart MR_findAll];
    
    if (cartArray.count>0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [cartArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OffLlineShopCart *cart = (OffLlineShopCart *)obj;
            NSString *str = [NSString stringWithFormat:@"%@,%hi,%@,%@",cart.pid,cart.num,cart.sid,cart.sku];
            NSString *key = [NSString stringWithFormat:@"cart_list[%li]",idx];
            [dic setValue:str forKey:key];
        }];
        NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=mul_add_cart",MATROJP_BASE_URL];
        [MLHttpManager post:url params:dic m:@"product" s:@"cart" success:^(id responseObject) {
            //[self closeLoadingView];
            NSLog(@"data2222===%@",responseObject);
            
            NSDictionary *result = (NSDictionary *)responseObject;
            if ([result[@"code"] isEqual:@0]) {
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
                //请求购物车商品 线上
                [self getDataSource];
            }
        } failure:^(NSError *error) {
            //[self closeLoadingView];
            
        }];
    }
    else{
    //离线购物车 < 0
        [self getDataSource];
    
    }
}






@end

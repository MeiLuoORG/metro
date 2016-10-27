//
//  MLCollectionViewController.m
//  Matro
//
//  Created by benssen on 16/4/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCollectionViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MLgoodsCollectTableViewCell.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "MLWishlistFootView.h"
#import "MLWishlistTableViewCell.h"
#import "MLCollectionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MLCollectgoodsModel.h"
#import "MLCheckBoxButton.h"
#import "MJExtension.h"
#import "MLHttpManager.h"
#import "MLGoodsDetailsViewController.h"
#import "MLLoginViewController.h"

@interface MLCollectionViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_collectionArray;
    NSString *userid;
    BOOL isSelect;
   
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MLWishlistFootView *footView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *goodslistArray;

@end

static BOOL isEditing = NO;
static NSInteger page = 1;

@implementation MLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品收藏";
    isEditing = NO;
    [self loadDate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    _collectionArray = [NSMutableArray array];
    _goodslistArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
       
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        
    }];
    
    _footView = ({
        MLWishlistFootView *footView = [MLWishlistFootView WishlistFootView];
        footView.addCartBlock = ^(){
            NSLog(@"收藏商品加入购物车");
            for (MLCollectgoodsModel *model in self.goodslistArray) {

                [self addToCartWithPID:model.pid array: model.setmeal];

            }
    
        };
        footView.deleteBlock = ^(){
            NSLog(@"收藏商品取消");
            NSMutableString *str= [[NSMutableString alloc]init];
            for (MLCollectgoodsModel *model in self.goodslistArray) {
                
                str = [[str stringByAppendingFormat:@"%@,",model.ID] mutableCopy];
            }
            
            [self deleteWishlistWithID:[str copy]];
            
        };
        
        footView.selectAllBlock = ^(BOOL isSelected){
            NSLog(@"收藏商品全选择");
            
            [self.goodslistArray removeAllObjects];
            if (isSelected) {
                
                [self.goodslistArray addObjectsFromArray:self.dataSource];
                for (MLCollectgoodsModel *model in self.goodslistArray) {
                    model.isSelect = YES;
                }
            }
            else{
                for (MLCollectgoodsModel *model in self.dataSource) {
                    model.isSelect = NO;
                }
            }
            [self.tableView reloadData];
            
        };
        footView.hidden = YES;
        [self.view addSubview:footView];
        footView;
    });
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
   // [self.tableView.header beginRefreshing];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeEditState:)];
    right.tintColor = RGBA(174, 142, 93, 1);
    
    self.navigationItem.rightBarButtonItem = right;
    
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{

    [self loadDate];
    
    [self.tableView reloadData];
}

- (void)loadDate {
    
    /*
     http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
    【post】
     do=sel   【操作码】
     uid=20505 【用户id】
   
  */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
     NSDictionary *params = @{@"do":@"sel"};

    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
        if ([responseObject[@"code"]isEqual:@0]) {
            _collectionArray = responseObject[@"data"][@"share_list"];
            
            __weak typeof(self) weakself = self;
            
            if (_collectionArray.count>0) {
                
                if (page == 1) {
                    [self.dataSource removeAllObjects];
                }
                
                [self.dataSource addObjectsFromArray:[MLCollectgoodsModel mj_objectArrayWithKeyValuesArray:_collectionArray]];
                
                NSLog(@"self.goods===%@",self.dataSource);
                
                [self.tableView reloadData];
                
            }else{
                self.footView.hidden = YES;
                [self.dataSource removeAllObjects];
                [self.tableView reloadData];
                [self.view configBlankPage:EaseBlankPageTypeShouCang hasData:(self.dataSource.count>0)];
                self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
                    weakself.tabBarController.selectedIndex = 1;
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                };
            }
        }else if ([responseObject[@"code"]isEqual:@1002]){
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"登录超时，请重新登录";
            [_hud hide:YES afterDelay:1];
            [self loginAction:nil];
            
        }
        
       
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    
}
#pragma mark- UITableViewDataSource And UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLCollectionTableViewCell" ;
    MLCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.checkBoxbtn.hidden = !isEditing;
    if (!isEditing) {
        cell.selectW.constant  = 0;
    }else{
        cell.selectW.constant  = 20;
    }
    
    MLCollectgoodsModel *tempDic = self.dataSource[indexPath.section];
    
    cell.pName.text = tempDic.pname;
    cell.pPrice.text = [NSString stringWithFormat:@"￥%@",tempDic.price];
    NSString *image = tempDic.image;
    if (![image isKindOfClass:[NSNull class]]) {
        
      
        if ([image hasSuffix:@"webp"]) {
            [cell.pImage setZLWebPImageWithURLStr:image withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
             [cell.pImage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"imageloading"]];
        }
    }else{
        cell.pImage.image = [UIImage imageNamed:@"imageloading"];
    }


    
    MLCollectgoodsModel *model = [self.dataSource objectAtIndex:indexPath.section];
 
    cell.goodslistModel = model;

    cell.checkBoxbtn.isSelected = model.isSelect;
    __weak typeof(self) weakself = self;
    cell.goodslistCheckBlock = ^(BOOL isSelected){
        model.isSelect = isSelected;
        if (isSelected) {
            [weakself.goodslistArray addObject:model];
            
            NSLog(@"goodlist===%@",_goodslistArray);
            
        }
        else{
            [weakself.goodslistArray removeObject:model];
        }
        if (weakself.goodslistArray.count == self.dataSource.count) {
            _footView.checkBoxBtn.isSelected = YES;
        }else{
            _footView.checkBoxBtn.isSelected = NO;
            
        }
    };
    
    

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  110.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *tempdic = [self.dataSource[indexPath.section] mj_keyValues];
    
    vc.paramDic = @{@"id":tempdic[@"pid"]};
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//收藏商品 加入购物车
- (void)addToCartWithPID:(NSString *)PID array:(NSArray*)array{
    /*
     //批量加入购物车
     http://bbctest.matrojp.com/api.php?m=product&s=cart&action=mul_add_cart
     POST
     
     id=12301 商品id    商品详情接口里的   pinfo  下的id
     
     nums=1 商品数量
     
     sid=12311 商品规格ID    没有规格的填0 有规格填 商品详情接口里的   pinfo  下的 property  下的 id 字段
     
     sku=0  商品货号   没有规格的时候填商品详情接口里的   pinfo  下的code,如果是带规格的那么填pinfo  下的 property  下的 sku字段
     */
    NSString *nums = @"1";
    NSLog(@"goodlist===%@",_goodslistArray);
    
    NSArray *dicArr = [MLCollectgoodsModel mj_keyValuesArrayWithObjectArray:_goodslistArray];
    NSLog(@"%@",dicArr);
    
    
    NSString *idstr;
    NSString *sid;
    NSString *sku;
   
    NSMutableDictionary *cart_listDic = [NSMutableDictionary dictionary];
 
    for (int i=0; i < dicArr.count; i++) {
        
        idstr = dicArr[i][@"pid"];
        sid = dicArr[i][@"setmeal"][0][@"sid"];
        sku = dicArr[i][@"setmeal"][0][@"code"];
        NSString *paramstr = [NSString stringWithFormat:@"%@,%@,%@,%@",idstr,nums,sid,sku];
        NSString *cart_list = [NSString stringWithFormat:@"cart_list[%d]",i];
        [cart_listDic setObject:paramstr forKey:cart_list];
       
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=mul_add_cart",MATROJP_BASE_URL];
       
    NSDictionary *params = cart_listDic;
    NSLog(@"params===%@",params);
    
    [MLHttpManager post:urlStr params:params m:@"product" s:@"cart" success:^(id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
//        NSString *code = result[@"code"];
        if ([result[@"code"] isEqual:@0]) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"加入购物袋成功";
            [_hud hide:YES afterDelay:1];
        }else if ([result[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"登录超时，请重新登录";
            [_hud hide:YES afterDelay:1];
            [self loginAction:nil];
            
        }
        NSLog(@"请求成功 result====%@",result);
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    
}

//取消商品收藏
- (void)deleteWishlistWithID:(NSString *)ID{
   
    /*
     http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
     
     【post】
     
     do=del 【操作码】
     
     id=2281 【收藏商品id】
     */
    NSString *dostr;
    NSString *str = @",";
    if ([ID rangeOfString:str].location != NSNotFound) {
        NSLog(@"选择了多个商品");
        dostr = @"delall";
        
        
    }else{
        NSLog(@"只选择了一个商品");
        dostr = @"del";
    }
    
            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
            NSDictionary *params = @{@"do":dostr,@"id":ID};
    
    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"]isEqual:@0]) {
            NSString *share_add = result[@"data"][@"ads_del"];
            if (share_add) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"取消收藏成功";
                [_hud hide:YES afterDelay:2];
                [self loadDate];
                
                [self.tableView reloadData];
            }else{
                
            }
        }else if ([result[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"登录超时，请重新登录";
            [_hud hide:YES afterDelay:1];
            [self loginAction:nil];
            
        }
        
        
        
        NSLog(@"请求成功 result====%@",result);
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];

}

- (void)changeEditState:(UIBarButtonItem *)sender
{
    isEditing = !isEditing;
    sender.title = isEditing?@"完成":@"编辑";
    
    [self.tableView reloadData];
    
    self.footView.hidden = !isEditing;
    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray *)goodslistArray{
    if(!_goodslistArray){
        _goodslistArray = [NSMutableArray array];
    }
    return _goodslistArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

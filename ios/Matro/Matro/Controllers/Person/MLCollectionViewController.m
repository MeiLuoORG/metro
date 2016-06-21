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
#import "MLWishlistModel.h"
#import "MLCheckBoxButton.h"
#import "MJExtension.h"

@interface MLCollectionViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_collectionArray;
    NSString *userid;
    BOOL isSelect;
   
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MLWishlistFootView *footView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *wishlistArray;
@end

static BOOL isEditing = NO;
static NSInteger page = 1;

@implementation MLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品收藏";
    [self loadDate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    _collectionArray = [NSMutableArray array];
    
    
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
            for (MLWishlistModel *model in self.wishlistArray) {
                [self addToCartWithPID:model.PID];
            }
             
            
        };
        footView.deleteBlock = ^(){
            NSLog(@"收藏商品取消");
            NSMutableString *str= [[NSMutableString alloc]init];
            for (MLWishlistModel *model in self.wishlistArray) {
                
                str = [[str stringByAppendingFormat:@"%@,",model.ID] mutableCopy];
            }
            
            [self deleteWishlistWithID:[str copy]];
            
        };
        
        footView.selectAllBlock = ^(BOOL isSelected){
            NSLog(@"收藏商品全选择");
            
            [self.wishlistArray removeAllObjects];
            if (isSelected) {
                
                [self.wishlistArray addObjectsFromArray:self.dataSource];
                for (MLWishlistModel *model in self.wishlistArray) {
                    model.isSelect = YES;
                }
            }
            else{
                for (MLWishlistModel *model in self.dataSource) {
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
    
    [self.tableView.header beginRefreshing];
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeEditState:)];
    right.tintColor = RGBA(174, 142, 93, 1);
    
    self.navigationItem.rightBarButtonItem = right;
    
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadDate {
    
    /*
     http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
    【post】
     do=sel   【操作码】
     uid=20505 【用户id】
     
     //暂时测试用的  以后要删除
     &test_phone=13771961207
  */
    
    NSString *urlStr = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product&test_phone=13771961207"];
     NSDictionary *params = @{@"do":@"sel"};
    

    [[HFSServiceClient sharedJSONClientNOT] POST:urlStr parameters:params constructingBodyWithBlock:^void(id<AFMultipartFormData> formData){
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject===%@",responseObject);
        _collectionArray = responseObject[@"data"][@"share_list"];
        
        __weak typeof(self) weakself = self;
        
        if (_collectionArray.count>0) {
            if (page == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:[MLWishlistModel mj_objectArrayWithKeyValuesArray:_collectionArray]];
            [self.tableView reloadData];
            
            [self.view configBlankPage:EaseBlankPageTypeShouCang hasData:(self.dataSource.count>0)];
            self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
                weakself.tabBarController.selectedIndex = 1;
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            };
            
        }
        
        
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    
    
    
}
#pragma mark- UITableViewDataSource And UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _collectionArray.count;
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
    
    NSDictionary *tempDic = _collectionArray[indexPath.section];
    
    cell.pName.text = tempDic[@"pname"];
    cell.pPrice.text = [NSString stringWithFormat:@"￥%@",tempDic[@"price"]];
    NSString *image = tempDic[@"image"];
    if (![image isKindOfClass:[NSNull class]]) {
        
       [cell.pImage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"imageloading"]];
        
    }else{
        cell.pImage.image = [UIImage imageNamed:@"imageloading"];
    }
    
    
    
    
    MLWishlistModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.wishlistModel = model;
    cell.checkBoxbtn.isSelected = model.isSelect;
    __weak typeof(self) weakself = self;
    cell.wishlistCheckBlock = ^(BOOL isSelected){
        model.isSelect = isSelected;
        if (isSelected) {
            [weakself.wishlistArray addObject:model];
        }
        else{
            [weakself.wishlistArray removeObject:model];
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
    
}

//收藏商品 加入购物车
- (void)addToCartWithPID:(NSString *)PID{
    /*
     http://localbbc.matrojp.com/api.php?m=product&s=cart&action=add_cart
     
     POST
     
     id=12301 商品id    商品详情接口里的   pinfo  下的id
     
     nums=1 商品数量
     
     sid=12311 商品规格ID    没有规格的填0 有规格填 商品详情接口里的   pinfo  下的 property  下的 id 字段
     
     sku=0  商品货号   没有规格的时候填商品详情接口里的   pinfo  下的code,如果是带规格的那么填pinfo  下的 property  下的 sku字段
     
     
     */
    
        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=add_cart",@"http://bbctest.matrojp.com"];
        NSDictionary *params = @{@"id":PID,@"nums":@1,@"sid":@"0",@"sku":@"0"};
        
        
        [[HFSServiceClient sharedJSONClientNOT]POST:urlStr parameters:params constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSDictionary *result = (NSDictionary *)responseObject;
             NSString *code = result[@"code"];
             if ([code isEqual:@0]) {
                 [_hud show:YES];
                 _hud.mode = MBProgressHUDModeText;
                 _hud.labelText = @"加入购物车成功";
                 [_hud hide:YES afterDelay:2];
             }
             NSLog(@"请求成功 result====%@",result);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败 error===%@",error);
             [_hud show:YES];
             _hud.mode = MBProgressHUDModeText;
             _hud.labelText = @"加入购物车失败";
             [_hud hide:YES afterDelay:2];
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
    
            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",@"http://bbctest.matrojp.com&test_phone=13771961207"];
            NSDictionary *params = @{@"do":dostr,@"id":ID};
            
            
            [[HFSServiceClient sharedJSONClientNOT]POST:urlStr parameters:params constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSDictionary *result = (NSDictionary *)responseObject;
                 NSString *share_add = result[@"data"][@"ads_del"];
                 if (share_add) {
                     [_hud show:YES];
                     _hud.mode = MBProgressHUDModeText;
                     _hud.labelText = @"取消收藏成功";
                     [_hud hide:YES afterDelay:2];
                 }else{
                     
                 }
                 NSLog(@"请求成功 result====%@",result);
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"请求失败 error===%@",error);
                 
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


- (NSMutableArray *)wishlistArray{
    if(!_wishlistArray){
        _wishlistArray = [NSMutableArray array];
    }
    return _wishlistArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

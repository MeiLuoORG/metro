//
//  MLStoreCollectViewController.m
//  Matro
//
//  Created by Matro on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLStoreCollectViewController.h"
#import "MLstoreCollectTableViewCell.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "UIImageView+WebCache.h"
#import "MLCollectstoresModel.h"
#import "MLCheckBoxButton.h"
#import "MLStoreFootView.h"
#import "CommonHeader.h"
#import "MJExtension.h"
#import "MLHttpManager.h"
#import "MLShopInfoViewController.h"
@interface MLStoreCollectViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_collectionArray;
    NSString *userid;
    BOOL isSelect;
    
}

@property (weak, nonatomic) IBOutlet UITableView *_tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *storeslistArray;
@property (nonatomic,strong)MLStoreFootView *footView;

@end
static BOOL isEditing = NO;
static NSInteger page = 1;

@implementation MLStoreCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺收藏";
    isEditing = NO;
    [self loadDate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    
    _collectionArray = [NSMutableArray array];
    
    
    self._tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self._tableView.header endRefreshing];
        [self._tableView reloadData];
        
    }];
    
    self._tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self._tableView.footer endRefreshing];
        [self._tableView reloadData];
        
    }];
    
    
   
    _footView = ({
        MLStoreFootView *footView = [MLStoreFootView MLStoreFootView];
       
        footView.cancelBlock = ^(){
            
             NSMutableString *str= [[NSMutableString alloc]init];
             for (MLCollectstoresModel *model in self.storeslistArray) {
             
             str = [[str stringByAppendingFormat:@"%@,",model.ID] mutableCopy];
             }
             
             [self cancelWishlistWithID:str];

             
        };
        
        footView.selectAllBlock = ^(BOOL isSelected){
            
             [self.storeslistArray removeAllObjects];
             if (isSelected) {
             [self.storeslistArray addObjectsFromArray:self.dataSource];
             for (MLCollectstoresModel *model in self.storeslistArray) {
             model.isSelect = YES;
             }
             }
             else{
             for (MLCollectstoresModel *model in self.dataSource) {
             model.isSelect = NO;
             }
             }
             [self._tableView reloadData];
            
        };
        footView.hidden = YES;
        [self.view addSubview:footView];
        footView;
    });

    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    
    [self._tableView.header beginRefreshing];
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeEditState:)];
    right.tintColor = RGBA(174, 142, 93, 1);
    
    self.navigationItem.rightBarButtonItem = right;
}

- (void)loadDate {
    
    /*
     http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_shop
     
     【post】
     
     do=sel
     
     //暂时测试用的  以后要删除
     &test_phone=13771961207
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
    NSDictionary *params = @{@"do":@"sel"};
    
    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
        
        if ([responseObject[@"data"][@"shop_list"] isKindOfClass:[NSString class]]) {
            
            [self.dataSource removeAllObjects];
            [self._tableView reloadData];
            [self.view configBlankPage:EaseBlankPageTypeShouCangstore hasData:(self.dataSource.count>0)];
           
        }else{
            _collectionArray = responseObject[@"data"][@"shop_list"];
            
            __weak typeof(self) weakself = self;
            
            if (_collectionArray.count>0) {
                
                if (page == 1) {
                    
                    [self.dataSource removeAllObjects];
                }
                [self.dataSource addObjectsFromArray:[MLCollectstoresModel mj_objectArrayWithKeyValuesArray:_collectionArray]];
                
                [self._tableView reloadData];
       
                
            }else{
                
                [self.dataSource removeAllObjects];
                [self._tableView reloadData];
                [self.view configBlankPage:EaseBlankPageTypeShouCangstore hasData:(self.dataSource.count>0)];
               
            }
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
    
    static NSString *CellIdentifier = @"MLstoreCollectTableViewCell" ;
    MLstoreCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    
    MLCollectstoresModel *tempDic = self.dataSource[indexPath.section];
    
    cell.sName.text = tempDic.shopname;
    cell.sPrice.text = [NSString stringWithFormat:@"%@ 分",tempDic.score];
    cell.sProgress.progress = [tempDic.score floatValue]/5.f;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    cell.sProgress.transform = transform;
    
    NSString *logo = tempDic.logo;
    if (![logo isKindOfClass:[NSNull class]]) {
        
        [cell.sImage sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        
    }else{
        cell.sImage.image = [UIImage imageNamed:@"icon_default"];
    }
 
     MLCollectstoresModel *model = [self.dataSource objectAtIndex:indexPath.section];
     cell.storeslistModel = model;
     cell.checkBoxbtn.isSelected = model.isSelect;
     __weak typeof(self) weakself = self;
     cell.storeslistCheckBlock = ^(BOOL isSelected){
     model.isSelect = isSelected;
     if (isSelected) {
         [weakself.storeslistArray addObject:model];
     }
     else{
         [weakself.storeslistArray removeObject:model];
        }
    if (weakself.storeslistArray.count == self.dataSource.count) {
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
    NSDictionary *dic = [self.dataSource[indexPath.section]mj_keyValues];
    NSLog(@"666%@",dic);
    
    MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    vc.store_link = [NSString stringWithFormat:@"%@/store?sid=%@&uid=%@",@"http://192.168.19.247:3000",dic[@"shopid"],phone];
    vc.uid = dic[@"shopid"];
    vc.shopparamDic = @{@"userid":dic[@"shopid"],@"company":dic[@"shopname"]};
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeEditState:(UIBarButtonItem *)sender
{
    isEditing = !isEditing;
    sender.title = isEditing?@"完成":@"编辑";
    
    [self._tableView reloadData];
    /*
     [self.goodsTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
     make.top.left.right.equalTo(self.view);
     make.bottom.equalTo(self.view).offset(isEditing?-50:0);
     }];
     */
    self.footView.hidden = !isEditing;
    
}

- (void)cancelWishlistWithID:(NSString *)shopID{
    
    /*
     http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_shop
     
     【post】
     
     do  【操作码】
     
     id【收藏店铺id】
     
     批量取消：do=delall    id=32,33,34  【id","隔开】
     */
    NSLog(@"shopID===%@",shopID);
    NSString *dostr;
    NSString *str = @",";
    if ([shopID rangeOfString:str].location != NSNotFound) {
        NSLog(@"选择了多个商品");
        dostr = @"delall";
        
        
    }else{
        NSLog(@"只选择了一个商品");
        dostr = @"del";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
    NSDictionary *params = @{@"do":dostr,@"id":shopID};
    
    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *share_add = result[@"data"][@"shop_delall"];
        if (share_add) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"取消收藏成功";
            [_hud hide:YES afterDelay:2];
            [self loadDate];
            [self._tableView reloadData];
            isEditing = NO;
        }else{
            
        }
        NSLog(@"请求成功 result====%@",result);
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
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
             [self loadDate];
             [self._tableView reloadData];
         }else{
             
         }
         NSLog(@"请求成功 result====%@",result);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败 error===%@",error);
         
     }];
    */
    
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray *)storeslistArray{
    if(!_storeslistArray){
        _storeslistArray = [NSMutableArray array];
    }
    return _storeslistArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

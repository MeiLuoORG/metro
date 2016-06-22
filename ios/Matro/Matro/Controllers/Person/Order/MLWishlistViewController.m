//
//  MLWishlistViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLWishlistViewController.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "Masonry.h"
#import "MLWishlistTableViewCell.h"
#import "MLWishlistFootView.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "MLWishlistModel.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"
#import "HFSUtility.h"



@interface MLWishlistViewController ()<UITableViewDelegate,UITableViewDataSource>{

    BOOL isSelect;
}

//@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)MLWishlistFootView *footView;
@property (nonatomic,strong)NSMutableArray *wishlistArray;

@end


static BOOL isEditing = NO;
static NSInteger page = 1;

@implementation MLWishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    isSelect = YES;
  
    
    //self.view.backgroundColor = [UIColor whiteColor];
    /*
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLWishlistTableViewCell" bundle:nil] forCellReuseIdentifier:kMLWishlistTableViewCell];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
     */
    self.goodsTableView.backgroundColor = RGBA(245, 245, 245, 1);
    self.goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"MLWishlistTableViewCell" bundle:nil] forCellReuseIdentifier:kMLWishlistTableViewCell];
    
    self.goodsTableView.delegate = self;
    self.goodsTableView.dataSource = self;
    /*
    [self.goodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    */
    
    self.goodsTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.goodsTableView.header endRefreshing];
        page = 1;
        [self downLoadList];
    }];
    
    self.goodsTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.goodsTableView.footer endRefreshing];
        [self downLoadList];
    }];
    
    [self.goodsTableView.header beginRefreshing];
    
    /*
    _footView = ({
       MLWishlistFootView *footView = [MLWishlistFootView WishlistFootView];
        footView.addCartBlock = ^(){
            
            for (MLWishlistModel *model in self.wishlistArray) {
                [self addToCartWithSP_ID:model.JMSP_ID];
            }
            
        };
        footView.deleteBlock = ^(){
            NSMutableString *str= [[NSMutableString alloc]init];
            for (MLWishlistModel *model in self.wishlistArray) {
                
               str = [[str stringByAppendingFormat:@"%@,",model.JMSP_ID] mutableCopy];
            }
            
            [self deleteWishlistWithSPID:[str copy]];
        };
        
        footView.selectAllBlock = ^(BOOL isSelected){
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
            [self.goodsTableView reloadData];
        };
        footView.hidden = YES;
        [self.view addSubview:footView];
        footView;
    });
    */
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeEditState:)];
}




- (void)downLoadList{
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID]?:@"";
    
    NSString *url = [NSString stringWithFormat:@"%@ajax/member/myfov.ashx?op=myfov&cnt=10&pageindex=%li&userid=%@",SERVICE_GETBASE_URL,(long)page,userId];
    
    [[HFSServiceClient sharedClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *list = [result objectForKey:@"splist"];
        
        
        __weak typeof(self) weakself = self;

        if (list.count>0) {
            if (page == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:[MLWishlistModel mj_objectArrayWithKeyValuesArray:list]];
            [self.goodsTableView reloadData];
            
            [self.view configBlankPage:EaseBlankPageTypeShouCang hasData:(self.dataSource.count>0)];
            self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
                weakself.tabBarController.selectedIndex = 1;
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            };
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showMessag:@"请求失败" toView:self.view];
    }];
    
}



- (void)deleteWishlistWithSPID:(NSString *)spid{
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    NSString *url = [NSString stringWithFormat:@"%@Ajax/member/myfov.ashx?op=delfov&spid=%@&userid=%@",SERVICE_GETBASE_URL,spid,userId];
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([[result objectForKey:@"SuccFlag"] isEqual:@1]) {
            [MBProgressHUD showMessag:@"取消失败" toView:self.view];
        }
        else{
            [MBProgressHUD showMessag:@"取消成功" toView:self.view];
            [self.goodsTableView.header beginRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD showMessag:@"请求失败" toView:self.view];
    }];

}



- (void)addToCartWithSP_ID:(NSString *)sp_id{
    
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/products.ashx?op=addcart&jmsp_id=%@&spsl=1&userid=%@",SERVICE_GETBASE_URL,sp_id,userid];
    
    HFSServiceClient *_clientNOT = [[HFSServiceClient alloc]init];
    _clientNOT.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
    if (!accessToken) {
        accessToken = @"";
    }
    
    //设置HttpHeader
    [_clientNOT.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppClient"];
    [_clientNOT.requestSerializer setValue:[HFSUtility getSystemVersion] forHTTPHeaderField:@"OS-Version"];
    [_clientNOT.requestSerializer setValue:[HFSUtility getAppVersion] forHTTPHeaderField:@"AppVersion"];
    [_clientNOT.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
    [_clientNOT.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    
    [_clientNOT GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD showMessag:@"加入购物袋成功" toView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showMessag:@"请求失败" toView:self.view];
    }];

    
}



/**
 *  变换按钮状态
 *
 */
- (void)changeEditState:(UIBarButtonItem *)sender
{
    isEditing = !isEditing;
    sender.title = isEditing?@"完成":@"编辑";
    [self.goodsTableView reloadData];
    /*
    [self.goodsTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(isEditing?-50:0);
    }];
     */
    self.footView.hidden = !isEditing;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLWishlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLWishlistTableViewCell forIndexPath:indexPath];
    cell.checkBoxBtn.hidden = !isEditing;
    
    MLWishlistModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.wishlistModel = model;
    cell.checkBoxBtn.isSelected = model.isSelect;
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
    cell.wishlistDeleteBlock = ^(){
        [weakself deleteWishlistWithSPID:model.JMSP_ID];
    };
    cell.wishlistAddCartBlock = ^(){
        [weakself addToCartWithSP_ID:model.JMSP_ID];
    };
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
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



@end

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
#import "HFSProductTableViewCell.h"

#import "MJRefresh.h"
#import "UIView+BlankPage.h"

@interface MLCollectionViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_collectionArray;
    NSString *userid;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品收藏";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    _collectionArray = [NSMutableArray array];
    
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.header endRefreshing];
        [_collectionArray removeAllObjects];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeShouCang hasData:(_collectionArray.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"商品收藏更多按钮");
            
        };
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer endRefreshing];
        [_collectionArray addObjectsFromArray:@[@"",@"",@"",@""]];
        [self.tableView reloadData];
        [self.view configBlankPage:EaseBlankPageTypeShouCang hasData:(_collectionArray.count>0)];
        self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
            NSLog(@"商品收藏更多按钮");
            
        };
    }];
    
    [self.tableView.header beginRefreshing];

    // Do any additional setup after loading the view from its nib.
}

- (void)loadDate {
    NSString *urlStr = [NSString stringWithFormat:@""];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求成功";
        [_hud hide:YES afterDelay:2];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求成功";
        [_hud hide:YES afterDelay:2];
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
    
    static NSString *CellIdentifier = @"HFSProductTableViewCell" ;
    HFSProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  95.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

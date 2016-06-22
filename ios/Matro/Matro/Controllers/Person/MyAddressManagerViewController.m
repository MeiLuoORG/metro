//
//  MyAddressManagerViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/5/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MyAddressManagerViewController.h"
#import "AddressManagerCell.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "MBProgressHUD.h"
#import "MLAddressInfoViewController.h"
#import "UIView+BlankPage.h"
#import "MLAddressListModel.h"
#import "MJExtension.h"
#import "MBProgressHUD+Add.h"


@interface MyAddressManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *addressAry;
    NSString *userid;
    MBProgressHUD *_hud;
    UIButton *lastselbtn;
    NSDictionary *selAddress;
}
@end

@implementation MyAddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址管理";
    userid = [[NSUserDefaults standardUserDefaults] valueForKey:kUSERDEFAULT_USERID];
    addressAry = [[NSMutableArray alloc] init];
    _addressTBView.sectionFooterHeight = 0.1f;
    [self.addBtn setBackgroundColor:[HFSUtility hexStringToColor:@"AE8E5D"]];
    [self.addBtn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
        self.view.backgroundColor = RGBA(245, 245, 245, 1);
    [self loadDateAddressList];

}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return addressAry.count;
}// Default is 1 if not implemented
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"AddressManagerCell" ;
    AddressManagerCell *cell = (AddressManagerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    MLAddressListModel *model = [addressAry objectAtIndex:indexPath.section];
    
    cell.address = model;
    
    __weak typeof(self) weakself = self;
    
    cell.addressManagerEdit = ^(){//编辑记录 跳转到
        MLAddressInfoViewController *vc = [MLAddressInfoViewController new];
        vc.addressSuccess = ^(){
            [weakself loadDateAddressList];
        };
        vc.addressDetail = model;
        vc.isNewAddress = NO;
        weakself.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    cell.addressDefault = ^(){
        [weakself changeAddressStatus:model];
    };
    cell.addressManagerDel = ^(){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除此记录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { //调接口删除
            [weakself delAddress:model];
        }];
        [alert addAction:done];
        [alert addAction:cancel];
        [weakself presentViewController:alert animated:YES completion:nil];
    };
    
    return cell;
}



-(void)addAddress:(id)sender
{
    MLAddressInfoViewController *vc = [MLAddressInfoViewController new];
    vc.isNewAddress = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark 修改默认地址状态
- (void)changeAddressStatus:(MLAddressListModel *)model{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_orderadder&do=setdef&test_phone=13771961207",@"http://bbctest.matrojp.com"];
    NSDictionary *params = @{@"uid":@"21357",@"id":model.ID};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [self loadDateAddressList];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:@"网络错误" toView:self.view];
    }];
    
    

    
    
    
}

- (void)delAddress:(MLAddressListModel *)model{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=member&s=admin_orderadder&do=del&test_phone=13771961207"];
    NSDictionary *params = @{@"id":model.ID};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [self loadDateAddressList];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:@"网络错误" toView:self.view];
    }];
    
}



#pragma mark 获取收货地址清单
- (void)loadDateAddressList {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=member&s=admin_orderadder&do=lists&uid=%@&test_phone=13771961207",@"21357"];
    [[HFSServiceClient sharedJSONClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([result[@"code"] isEqual:@0])
        {
            NSDictionary *data = result[@"data"];
            NSArray *address_lists = data[@"address_lists"];
            
            if (address_lists.count>0) {
                [addressAry removeAllObjects];
                [addressAry addObjectsFromArray:[MLAddressListModel mj_objectArrayWithKeyValuesArray:address_lists]];
            }
            [_addressTBView reloadData];
        }
        [self configBlankView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self configBlankView];
    }];
}


- (void)configBlankView{
     [self.view configBlankPage:EaseBlankPageTypeShouhuodizhi hasData:(addressAry.count>0)];
    __weak typeof(self) weakself = self;
    self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
        NSLog(@"新增收货地址");
        MLAddressInfoViewController *vc = [[MLAddressInfoViewController alloc]init];
        vc.isNewAddress = YES;
        [weakself.navigationController pushViewController:vc animated:YES];
    };

    self.addBtn.hidden = !(addressAry.count>0);
}


@end

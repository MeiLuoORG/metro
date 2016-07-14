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
#import "MLHttpManager.h"
#import "MLPersonAlertViewController.h"


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
    [self.addBtn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    
    
    [self loadDateAddressList];

}


- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
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
        vc.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    cell.addressDefault = ^(){
        [weakself addressAction:model WithAction:@"setdef"];
    };
    cell.addressManagerDel = ^(){
        MLPersonAlertViewController *vc = [MLPersonAlertViewController alertVcWithTitle:@"确定删除此记录" AndAlertDoneAction:^{
            [weakself addressAction:model WithAction:@"del"];
        }];
        [weakself showTransparentController:vc];
    };
    
    return cell;
}



-(void)addAddress:(id)sender
{
    MLAddressInfoViewController *vc = [MLAddressInfoViewController new];
    vc.isNewAddress = YES;
    vc.addressSuccess = ^(){
        [self loadDateAddressList];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}



#pragma mark 修改默认地址状态


- (void)addressAction:(MLAddressListModel *)model WithAction:(NSString *)action{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_orderadder&do=%@",MATROJP_BASE_URL,action];
    NSDictionary *params = @{@"id":model.ID?:@""};
    
    [MLHttpManager post:url params:params m:@"member" s:@"admin_orderadder" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            [MBProgressHUD showMessag:@"操作成功" toView:self.view];
            [self loadDateAddressList];
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}


#pragma mark 获取收货地址清单
- (void)loadDateAddressList {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_orderadder&do=lists",MATROJP_BASE_URL];
    [MLHttpManager get:urlStr params:nil m:@"member" s:@"admin_orderadder" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if([result[@"code"] isEqual:@0])
        {
            NSDictionary *data = result[@"data"];
            NSArray *address_lists = data[@"address_lists"];
            [addressAry removeAllObjects];
            if (address_lists.count>0) {
                
                [addressAry addObjectsFromArray:[MLAddressListModel mj_objectArrayWithKeyValuesArray:address_lists]];
            }
            [_addressTBView reloadData];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        [self configBlankView];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


- (void)configBlankView{
     [self.view configBlankPage:EaseBlankPageTypeShouhuodizhi hasData:(addressAry.count>0)];
    __weak typeof(self) weakself = self;
    self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
        MLAddressInfoViewController *vc = [[MLAddressInfoViewController alloc]init];
        vc.isNewAddress = YES;
        vc.addressSuccess = ^(){
            [weakself loadDateAddressList];
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    self.addBtn.hidden = !(addressAry.count>0);
}


@end

//
//  MLAddressSelectViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddressSelectViewController.h"
#import "AddressManagerCell.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "MBProgressHUD.h"
#import "MLAddressInfoViewController.h"
#import "UIView+BlankPage.h"
#import "MLAddressListModel.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "MLSelAddressTableViewCell.h"
#import "UIView+BlankPage.h"
#import "MLAddressInfoViewController.h"
#import "MBProgressHUD+Add.h"


@interface MLAddressSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)NSMutableArray *addressList;

@end

static MLAddressListModel *selAddress;
@implementation MLAddressSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
    self.title = @"选择收货地址";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLSelAddressTableViewCell" bundle:nil] forCellReuseIdentifier:kSelAddressTableViewCell];
        tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:tableView];
        tableView;
    });
    _footView = ({
        UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [btn setTitle:@"新增收货地址" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundColor:RGBA(178, 148, 88, 1)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3.f;
        [footView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footView).insets(UIEdgeInsetsMake(10, 40, 10, 40));
        }];
        [self.view addSubview:footView];
        footView;
    });
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认选择" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    
    [self loadDateAddressList];
}


- (void)doneAction:(id)sender{
    
    if (!selAddress) {
        [MBProgressHUD showMessag:@"请选择联系人" toView:self.view];
        return;
    }
    if (self.addressSelectBlock) {
        self.addressSelectBlock(selAddress);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)addAddress:(id)sender{
    MLAddressInfoViewController *vc = [[MLAddressInfoViewController alloc]init];
    __weak typeof(self) weakself = self;
    vc.addressSuccess = ^(){ //修改保存或者新增刷新页面
        [weakself loadDateAddressList];
    };
    vc.isNewAddress = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLSelAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelAddressTableViewCell forIndexPath:indexPath];
    MLAddressListModel *model = [self.addressList objectAtIndex:indexPath.row];
    cell.addressModel = model;
    
    cell.checkBox.addSelected = (selAddress == model);
    __weak typeof(self) weakself = self;
    cell.selAddressEditBlock = ^(){
        MLAddressInfoViewController *vc = [MLAddressInfoViewController new];
        vc.addressSuccess = ^(){
            [weakself loadDateAddressList];
        };
        vc.addressDetail = model;
        vc.isNewAddress = NO;
        weakself.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:vc animated:YES];
        
    };
    cell.checkBoxBlock = ^(BOOL isSel){
        selAddress = isSel?model:nil;
        [weakself.tableView reloadData];
    };
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)checkBoxClick:(MLCheckBoxButton *)sender{
    NSInteger index = sender.tag - 100;
    sender.addSelected = !sender.addSelected;
    MLAddressListModel *address = [self.addressList objectAtIndex:index];
    selAddress = sender.addSelected?address:nil;
    [self.tableView reloadData];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLAddressListModel *address = [self.addressList objectAtIndex:indexPath.row];
    MLSelAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    selAddress = cell.checkBox.addSelected?nil:address;
    [self.tableView reloadData];
    
    if (!selAddress) {
        [MBProgressHUD showMessag:@"请选择联系人" toView:self.view];
        return;
    }
    if (self.addressSelectBlock) {
        self.addressSelectBlock(selAddress);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 获取收货地址清单
- (void)loadDateAddressList {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=member&s=admin_orderadder&do=lists&test_phone=13771961207"];
    [[HFSServiceClient sharedJSONClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([result[@"code"] isEqual:@0])
        {
            NSDictionary *data = result[@"data"];
            NSArray *address_lists = data[@"address_lists"];
            
            if (address_lists.count>0) {
                [self.addressList removeAllObjects];
                [self.addressList addObjectsFromArray:[MLAddressListModel mj_objectArrayWithKeyValuesArray:address_lists]];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (NSMutableArray *)addressList{
    if (!_addressList) {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
}


@end

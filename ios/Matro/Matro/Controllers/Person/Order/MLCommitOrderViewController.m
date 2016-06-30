//
//  MLCommitOrderViewController.m
//  Matro
//
//  Created by Matro on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommitOrderViewController.h"
#import "MLInvoiceViewController.h"
#import "MLAddressListViewController.h"

@interface MLCommitOrderViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;

@property (nonatomic,strong)MLInvoiceViewController *invoiceVc;

@property (nonatomic,strong)MLAddressListViewController *addressVc;

@end

@implementation MLCommitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单信息";
    //
    [self.myscrollview  setContentSize:CGSizeMake(MAIN_SCREEN_WIDTH, 2000)];
}
- (IBAction)actDizhi:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.addressVc animated:YES];
}
- (IBAction)actPeisong:(id)sender {
}
- (IBAction)actFapiao:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.invoiceVc animated:YES];
    
}


- (MLAddressListViewController *)addressVc{
    if (!_addressVc) {
        _addressVc = [[MLAddressListViewController alloc]init];
        
        
    }
    return _addressVc;
}

- (MLInvoiceViewController *)invoiceVc{
    if (!_invoiceVc) {
        _invoiceVc = [[MLInvoiceViewController alloc]init];
        _invoiceVc.delegate = self;
        
    }
    return _invoiceVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

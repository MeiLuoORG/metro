//
//  MLTuiHuoChengGongViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuiHuoChengGongViewController.h"
#import "MLReturnsDetailViewController.h"

@interface MLTuiHuoChengGongViewController ()

@end

@implementation MLTuiHuoChengGongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"申请提交成功";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction:(id)sender {
    MLReturnsDetailViewController *vc = [[MLReturnsDetailViewController alloc]init];
    vc.order_id = self.order_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end

//
//  MLTuiHuoChengGongViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTuiHuoChengGongViewController.h"
#import "MLReturnsDetailViewController.h"
#import "MLLoginViewController.h"

@interface MLTuiHuoChengGongViewController ()

@end

@implementation MLTuiHuoChengGongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"申请提交成功";
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
}

- (void)backBtnAction{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction:(id)sender {
    MLReturnsDetailViewController *vc = [[MLReturnsDetailViewController alloc]init];
    vc.order_id = self.order_id;
    vc.pro_id  = self.pro_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end

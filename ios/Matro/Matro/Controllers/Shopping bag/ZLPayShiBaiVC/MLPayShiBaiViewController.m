//
//  MLPayShiBaiViewController.m
//  Matro
//
//  Created by lang on 16/7/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPayShiBaiViewController.h"

@interface MLPayShiBaiViewController ()

@end

@implementation MLPayShiBaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.xuanZeQiTaButton.layer.cornerRadius = 4.0f;
    self.xuanZeQiTaButton.layer.masksToBounds = YES;
}
- (IBAction)qiTaButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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

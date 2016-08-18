//
//  MLErweimaResultViewController.m
//  Matro
//
//  Created by Matro on 16/8/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLErweimaResultViewController.h"

@interface MLErweimaResultViewController ()

@end

@implementation MLErweimaResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.erweimaLab.text = _erweimaStr;
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

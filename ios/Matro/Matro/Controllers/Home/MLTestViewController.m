//
//  MLTestViewController.m
//  Matro
//
//  Created by lang on 16/8/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLTestViewController.h"

@interface MLTestViewController ()

@end

@implementation MLTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.imageView setZLWebPImageWithURLStr:@"" withPlaceHolderImage:PLACEHOLDER_IMAGE];
    
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

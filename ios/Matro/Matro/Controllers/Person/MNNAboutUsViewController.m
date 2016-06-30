//
//  MNNAboutUsViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNAboutUsViewController.h"
#import "QRCodeGenerator.h"

@interface MNNAboutUsViewController () {
    UIScrollView *_scrollView;
}

@end

@implementation MNNAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50);
    [self.view addSubview:_scrollView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.view.frame.size.width, 30)];
    titleLabel.text = @"欢迎来到美罗全球精品购";
    titleLabel.textColor = MS_RGB(38, 14, 0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:titleLabel];
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+20, self.view.frame.size.width-20, 120)];
    introduceLabel.text = @"  美罗全球精品购隶属于苏州函数集团，与2015年成立，旨在让更多人享受到美罗的全球精品。\n\n  美罗全球精品购秉承100%官方正品，分享全球精品的时尚智选理念，与多个国际知名品牌形成官方授权合作，打造成为时尚精品网站的领导者。";
    introduceLabel.font = [UIFont systemFontOfSize:14];
    introduceLabel.textColor = MS_RGB(38, 14, 0);
    introduceLabel.numberOfLines = 0;
    [_scrollView addSubview:introduceLabel];
    UIView *viewimage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    viewimage.layer.borderWidth = 2.0;
    viewimage.layer.borderColor = MS_RGB(231,231,231).CGColor ;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 140, 140)];
    
    viewimage.center = CGPointMake(self.view.frame.size.width/2, CGRectGetMaxY(introduceLabel.frame)+95);
    
    imageView.image = [QRCodeGenerator qrImageForString:@"https://itunes.apple.com/cn/app/su-zhou-mei-luo-jing-pin/id1112037018?mt=8" imageSize:imageView.bounds.size.width];
    
    [viewimage addSubview:imageView];
    [_scrollView addSubview:viewimage];
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(viewimage.frame), CGRectGetMaxY(viewimage.frame)+5, 160, 60)];
    promptLabel.text = @"扫描二维码让您的朋友也可以下载美罗全球购APP";
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.numberOfLines = 0;
    promptLabel.alpha = 0.5;
    [_scrollView addSubview:promptLabel];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    labTitle.center = CGPointMake(self.view.frame.size.width/2, CGRectGetMaxY(promptLabel.frame)+130);
    labTitle.text =@"CopyRight© 2015-2016\n苏州美罗全球精品购有限公司";
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.numberOfLines = 0;
    labTitle.alpha = 0.5;
    
    [_scrollView addSubview:labTitle];
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

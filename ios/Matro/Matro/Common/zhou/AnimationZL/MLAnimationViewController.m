//
//  MLAnimationViewController.m
//  Matro
//
//  Created by lang on 16/7/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAnimationViewController.h"

@interface MLAnimationViewController (){

    UIImageView * _imageviews;

}

@end

@implementation MLAnimationViewController{

    YYAnimationIndicator * _indicator;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    _imageviews = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 100, 25)];
    _imageviews.animationImages = @[[UIImage imageNamed:@"loading0001"],
                                    [UIImage imageNamed:@"loading0006"],
                                    [UIImage imageNamed:@"loading0011"],
                                    [UIImage imageNamed:@"loading0016"],
                                    [UIImage imageNamed:@"loading0021"],
                                    [UIImage imageNamed:@"loading0026"],
                                    [UIImage imageNamed:@"loading0031"],
                                    [UIImage imageNamed:@"loading0036"],
                                    [UIImage imageNamed:@"loading0041"],
                                    [UIImage imageNamed:@"loading0046"],
                                    [UIImage imageNamed:@"loading0050"]
                                    ];
    [self.view addSubview:_imageviews];
    
    //设置动画总时间
    _imageviews.animationDuration=2.0;
    //设置重复次数,0表示不重复
    _imageviews.animationRepeatCount=0;
    //开始动画
    [_imageviews startAnimating];
    
    
    /*
    _indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-60, 100, 120)];
    [_indicator setLoadText:@"努力加载中..."];
    
    [self.view addSubview:_indicator];
    
    [_indicator startAnimation];
     
     */
    // Do any additional setup after loading the view from its nib.
}

- (void)animationBlockAction:(AnimationMLBlock)block{
    self.block = block;
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

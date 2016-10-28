//
//  MLAnimationViewController.m
//  Matro
//
//  Created by lang on 16/7/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAnimationViewController.h"
#import "JPUSHService.h"
#import "Masonry.h"

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
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT)];
    
    imageView.image = [UIImage imageNamed:@"lauchLoadzl"];
    
    [self.view addSubview:imageView];
    
    
    _imageviews = [[UIImageView alloc]initWithFrame:CGRectMake((SIZE_WIDTH-250)/2.0, SIZE_HEIGHT-300.0, 250, 15)];
    
    NSMutableArray * imageArr = [[NSMutableArray alloc]init];
    
    for (int i = 1; i<51; i++) {
        
    
        NSString * str = [NSString stringWithFormat:@"loading00%d",i];
        UIImage * image = [UIImage imageNamed:str];
        [imageArr addObject:image];
    }
    
     [self.view addSubview:_imageviews];
    _imageviews.animationImages = imageArr;
    
    
    //设置动画总时间
    _imageviews.animationDuration=1.0;
    //设置重复次数,0表示不重复
    _imageviews.animationRepeatCount=1;
    //开始动画
    [_imageviews startAnimating];
    
    [self performSelector:@selector(animationEndAction:) withObject:nil afterDelay:1.0f];

    //获取设备id
    NSString *deviceid = [JPUSHService registrationID];
        
}

- (void)animationEndAction:(id)sender{

    self.block(YES);
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

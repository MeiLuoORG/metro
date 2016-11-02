//
//  MLAnimationViewController.m
//  Matro
//
//  Created by lang on 16/7/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAnimationViewController.h"
#import "JPUSHService.h"
#import "AppDelegate.h"

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
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([AppDelegate sharedAppDelegate].isFinished == YES) {
            //设置动画总时间
            _imageviews.animationDuration = 3.0;
            //设置重复次数,0表示不重复
            _imageviews.animationRepeatCount = 1;
            
            //开始动画
            [_imageviews startAnimating];
            
            [self performSelector:@selector(animationEndAction:) withObject:nil afterDelay:3.0f];
        }else{
            
            //设置动画总时间
            _imageviews.animationDuration = 3;
            //设置重复次数,0表示不重复
            _imageviews.animationRepeatCount = 3;
            
            //开始动画
            [_imageviews startAnimating];
            
            [self performSelector:@selector(animationEndAction:) withObject:nil afterDelay:9.0f];
        }
    });
    
    self.reView = [[UIView alloc]initWithFrame:CGRectMake((SIZE_WIDTH-200)/2.0, 400, 200, 80)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 ,0, 200, 40)];
    label.text = @"网络加载失败!\n点击按钮重新加载";
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    [label setFont:[UIFont systemFontOfSize:12]];
    label.textAlignment = NSTextAlignmentCenter;
    [self.reView addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 50, 160, 30)];
    [btn setTitle:@"重新加载" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(rework:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor yellowColor].CGColor;
    btn.layer.cornerRadius = 4.f;
    btn.layer.masksToBounds = YES;
    [self.reView addSubview:btn];
    
    [self.view addSubview:self.reView];
    self.reView.hidden = YES;
        
}

-(void)rework:(id)sender{
    
    if (self.block) {
        [_imageviews startAnimating];
        self.reblock();
    }
}

- (void)animationEndAction:(id)sender{

    if ([AppDelegate sharedAppDelegate].isFinished == YES) {
        self.reView.hidden = YES;
        self.block(YES);
    }else{
        self.reView.hidden = NO;
        self.block(NO);
    }
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

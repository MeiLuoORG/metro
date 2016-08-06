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
    //http://www.websbook.com/sc/upimg/allimg/080224/621830_71717086.jpg
    //http://obh57x2dk.bkt.clouddn.com/OH4H8VH65DW9.webp
    // Do any additional setup after loading the view from its nib.
    
    //self.imageView.image = [UIImage imageWithWebP:@"http://obh57x2dk.bkt.clouddn.com/OH4H8VH65DW9.webp"];
    

    //创建url对象
    NSURL * url = [NSURL URLWithString:@"http://obh57x2dk.bkt.clouddn.com/OH4H8VH65DW9.webp"];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //2.1创建请求方式(默认是get,这一步可以不写)
    [request setHTTPMethod:@"get"];
    
    //创建响应对象(有时会出错)
    NSURLResponse *response = nil;
    
    //创建连接对象
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    self.imageView.image = [UIImage imageWithWebPData:data];
    //self.imageView.image = [UIImage sd_imageWithData:data];
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://obh57x2dk.bkt.clouddn.com/OH4H8VH65DW9.webp"] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    //创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //创建task(该方法内部做了处理,默认使用get)
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",data);
        NSLog(@"%d",[[NSThread mainThread]isMainThread]);
    }];
    
    //启动回话
    [task resume];
    
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

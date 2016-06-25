//
//  ShiMingViewController.m
//  Matro
//
//  Created by lang on 16/6/24.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ShiMingViewController.h"

@interface ShiMingViewController ()

@end

@implementation ShiMingViewController{

    UILabel * _usePhoneLabel;
    UITextField * _xingMingLabel;
    UITextField * _shenFenCardId;
    UIButton * _shangChuanButton;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"实名认证";
    
    NavTopCommonImage * navTop = [[NavTopCommonImage alloc]initWithTitle:@"实名认证"];
    [navTop loadLeftBackButtonwith:0];
    
    [navTop backButtonAction:^(BOOL succes) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //[self.view addSubview:navTop];
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    
    _isRenZheng = NO;
    if (_isRenZheng) {
        [self createView1];
    }
    else{
    
        [self createView2];
    
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(0, 0, 40, 22)];
        [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [rightBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = item;
        
        
    }


}
- (void)createView1{
    //1
    UILabel * zhanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, 65, 22)];
    zhanghuLabel.text = @"账户";
    zhanghuLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:zhanghuLabel];
    
    UILabel * zhangHuValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 22)];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    zhangHuValueLabel.text = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    zhangHuValueLabel.font = [UIFont systemFontOfSize:15.0f];
    zhangHuValueLabel.textAlignment = NSTextAlignmentLeft;
    zhangHuValueLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    [self.view addSubview:zhangHuValueLabel];
    UIView * spView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SIZE_WIDTH, 1)];
    spView.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView];
    
    
    //2
    UILabel * xingMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView.frame)+10, 80, 22)];
    xingMingLabel.text = @"真实姓名";
    xingMingLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:xingMingLabel];
    _xingMingLabel = [[UITextField alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(spView.frame)+1, SIZE_WIDTH-90-19, 41)];
    _xingMingLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _xingMingLabel.enabled = NO;
    [self.view addSubview:_xingMingLabel];
    UIView * spView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 83, SIZE_WIDTH, 1)];
    spView2.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView2];
    
    //3.
    UILabel * shenLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView2.frame)+10, 80, 22)];
    shenLabel.text = @"身份证号";
    shenLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:shenLabel];
    _shenFenCardId = [[UITextField alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(spView2.frame)+1, SIZE_WIDTH-90-19, 41)];
    _shenFenCardId.enabled = NO;
    [self.view addSubview:_shenFenCardId];
    
    //4
    UIView * spView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 123, SIZE_WIDTH, 1)];
    spView3.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView3];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView3.frame)+10, 200, 22)];
    label.text = @"上传身份证正面照";
    [self.view addSubview:label];
    
    _shangChuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shangChuanButton setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton setFrame:CGRectMake(22, CGRectGetMaxY(label.frame)+20, 80, 80)];
    _shangChuanButton.enabled = NO;
    [_shangChuanButton sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiahao"]];
    [self.view addSubview:_shangChuanButton];

    

}

- (void)createView2{
    //1
    UILabel * zhanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 30, 75, 22)];
    zhanghuLabel.text = @"账户";
    zhanghuLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:zhanghuLabel];
   /*
    [zhanghuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    */
    
    UILabel * zhangHuValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 30, 200, 22)];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    zhangHuValueLabel.text = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    zhangHuValueLabel.font = [UIFont systemFontOfSize:15.0f];
    zhangHuValueLabel.textAlignment = NSTextAlignmentLeft;
    zhangHuValueLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    [self.view addSubview:zhangHuValueLabel];
    
    
    //2
    UILabel * xingMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 80, 75, 22)];
    xingMingLabel.text = @"真实姓名";
    xingMingLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:xingMingLabel];

    _xingMingLabel = [[UITextField alloc]initWithFrame:CGRectMake(110, 70, SIZE_WIDTH-110-19, 41)];
    _xingMingLabel.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    _xingMingLabel.layer.borderWidth = 1.0f;
    _xingMingLabel.layer.masksToBounds = YES;
    _xingMingLabel.layer.cornerRadius = 4.0f;
    [self.view addSubview:_xingMingLabel];

    
    //3.
    UILabel * shenLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 130, 75, 22)];
    shenLabel.text = @"身份证号";
    shenLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:shenLabel];
    _shenFenCardId = [[UITextField alloc]initWithFrame:CGRectMake(110, 120, SIZE_WIDTH-110-19, 41)];
    _shenFenCardId.layer.borderColor = [HFSUtility hexStringToColor:Main_bianGrayBackgroundColor].CGColor;
    _shenFenCardId.layer.borderWidth = 1.0f;
    _shenFenCardId.layer.masksToBounds = YES;
    _shenFenCardId.layer.cornerRadius = 4.0f;
    [self.view addSubview:_shenFenCardId];
    //4
    UIView * spView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shenFenCardId.frame)+30, SIZE_WIDTH, 1)];
    spView3.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView3];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView3.frame)+30, 200, 22)];
    label.text = @"上传身份证正面照";
    [self.view addSubview:label];
    
    _shangChuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shangChuanButton setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton setFrame:CGRectMake(22, CGRectGetMaxY(label.frame)+20, 80, 80)];
    [_shangChuanButton addTarget:self action:@selector(shangChuanTuPian) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_shangChuanButton];
    
    //UITextField * zhanghuValueField  = [UITextField alloc]initWithFrame:CGRectMake(112, 20, 200, <#CGFloat height#>);

}


- (void)shangChuanTuPian{
    NSLog(@"点击了上传按钮");

}

- (void)buttonAction{
    

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

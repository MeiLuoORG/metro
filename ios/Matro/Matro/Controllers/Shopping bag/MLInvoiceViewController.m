//
//  MLInvoiceViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLInvoiceViewController.h"

#import "UIButton+HeinQi.h"
#import "HFSConstants.h"

@interface MLInvoiceViewController ()
@property (strong, nonatomic) IBOutlet UIButton *kai;
@property (strong, nonatomic) IBOutlet UIButton *bukai;
@property (weak, nonatomic) IBOutlet UIView *gongsilab;
@property (weak, nonatomic) IBOutlet UIButton *geren;
@property (weak, nonatomic) IBOutlet UIButton *gongsi;
@property (weak, nonatomic) IBOutlet UIView *fapiaoInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gongsiLabH;

@end

@implementation MLInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self invoiceUI];
    self.title = @"发票信息";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction:)];
    right.tintColor = RGBA(192, 159, 116, 1);
    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
//    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.gongsilab.layer.borderWidth = 1.f;
    self.gongsilab.layer.borderColor = RGBA(241, 241, 241, 1).CGColor;
    self.gongsilab.layer.cornerRadius = 4.f;
    self.gongsilab.layer.masksToBounds = YES;
    _gongsiLabH.constant = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    _bukai.selected = !_isNeed;
//    _kai.selected = _isNeed;
//    _putong.selected = _isNeed;
//    _mingxi.selected = _isNeed;
//    _titouTextField.enabled = _isNeed;
//    _titouTextField.text = _isNeed ? @"" : @"";//传入数据
}

- (void)invoiceUI{
    [_kai invoiceselButtonType];
    [_bukai invoiceselButtonType];
    [_geren invoiceselButtonType];
    [_gongsi invoiceselButtonType];

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
- (IBAction)taitouButtonAction:(id)sender {
    UIButton *button = ((UIButton *)sender);
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    
    if ([button isEqual:_geren]) {
        _gongsi.selected = NO;
        _gongsiLabH.constant = 0;
        
    }else{
        _geren.selected = NO;
        _gongsiLabH.constant = 44;
        
    }
    
}

- (IBAction)invoiceButtonAction:(id)sender {
    UIButton *button = ((UIButton *)sender);
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    
    if ([button isEqual:_kai]) {
        _bukai.selected = NO;
        self.fapiaoInfo.hidden = NO;
        
    }else{
        _kai.selected = NO;
        self.fapiaoInfo.hidden = YES;
       
    }
    
}
- (void)saveButtonAction:(id)sender {
    /*
    
    NSString *titou = _titouTextField.text;
    if ([@"" isEqualToString:titou]) {
        titou = @"个人";
    }
    
    [_delegate InvoiceDic:@{
                            @"invoice":_bukai.selected ? @"NO" : @"YES",
                            @"titleText":titou
                            }];
    [self.navigationController popViewControllerAnimated:YES];
     */
}



@end

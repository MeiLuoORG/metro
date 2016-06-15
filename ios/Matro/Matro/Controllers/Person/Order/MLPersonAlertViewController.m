//
//  MLPersonAlertViewController.m
//  AlertView
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import "MLPersonAlertViewController.h"

@interface MLPersonAlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic,copy)NSString *alert_Title;

@end

@implementation MLPersonAlertViewController



+ (MLPersonAlertViewController *)alertVcWithTitle:(NSString *)title{
    MLPersonAlertViewController *vc = [[MLPersonAlertViewController alloc]initWithTitle:title];
    return vc;
}


- (instancetype)initWithTitle:(NSString *)alert_Title{
    if (self = [super init]) {
        self.alert_Title = alert_Title;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.alert_Title;
}

- (IBAction)clickAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) { //取消按钮
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else{
        if (self.alertDoneBlock) {
            self.alertDoneBlock();
        }
        
    }
    
}


@end

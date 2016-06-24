//
//  MLPersonAlertViewController.m
//  AlertView
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import "MLPersonAlertViewController.h"
#import "HFSConstants.h"

@interface MLPersonAlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic,copy)NSString *alert_Title;

@end

@implementation MLPersonAlertViewController

- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


+ (MLPersonAlertViewController *)alertVcWithTitle:(NSString *)title AndAlertDoneAction:(AlertDoneBlock)alertAction{
    MLPersonAlertViewController *vc = [[MLPersonAlertViewController alloc]initWithTitle:title AndAlertDoneAction:(AlertDoneBlock)alertAction];
    return vc;
}


- (instancetype)initWithTitle:(NSString *)alert_Title AndAlertDoneAction:(AlertDoneBlock)alertAction{
    if (self = [super init]) {
        self.alert_Title = alert_Title;
        self.alertDoneBlock = alertAction;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.alert_Title;
    self.cancelBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.cancelBtn.layer.borderWidth = 1.f;
    self.doneBtn.layer.borderWidth = 1.f;
    self.doneBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;


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
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


@end

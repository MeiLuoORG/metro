//
//  MLTuiHuoFooterView.h
//  Matro
//
//  Created by MR.Huang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTuiHuoFooterView : UIView

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


+ (MLTuiHuoFooterView *)footView;


@end

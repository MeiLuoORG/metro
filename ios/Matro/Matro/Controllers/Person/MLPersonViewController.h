//
//  MLPersonViewController.h
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MessagesViewController.h"

@interface MLPersonViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UIControl *vipcardBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipcardHeight;

@property (strong, nonatomic) UIButton * messageButton;

@end

//
//  MLPersonAlertViewController.h
//  AlertView
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertDoneBlock)();

@interface MLPersonAlertViewController : UIViewController
@property (nonatomic,copy)AlertDoneBlock  alertDoneBlock;
+ (MLPersonAlertViewController *)alertVcWithTitle:(NSString *)title;

@end

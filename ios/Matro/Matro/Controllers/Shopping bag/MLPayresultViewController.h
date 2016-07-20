//
//  MLPayresultViewController.h
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLGuessLikeModel.h"
#import "CommonHeader.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "MLAllOrdersViewController.h"
#import "MLPersonOrderDetailViewController.h"
#import "MLShopBagViewController.h"
#import "MLHttpManager.h"
@interface MLPayresultViewController : MLBaseViewController

@property (nonatomic) BOOL isSuccess;
@property (strong, nonatomic) NSString * order_id;
@property (weak, nonatomic) IBOutlet UIButton *XuanZeQiTaButton;

@end

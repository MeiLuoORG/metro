//
//  MyAddressManagerViewController.h
//  Matro
//
//  Created by 陈文娟 on 16/5/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"

typedef void(^AddAddressSuccess)();
@interface MyAddressManagerViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *addressTBView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;



@end

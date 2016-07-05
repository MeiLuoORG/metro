//
//  APPSettingViewController.h
//  Matro
//
//  Created by 陈文娟 on 16/5/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"
#import "HFSServiceClient.h"
#import "CommonHeader.h"
#import "UIViewController+MLMenu.h"



#import "PulldownMenu.h"
#import "AppDelegate.h"


@interface APPSettingViewController : MLBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *settingTable;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

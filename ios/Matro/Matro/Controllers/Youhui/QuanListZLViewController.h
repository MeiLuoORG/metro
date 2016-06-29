//
//  QuanListZLViewController.h
//  Matro
//
//  Created by lang on 16/6/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MJRefresh.h"
#import "LingQuQuanCell.h"

#import "CommonHeader.h"
#import "HFSUtility.h"
#import "VipCardModel.h"
#import "HFSConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YouHuiQuanModel.h"
#import "MLHttpManager.h"
#import "MBProgressHUD.h"
#import "NavTopCommonImage.h"
#import "YouHuiQuanModel.h"
#import "NSString+GONMarkup.h"
@interface QuanListZLViewController : MLBaseViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray * quanListARR;
@property (strong, nonatomic) UITableView * tableView;

@end

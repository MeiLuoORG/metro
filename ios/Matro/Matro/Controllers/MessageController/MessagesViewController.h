//
//  MessagesViewController.h
//  Matro
//
//  Created by lang on 16/5/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MessagesTableViewCell.h"
#import "JSBadgeView.h"
#import "MJRefresh.h"

@interface MessagesViewController : MLBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViews;

@end

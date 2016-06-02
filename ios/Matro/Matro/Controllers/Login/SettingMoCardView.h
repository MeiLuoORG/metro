//
//  SettingMoCardView.h
//  Matro
//
//  Created by lang on 16/6/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "SettingMoCardCell.h"
#import "HFSUtility.h"

@interface SettingMoCardView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * tableview;


- (void)loadViews;

@end

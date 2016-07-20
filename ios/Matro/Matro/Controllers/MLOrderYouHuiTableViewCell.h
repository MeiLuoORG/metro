//
//  MLOrderYouHuiTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommitOrderListModel.h"



typedef void(^UseClick)();
typedef void(^WarningBlock)(NSString*);
@interface MLOrderYouHuiTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,strong)UILabel *rightLabel;

@property (nonatomic,strong)MLOrderCartModel *cart;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)UseClick useClick;
@property (nonatomic,copy)WarningBlock warningBlock;



@end

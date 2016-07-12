//
//  MLOrderYouHuiTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UseClick)();
@interface MLOrderYouHuiTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,strong)UILabel *rightLabel;

@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)UseClick useClick;

@end
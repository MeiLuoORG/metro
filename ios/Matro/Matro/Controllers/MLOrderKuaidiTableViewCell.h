//
//  MLOrderKuaidiTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommitOrderListModel.h"


typedef void(^OrderKuaiDiSelBlock)(NSInteger);

@interface MLOrderKuaidiTableViewCell : UITableViewCell
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,copy)OrderKuaiDiSelBlock orderKuaiDiSel;


@end


@interface OrderKuaidiSubCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subLabel;


@end
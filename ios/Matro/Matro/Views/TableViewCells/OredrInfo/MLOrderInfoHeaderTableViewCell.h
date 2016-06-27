//
//  MLOrderInfoHeaderTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonOrderModel.h"


#define kOrderInfoHeaderTableViewCell @"orderInfoHeaderTableViewCell"
@interface MLOrderInfoHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic,strong)MLPersonOrderModel *orderList;



@end

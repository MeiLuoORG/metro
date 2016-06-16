//
//  MNNPurchaseHistoryTableViewCell.h
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "HFSUtility.h"

@interface MNNPurchaseHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel * time;
@property (strong, nonatomic) UILabel * timeLabel;
@property (strong, nonatomic) UILabel * money;
@property (strong, nonatomic) UILabel * moneyLabel;
@property (strong, nonatomic) UILabel * integral;
@property (strong, nonatomic) UILabel * integralLabel;
@property (strong, nonatomic) UILabel * address;
@property (strong, nonatomic) UILabel * addressLabel;

@end

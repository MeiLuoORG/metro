//
//  MLPushConfigTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPushConfigTableViewCell @"pushConfigTableViewCell"
typedef void(^PushConfigChange)(BOOL);

@interface MLPushConfigTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,copy)PushConfigChange pushConfigChange;

@property (weak, nonatomic) IBOutlet UISwitch *switchs;
@end

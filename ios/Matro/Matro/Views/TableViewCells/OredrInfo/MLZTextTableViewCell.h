//
//  MLZTextTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kZTextTableViewCell @"kTextTableViewCell"
@interface MLZTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

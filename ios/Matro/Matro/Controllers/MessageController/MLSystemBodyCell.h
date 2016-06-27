//
//  MLSystemBodyCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSystemBodyCell  @"systemBodyCell"
@interface MLSystemBodyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

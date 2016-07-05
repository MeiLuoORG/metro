//
//  MLActMessageBodyCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kActMessageBodyCell  @"actMessageBodyCell"

typedef void(^DelAction)();
@interface MLActMessageBodyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *actImage;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic,copy)DelAction delAction;

@end

//
//  MLZTTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kZTTableViewCell @"ZTTableViewCell"

@interface MLZTTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ztLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

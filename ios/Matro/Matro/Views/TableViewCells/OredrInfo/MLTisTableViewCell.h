//
//  MLTisTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTisTableViewCell  @"TisTableViewCell"
@interface MLTisTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *tisLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@end

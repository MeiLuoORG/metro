//
//  MLServiceTracksTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMLServiceTracksTableViewCell @"MLServiceTracksTableViewCell"

@interface MLServiceTracksTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *caoZuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleLeft;

@end

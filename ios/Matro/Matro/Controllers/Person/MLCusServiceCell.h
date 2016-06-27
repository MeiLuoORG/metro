//
//  MLCusServiceCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMLCusServiceCell  @"cusServiceCell"

@interface MLCusServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mySubLabel;

@end

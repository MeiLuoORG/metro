//
//  MLOrderSubTextTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOrderSubTextTableViewCell @"orderSubTextTableViewCell"
@interface MLOrderSubTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

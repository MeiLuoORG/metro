//
//  MLReturnsWentiTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kReturnsWentiTableViewCell  @"returnsWentiTableViewCell"

@interface MLReturnsWentiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wentiDesc;
@property (weak, nonatomic) IBOutlet UILabel *wentiText;

@end

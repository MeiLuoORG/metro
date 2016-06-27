//
//  MLCommentDetailUserTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommentProductModel.h"
#define kCommentDetailUserTableViewCell @"commentDetailUserTableViewCell"
@interface MLCommentDetailUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic,strong)MLProductCommentDetailByuser *buyUser;


@end

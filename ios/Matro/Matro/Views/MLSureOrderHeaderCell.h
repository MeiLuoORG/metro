//
//  MLSureOrderHeaderCell.h
//  Matro
//
//  Created by Matro on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KMLSureOrderHeaderCell  @"MLSureOrderHeaderCell"
typedef void(^SelectAddrActionBlock)();

@interface MLSureOrderHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLab;
@property (weak, nonatomic) IBOutlet UILabel *userphoneLab;
@property (weak, nonatomic) IBOutlet UILabel *useraddressLab;
@property (weak, nonatomic) IBOutlet UIButton *selectAddr;
@property (nonatomic,copy)SelectAddrActionBlock selectAddrblock;

@end

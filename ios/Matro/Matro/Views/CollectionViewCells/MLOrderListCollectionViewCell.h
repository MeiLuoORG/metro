//
//  MLOrderListCollectionViewCell.h
//  Matro
//
//  Created by Matro on 16/7/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommitOrderListModel.h"

#define KMLOrderListCollectionViewCell  @"MLOrderListCollectionViewCell"
@interface MLOrderListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderImg;
@property (weak, nonatomic) IBOutlet UILabel *orderTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderGuige;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (nonatomic,strong)MLOrderProlistModel *prolistModel;

@end

//
//  MLAfterSaleHeadCell.h
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMLAfterSaleHeadCell  @"ml_afterSaleHeadCell"
@interface MLAfterSaleHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *tuikuanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouHouLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuiHuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;

@end

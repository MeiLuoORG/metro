//
//  MLOrderInfoFooterTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonOrderModel.h"

#define kOrderInfoFooterTableViewCell  @"orderInfoFooterTableViewCell"

typedef void(^LeftCancelAction)();
typedef void(^LeftShouHuoAction)();
typedef void(^LeftPingJiaAction)();
typedef void(^LeftKanPingJiaAction)();

typedef void(^RightZhuiZongAction)();
typedef void(^RightTuiHuoAction)();
typedef void(^RightFuKuanAction)();



@interface MLOrderInfoFooterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)MLPersonOrderModel *orderList;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;


@property (nonatomic,copy)LeftCancelAction cancelAction;
@property (nonatomic,copy)LeftShouHuoAction shouHuoAction;
@property (nonatomic,copy)LeftPingJiaAction pingJiaAction;
@property (nonatomic,copy)LeftKanPingJiaAction kanPingJiaAction;
@property (nonatomic,copy)RightZhuiZongAction zhuiZongAction;
@property (nonatomic,copy)RightTuiHuoAction tuiHuoAction;
@property (nonatomic,copy)RightFuKuanAction fuKuanAction;


@end

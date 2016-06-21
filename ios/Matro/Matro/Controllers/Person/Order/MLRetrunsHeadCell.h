//
//  MLRetrunsHeadCell.h
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTuiHuoModel.h"


typedef void(^TuihuoActionBlock)();

#define kMLRetrunsHeadCell @"MLRetrunsHeadCell"
@interface MLRetrunsHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (nonatomic,strong)MLTuiHuoModel *tuihuoModel;

@property (nonatomic,copy)TuihuoActionBlock tuihuoBlock;


@end

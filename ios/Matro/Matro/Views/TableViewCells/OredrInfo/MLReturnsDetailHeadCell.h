//
//  MLReturnsDetailHeadCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTuiHuoModel.h"


typedef void(^ReturnsDetailAction)();


#define kReturnsDetailHeadCell  @"returnsDetailHeadCell"
@interface MLReturnsDetailHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bianjiBtn;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;

@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouHouLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuiHuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic,strong)MLTuiHuoModel *tuiHuoModel;




@end

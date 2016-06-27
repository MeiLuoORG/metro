//
//  MLReturnsDetailHeadCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLReturnsDetailModel.h"


typedef void(^ReturnsDetailKeFuAction)();
typedef void(^ReturnsDetailQuxiaoAction)();
typedef void(^ReturnsDetailBianjiAction)();

#define kReturnsDetailHeadCell  @"returnsDetailHeadCell"
@interface MLReturnsDetailHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bianjiBtn;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;

@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouHouLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuiHuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (nonatomic,strong)MLReturnsDetailModel *tuiHuoModel;

@property (nonatomic,copy)ReturnsDetailKeFuAction returnsDetailKeFuAction;
@property (nonatomic,copy)ReturnsDetailQuxiaoAction returnsDetailQuxiaoAction;
@property (nonatomic,copy)ReturnsDetailBianjiAction returnsDetailBianjiAction;

@end

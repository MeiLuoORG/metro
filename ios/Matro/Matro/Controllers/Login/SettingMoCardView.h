//
//  SettingMoCardView.h
//  Matro
//
//  Created by lang on 16/6/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "SettingMoCardCell.h"
#import "HFSUtility.h"
#import "VipCardModel.h"

typedef void(^BindButtonBlock)(BOOL success);

@interface SettingMoCardView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (copy, nonatomic) BindButtonBlock block;
@property (strong, nonatomic) UITableView * tableview;
@property (strong, nonatomic) NSArray * cardARR;
@property (strong, nonatomic) NSString * cardNoString;

@property (assign, nonatomic) NSString * cardTypeStr;


@property (strong, nonatomic) UIButton * OKButton;

- (void)bindButtonBlockAction:(BindButtonBlock )block;
- (void)loadViews;

@end

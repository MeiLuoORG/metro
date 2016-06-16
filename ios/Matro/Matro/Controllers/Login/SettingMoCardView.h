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
#import "HFSConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef void(^BindButtonBlock)(BOOL success);

@interface SettingMoCardView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (copy, nonatomic) BindButtonBlock block;
@property (strong, nonatomic) UITableView * tableview;
@property (strong, nonatomic) NSArray * cardARR;
@property (strong, nonatomic) NSString * cardNoString;
@property (assign, nonatomic) NSString * cardTypeStr;
@property (strong, nonatomic) UIButton * OKButton;
@property (strong, nonatomic) NSString * cardTypeName;

@property (strong, nonatomic) NSMutableArray * selectedBtnARR;
@property (strong, nonatomic) NSMutableDictionary * selectedBtnDic;
@property (strong, nonatomic) NSString * currentSelectIndex;

- (void)bindButtonBlockAction:(BindButtonBlock )block;
- (void)loadViews;

@end

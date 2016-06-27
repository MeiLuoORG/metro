//
//  LingQuYouHuiQuanView.h
//  Matro
//
//  Created by lang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LingQuQuanCell.h"
#import "CommonHeader.h"

#import "HFSUtility.h"
#import "VipCardModel.h"
#import "HFSConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YouHuiQuanModel.h"
typedef void(^HideTableViewBlock)(BOOL success);
typedef void(^SelectQuanCellBlock)(BOOL success,YouHuiQuanModel * ret);

@interface LingQuYouHuiQuanView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic)  HideTableViewBlock hideBlock;
@property (copy, nonatomic)  SelectQuanCellBlock selectQuanBlock;
@property (strong, nonatomic) UITableView * tablieview;
@property (strong, nonatomic) NSMutableArray * quanARR;

- (void)setHideBlockAction:(HideTableViewBlock)hideBlock;
- (void)selectQuanBlockAction:(SelectQuanCellBlock)selectQuanBlock;
- (void)createView;//13822223333  13833334444

@end

//
//  MLTuiHuoFukuanTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTuiHuoFukuanTableViewCell @"tuiHuoFukuanTableViewCell"


typedef void(^TuiHuoFukuanFaPiaoBlock)(BOOL);

@interface MLTuiHuoFukuanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *haveBtn;
@property (weak, nonatomic) IBOutlet UIButton *notBtn;
@property (nonatomic,copy)TuiHuoFukuanFaPiaoBlock tuiHuoFukuanFaPiaoBlock;

@property (nonatomic,assign)BOOL fapiao;

@end

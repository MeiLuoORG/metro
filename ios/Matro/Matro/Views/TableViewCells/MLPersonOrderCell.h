//
//  MLPersonOrderCell.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DaifahuoBlock)();
typedef void(^DaishouhuoBlock)();
typedef void(^DaifukuanBlock)();
typedef void(^TuihuoBlock)();


#define kMLPersonOrderCell @"MLPersonOrderCell"

@interface MLPersonOrderCell : UITableViewCell

@property (nonatomic,copy)DaifahuoBlock  daifahuoBlcok;
@property (nonatomic,copy)DaishouhuoBlock  daishouhuoBlock;
@property (nonatomic,copy)DaifukuanBlock  daifukuanBlock;
@property (nonatomic,copy)TuihuoBlock   tuihuoBlock;


@end

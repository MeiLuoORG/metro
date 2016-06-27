//
//  MLPersonOrderCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/12.
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

@property (weak, nonatomic) IBOutlet UIImageView *imgDaifahuo;
@property (weak, nonatomic) IBOutlet UIImageView *imgDaifukuan;
@property (weak, nonatomic) IBOutlet UIImageView *imgDaishouhuo;
@property (weak, nonatomic) IBOutlet UIImageView *imgTuikuan;

@end

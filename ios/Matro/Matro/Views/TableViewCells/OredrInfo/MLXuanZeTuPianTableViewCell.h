//
//  MLXuanZeTuPianTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kXuanZeTuPianTableViewCell  @"xuanZeTuPianTableViewCell"

typedef void(^XuanZeTuPianBlock)();

@interface MLXuanZeTuPianTableViewCell : UITableViewCell

@property (nonatomic,strong)NSMutableArray *imgsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,copy)XuanZeTuPianBlock xuanZeTuPianBlock;

@end

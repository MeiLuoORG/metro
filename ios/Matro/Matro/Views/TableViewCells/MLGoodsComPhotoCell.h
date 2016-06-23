//
//  MLGoodsComPhotoCell.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoodsComDelImageBlock)();

#define kMLGoodsComPhotoCell  @"GoodsComPhotoCell"
@interface MLGoodsComPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (nonatomic,copy)GoodsComDelImageBlock goodsComDelImageBlock;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

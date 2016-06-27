//
//  MLSaleServiceImageCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMLSaleServiceImageCell @"mlSaleServiceImageCell"

typedef void(^ServiceImageClickBlock)(NSInteger index);
typedef void(^ServiceImageMoreBlock)();
@interface MLSaleServiceImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *imgBaseView;


@property (nonatomic,strong)NSArray *imgUrlArray;


@property (nonatomic,copy)ServiceImageClickBlock serviceImageClickBlock;
@property (nonatomic,copy)ServiceImageMoreBlock serviceImageMoreBlock;
@end

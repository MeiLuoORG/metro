//
//  MLWenTiBiaoQianTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMJIETagView.h"


#define kWenTiBiaoQianTableViewCell  @"wenTiBiaoQianTableViewCell"

typedef void(^WenTiBiaoQianSelBlock)(NSArray *);

@interface MLWenTiBiaoQianTableViewCell : UITableViewCell<IMJIETagViewDelegate>


@property (nonatomic,strong)NSArray *tags;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;

@property (nonatomic,copy)WenTiBiaoQianSelBlock  wenTiBiaoQianSelBlock;

@property (nonatomic,copy)NSString *clickStr;

@end

//
//  MLGoodsDetailsTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMJIETagView.h"
#import "IMJIETagFrame.h"
typedef void(^GoodsBiaoQianSelBlock)(NSArray *);

@interface MLGoodsDetailsTableViewCell : UITableViewCell<IMJIETagViewDelegate>{

}

@property (nonatomic,copy)GoodsBiaoQianSelBlock  goodsBiaoQianSelBlock;
@property (nonatomic,strong)NSArray *tags;
@property (strong, nonatomic) IBOutlet UILabel *infoTitleLabel;

@property (strong, nonatomic) IBOutlet UIView *tagView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tisH;

@property (nonatomic,copy)NSString *clickStr;

@end

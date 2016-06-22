//
//  MLFootMarkTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMLFootMarkTableViewCell  @"footMarkTableViewCell"

typedef void(^FootMarkAddCartBlock)();
typedef void(^FootMarkDeleteBlock)();
@interface MLFootMarkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *sideView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sideLeft;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *isHotLab;
@property (weak, nonatomic) IBOutlet UILabel *Pname;
@property (weak, nonatomic) IBOutlet UILabel *Pprice;

@property (nonatomic,copy)FootMarkAddCartBlock footMarkAddCartBlock;
@property (nonatomic,copy)FootMarkDeleteBlock  footMarkDeleteBlock;
@end

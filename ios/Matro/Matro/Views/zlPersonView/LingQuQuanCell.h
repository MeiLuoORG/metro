//
//  LingQuQuanCell.h
//  Matro
//
//  Created by lang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LingQuQuanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *jinELabel;

@property (weak, nonatomic) IBOutlet UILabel *youXiaoQiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yiLingQuImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *pingTaiTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mingChengLabel;
@property (weak, nonatomic) IBOutlet UILabel *miaoShuLabel;

@end

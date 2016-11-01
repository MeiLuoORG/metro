//
//  MLWanshanCell.h
//  Matro
//
//  Created by Matro on 2016/11/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WanshanClickBlock)();
@interface MLWanshanCell : UITableViewCell
@property (copy,nonatomic)WanshanClickBlock wanshanBlock;
@property (weak, nonatomic) IBOutlet UIButton *wanshanBtn;
@property (weak, nonatomic) IBOutlet UILabel *wanshanLabel;
@end

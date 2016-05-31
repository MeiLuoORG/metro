//
//  MessagesTableViewCell.h
//  Matro
//
//  Created by lang on 16/5/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meaageTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDescripLabel;

@end

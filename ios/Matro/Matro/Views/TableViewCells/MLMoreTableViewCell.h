//
//  MLMoreTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MoreActionBlock)();

@interface MLMoreTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic,copy)MoreActionBlock moreActionBlock;

@end

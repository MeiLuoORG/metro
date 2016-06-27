//
//  MLTuiHuoMiaoshuTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"



#define kTuiHuoMiaoshuTableViewCell  @"tuiHuoMiaoshuTableViewCell"
@interface MLTuiHuoMiaoshuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

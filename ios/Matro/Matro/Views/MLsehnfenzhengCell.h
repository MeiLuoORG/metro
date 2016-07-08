//
//  MLsehnfenzhengCell.h
//  Matro
//
//  Created by Matro on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KMLsehnfenzhengCell  @"MLsehnfenzhengCell"
typedef void(^SaveSFZActionBlock)();

@interface MLsehnfenzhengCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *SFZHtextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *SFZHLab;

@property (nonatomic,copy)SaveSFZActionBlock saveSFZActionBlock;
@end

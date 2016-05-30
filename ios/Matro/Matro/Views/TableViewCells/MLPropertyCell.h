//
//  MLPropertyCell.h
//  Matro
//
//  Created by Matro on 16/5/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMLPropertyCell  @"PropertyCell"

@interface MLPropertyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *labProperty;

@end

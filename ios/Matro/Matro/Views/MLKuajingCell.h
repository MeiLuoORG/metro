//
//  MLKuajingCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/10.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLKuajingCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shuilvLabel;
+ (MLKuajingCell *)kuajingCell;

@end

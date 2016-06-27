//
//  MLFootTableViewCell.h
//  Matro
//
//  Created by Matro on 16/6/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLFootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pimage;
@property (weak, nonatomic) IBOutlet UILabel *pname;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *pHot;
@property (weak, nonatomic) IBOutlet UIView *sideView;

@end

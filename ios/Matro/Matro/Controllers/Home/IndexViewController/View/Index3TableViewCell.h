//
//  Index3TableViewCell.h
//  Matro
//
//  Created by lang on 16/8/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
typedef void(^Index3TableViewBlock)(int tag);

@interface Index3TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (copy, nonatomic) Index3TableViewBlock index3Block;

- (void)index3BlockAction:(Index3TableViewBlock )block;


@end

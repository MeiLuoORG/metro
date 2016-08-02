//
//  MLFristTableViewCell.h
//  Matro
//
//  Created by Matro on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HotSPClick)();
typedef void(^HotPPClick)();

@interface MLFristTableViewCell : UITableViewCell
@property (copy,nonatomic)HotSPClick hotspClick;
@property (copy,nonatomic)HotPPClick hotppClick;

@end

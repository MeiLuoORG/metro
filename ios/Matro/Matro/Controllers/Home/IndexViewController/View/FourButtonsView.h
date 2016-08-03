//
//  FourButtonsView.h
//  Matro
//
//  Created by lang on 16/8/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FourButtonBlock)(NSInteger tag);


@interface FourButtonsView : UIView

@property (copy, nonatomic) FourButtonBlock block;

- (void)fourButtonBlockAction:(FourButtonBlock )block;

@end

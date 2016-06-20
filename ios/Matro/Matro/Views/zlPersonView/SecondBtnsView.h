//
//  SecondBtnsView.h
//  Matro
//
//  Created by lang on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DaiFuKuanBlock)(BOOL success);
typedef void(^DaiFaHuoBlock)(BOOL success);
typedef void(^DaiPingJiaBlock)(BOOL success);
typedef void(^TuiHuoBlock)(BOOL success);
typedef void(^QuanBuBlock)(BOOL success);


@interface SecondBtnsView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4CenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2CenterX;


@property (copy, nonatomic) DaiFuKuanBlock daiFuBLock;
@property (copy, nonatomic) DaiFaHuoBlock daiFaHuoBLock;
@property (copy, nonatomic) DaiPingJiaBlock daiPingBLock;
@property (copy, nonatomic) TuiHuoBlock tuiHuoBLock;
@property (copy, nonatomic) QuanBuBlock quanBuBLock;
@property (weak, nonatomic) IBOutlet UIButton *daiFuButton;



+ (SecondBtnsView *)personHeadView;

@end

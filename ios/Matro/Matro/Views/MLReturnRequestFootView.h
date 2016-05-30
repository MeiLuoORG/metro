//
//  MLReturnRequestFootView.h
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLReturnRequestFootView : UIView
+ (MLReturnRequestFootView *)returnFootView;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

@end

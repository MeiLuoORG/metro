//
//  NavTopCommonImage.h
//  1PXianProject
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 JiJianNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "CustomeColorObject.h"

typedef void(^BackBtnBlock)(BOOL succes);
typedef void(^RightBtnBlock)(BOOL success);


@interface NavTopCommonImage : UIImageView


@property (copy, nonatomic) BackBtnBlock backsBlock;
@property (copy, nonatomic) RightBtnBlock rightBlock;

- (void)backButtonAction:(BackBtnBlock )blcok;
- (void)rightButtonBlockAction:(RightBtnBlock )block;
- (void)loadNavImageWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title;
- (void)loadBackButton;
- (void)loadRightButton;


@end

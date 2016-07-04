//
//  CPStepper.h
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/18.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLShopingCartlistModel.h"

@protocol CPStepperDelegate <NSObject>

@optional
- (void)addButtonClicked:(UIButton *)sender;
- (void)subButtonClicked:(UIButton *)sender;

- (void)addButtonClicked:(NSDictionary *)param count:(int)textCount;
- (void)subButtonClicked:(NSDictionary *)param count:(int)textCount;

- (void)addButtonClick:(id)prolist count:(int)textCount;
- (void)subButtonClick:(id)prolist count:(int)textCount;



@end

@interface CPStepper : UITextField

@property (nonatomic) NSUInteger minValue;
@property (nonatomic) NSUInteger maxValue;

@property (nonatomic) NSUInteger value;
@property (nonatomic,strong) NSDictionary *paramDic;

@property (nonatomic,strong)id proList;

-(void)setTextValue:(int)value;

@property (nonatomic, weak) id<CPStepperDelegate> stepperDelegate;

@end

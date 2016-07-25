//
//  CPStepper.h
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/18.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLShopingCartlistModel.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@class CPStepper;
@protocol CPStepperDelegate <NSObject>

@optional
- (void)addButtonClicked:(UIButton *)sender;
- (void)subButtonClicked:(UIButton *)sender;

- (void)addButtonClicked:(NSDictionary *)param count:(int)textCount;
- (void)subButtonClicked:(NSDictionary *)param count:(int)textCount;

- (void)addField:(CPStepper *)field  ButtonClick:(id)prolist  count:(int)textCount;
- (void)subButtonClick:(id)prolist count:(int)textCount;

- (void)showFieldErrorMessage;


@end

@interface CPStepper : UITextField

@property (nonatomic,assign) NSUInteger minValue;
@property (nonatomic,assign) NSUInteger maxValue;

@property (nonatomic,assign) NSUInteger value;
@property (nonatomic,strong) NSDictionary *paramDic;

@property (nonatomic,strong)id proList;

-(void)setTextValue:(int)value;

@property (nonatomic, weak) id<CPStepperDelegate> stepperDelegate;

@end

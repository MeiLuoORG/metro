//
//  ShaiXuanZlView.h
//  Matro
//
//  Created by lang on 16/7/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NNSXDelegate <NSObject>
- (void)blackAction:(NSDictionary*)paramdic;
@end
@interface ShaiXuanZlView : UIView
- (id)init;
- (id)initWithFrame:(CGRect)frame;

@property (assign,nonatomic,readwrite)id <NNSXDelegate>delegate;

//判断之前是否有选有最大最小价格，然后在自定义价格做修改
@property (nonatomic) NSNumber *postMinPrice;
@property (nonatomic) NSNumber *postMaxPrice;
@property (nonatomic, retain) NSString *keywords;
@property (nonatomic,copy)NSString *spflCode;

@property (weak, nonatomic) IBOutlet UIControl *pinPaiButtonControl;
@property (weak, nonatomic) IBOutlet UIControl *jiaGeButtonControl;
@property (weak, nonatomic) IBOutlet UIControl *shangPinFenLeiControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiaGeTopConstraintValue;

@end

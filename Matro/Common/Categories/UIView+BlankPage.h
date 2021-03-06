//
//  UIView+BlankPage.h
//  kongjiazai
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EaseBlankPageView;
typedef NS_ENUM(NSInteger,EaseBlankPageType){
    EaseBlankPageTypeTuihuo,
    EaseBlankPageTypeShouHou,
    EaseBlankPageTypeZhuiZong,
    EaseBlankPageTypeShouCang,
    EaseBlankPageTypeLiuLan,
};
@interface UIView (BlankPage)

@property (nonatomic,strong)EaseBlankPageView *blankPage;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData;

@end

@interface EaseBlankPageView : UIView
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *reloadButton;
@property (assign, nonatomic) EaseBlankPageType curType;

@property (copy, nonatomic) void(^clickButtonBlock)(EaseBlankPageType curType);
- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData;
@end
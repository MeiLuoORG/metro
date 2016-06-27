//
//  MLPersonHeadView.h
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadViewLoginBlock)();
typedef void(^HeadViewRegBlock)();
typedef void(^HeadViewImageBlock)();
@interface MLPersonHeadView : UIView<UIGestureRecognizerDelegate>
+ (MLPersonHeadView *)personHeadView;


@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *renZhengLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIImageView *biaoZhiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;


@property (nonatomic,copy)HeadViewLoginBlock loginBlock;

@property (nonatomic,copy)HeadViewRegBlock  regBlock;

@property (nonatomic,copy)HeadViewImageBlock imageBlock;

@end

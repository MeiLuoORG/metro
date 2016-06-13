//
//  MLPersonHeadView.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadViewLoginBlock)();
typedef void(^HeadViewRegBlock)();
typedef void(^HeadViewImageBlock)();
@interface MLPersonHeadView : UIView
+ (MLPersonHeadView *)personHeadView;


@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;

@property (nonatomic,copy)HeadViewLoginBlock loginBlock;

@property (nonatomic,copy)HeadViewRegBlock  regBlock;

@property (nonatomic,copy)HeadViewImageBlock imageBlock;

@end

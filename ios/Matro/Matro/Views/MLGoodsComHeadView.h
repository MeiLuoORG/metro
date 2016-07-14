//
//  MLGoodsComHeadView.h
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"



typedef void(^GoodsComScore)(NSInteger score);

@interface MLGoodsComHeadView : UIView<UITextViewDelegate>



@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreBgView;

@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;
@property (strong, nonatomic)UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIView *textBgView;

@property (nonatomic,copy)GoodsComScore comScore;

+ (MLGoodsComHeadView *)goodsComHeadView;

@end

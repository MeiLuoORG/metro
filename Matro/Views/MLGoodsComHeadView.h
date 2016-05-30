//
//  MLGoodsComHeadView.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
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
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@property (nonatomic,copy)GoodsComScore comScore;

+ (MLGoodsComHeadView *)goodsComHeadView;

@end

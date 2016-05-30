//
//  MLGoodsComFootView.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGoodsComFootView : UIView
@property (weak, nonatomic) IBOutlet UIButton *sendComBtn;
@property (weak, nonatomic) IBOutlet UIButton *addImgBtn;
+ (MLGoodsComFootView *)goodsComFootView;

@end

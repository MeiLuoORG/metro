//
//  MLWishlistFootView.h
//  Matro
//
//  Created by 黄裕华 on 16/5/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"


typedef void(^WishlistFootSelectAllBlock)(BOOL isSelected);
typedef void(^WishlistFootAddCartBlock)();
typedef void(^WishlistFootDeleteBlock)();


@interface MLWishlistFootView : UIView

+ (MLWishlistFootView *)WishlistFootView;

@property (nonatomic,copy)WishlistFootSelectAllBlock selectAllBlock;
@property (nonatomic,copy)WishlistFootAddCartBlock   addCartBlock;
@property (nonatomic,copy)WishlistFootDeleteBlock    deleteBlock;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBoxBtn;


@end

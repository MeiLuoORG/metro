//
//  MLStoreFootView.h
//  Matro
//
//  Created by Matro on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"

typedef void(^MLStoreFootSelectAllBlock)(BOOL isSelected);
typedef void(^MLStoreFootCancelBlock)();

@interface MLStoreFootView : UIView

+ (MLStoreFootView *)MLStoreFootView;

@property (nonatomic,copy)MLStoreFootSelectAllBlock selectAllBlock;
@property (nonatomic,copy)MLStoreFootCancelBlock cancelBlock;

@end

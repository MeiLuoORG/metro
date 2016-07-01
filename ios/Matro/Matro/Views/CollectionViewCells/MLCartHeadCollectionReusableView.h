//
//  MLCartHeadCollectionReusableView.h
//  Matro
//
//  Created by MR.Huang on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"
#import "MLShopingCartlistModel.h"



typedef void(^CartHeadBlock)(BOOL);

typedef void(^YouHuiBlock)();

#define kCartHeadCollectionReusableView @"cartHeadCollectionReusableView"
@interface MLCartHeadCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;
@property (nonatomic,copy)CartHeadBlock cartHeadBlock;
@property (nonatomic,strong)MLShopingCartModel *shopingCart;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *youhuiBtn;
@property (nonatomic,copy)YouHuiBlock youHuiBlock;

@end

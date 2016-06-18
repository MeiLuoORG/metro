//
//  MLShopCartCollectionViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPStepper.h"
#import "MLShopingCartlistModel.h"
#import "MLCheckBoxButton.h"


typedef void(^ShopCartDelBlock)();
typedef void(^ShopCartCheckBoxBlock)();
#define kShopCartCollectionViewCell   @"shopCartCollectionViewCell"
@interface MLShopCartCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodDesc;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet CPStepper *countField;
@property (weak, nonatomic) IBOutlet UILabel *actDesc;
@property (weak, nonatomic) IBOutlet UILabel *giftDesc;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;
@property (nonatomic,strong)MLProlistModel *prolistModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@property (nonatomic,copy)ShopCartCheckBoxBlock shopCartCheckBoxBlock;
@property (nonatomic,copy)ShopCartDelBlock shopCartDelBlock;




@end

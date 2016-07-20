//
//  MLShopBagTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPStepper.h"
#import "MLCheckBoxButton.h"
#import "OffLlineShopCart.h"
#import "MLShopingCartlistModel.h"
#import "MGSwipeTableCell.h"

typedef void(^ShopCartDelBlock)();
typedef void(^ShopCartCheckBoxBlock)(BOOL);
#define kShopBagTableViewCell   @"shopBagTableViewCell"

@interface MLShopBagTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodDesc;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet CPStepper *countField;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *manjianLabel;

@property (nonatomic,strong)NSDateFormatter *dateFM;


@property (nonatomic,strong)MLProlistModel *prolistModel;
@property (nonatomic,copy)ShopCartCheckBoxBlock shopCartCheckBoxBlock;
@property (nonatomic,copy)ShopCartDelBlock shopCartDelBlock;
@property (nonatomic,strong)OffLlineShopCart *offlineCart;

@end

//
//  MLShopBagHeaderView.h
//  Matro
//
//  Created by 黄裕华 on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"
#import "MLShopingCartlistModel.h"


typedef void(^CartHeadBlock)(BOOL);

typedef void(^YouHuiBlock)();
@interface MLShopBagHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *arrow;
@property (nonatomic,strong)MLCheckBoxButton *checkBox;
@property (nonatomic,copy)CartHeadBlock cartHeadBlock;
@property (nonatomic,strong)MLShopingCartModel *shopingCart;
@property (weak, nonatomic)UIButton *youhuiBtn;
@property (nonatomic,copy)YouHuiBlock youHuiBlock;

@end

//
//  MLCartHeadCollectionReusableView.h
//  Matro
//
//  Created by 黄裕华 on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"
#import "MLShopingCartlistModel.h"



typedef void(^CartHeadBlock)(BOOL);

#define kCartHeadCollectionReusableView @"cartHeadCollectionReusableView"
@interface MLCartHeadCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;
@property (nonatomic,copy)CartHeadBlock cartHeadBlock;
@property (nonatomic,strong)MLShopingCartModel *shopingCart;

@end

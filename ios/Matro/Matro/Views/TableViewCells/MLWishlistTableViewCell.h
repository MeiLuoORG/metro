//
//  MLWishlistTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"
#import "MLWishlistModel.h"

typedef void(^WishlistAddCartBlock)();
typedef void(^WishlistDeleteBlock)();
typedef void(^WishlistCheckBlock)(BOOL isSelected);

#define kMLWishlistTableViewCell @"WishlistTableViewCell"

@interface MLWishlistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *sideView;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (nonatomic,copy)WishlistAddCartBlock wishlistAddCartBlock;
@property (nonatomic,copy)WishlistDeleteBlock  wishlistDeleteBlock;
@property (nonatomic,copy)WishlistCheckBlock wishlistCheckBlock;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)MLWishlistModel *wishlistModel;


@end

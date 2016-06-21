//
//  MLCollectionTableViewCell.h
//  Matro
//
//  Created by Matro on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"
#import "MLWishlistModel.h"
typedef void(^WishlistCheckBlock)(BOOL isSelected);


@interface MLCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectW;
@property (weak, nonatomic) IBOutlet UIImageView *pImage;
@property (weak, nonatomic) IBOutlet UILabel *pName;
@property (weak, nonatomic) IBOutlet UILabel *pguige;
@property (weak, nonatomic) IBOutlet UILabel *pPrice;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBoxbtn;
@property (nonatomic,copy)WishlistCheckBlock wishlistCheckBlock;
@property (nonatomic,strong)MLWishlistModel *wishlistModel;
@end

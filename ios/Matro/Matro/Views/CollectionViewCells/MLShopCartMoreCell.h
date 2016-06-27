//
//  MLShopCartMoreCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MoreActionBlock)();

@interface MLShopCartMoreCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic,copy)MoreActionBlock moreActionBlock;


@end

//
//  MLThirdTableViewCell.h
//  Matro
//
//  Created by Matro on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ImageClickBlock)();

@interface MLThirdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *thirdCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdHeadImage;
@property (copy, nonatomic)ImageClickBlock imageClickBlock;
@end

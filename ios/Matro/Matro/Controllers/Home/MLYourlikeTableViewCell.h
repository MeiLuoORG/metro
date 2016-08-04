//
//  MLYourlikeTableViewCell.h
//  Matro
//
//  Created by Matro on 16/8/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLYourlikeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *LikeCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *likeHeadImage;

@end

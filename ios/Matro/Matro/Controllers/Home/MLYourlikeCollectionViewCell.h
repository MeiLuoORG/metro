//
//  MLYourlikeCollectionViewCell.h
//  Matro
//
//  Created by Matro on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLYourlikeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *likeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *likePriceLab;

@end

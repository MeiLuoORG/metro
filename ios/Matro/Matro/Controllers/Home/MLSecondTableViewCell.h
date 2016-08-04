//
//  MLSecondTableViewCell.h
//  Matro
//
//  Created by Matro on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LeftClickBlock)();
typedef void (^RightClickBlock)();


@interface MLSecondTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *secondCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage1;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage2;
@property (copy, nonatomic)LeftClickBlock leftClickblock;
@property (copy, nonatomic)RightClickBlock rightClickblock;
@property (weak, nonatomic) IBOutlet UIImageView *secondHeadimage;

@end

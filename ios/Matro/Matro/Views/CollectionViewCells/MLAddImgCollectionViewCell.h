//
//  MLAddImgCollectionViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAddImgCollectionViewCell  @"addImgCollectionViewCell"

typedef void(^AddImgCollectionDelBlock)();


@interface MLAddImgCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,copy)AddImgCollectionDelBlock addImgCollectionDelBlock;
@end

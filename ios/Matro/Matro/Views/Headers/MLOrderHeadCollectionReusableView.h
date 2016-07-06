//
//  MLOrderHeadCollectionReusableView.h
//  Matro
//
//  Created by Matro on 16/7/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KMLOrderHeadCollectionReusableView @"MLOrderHeadCollectionReusableView"

@interface MLOrderHeadCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *headTitle;

@end

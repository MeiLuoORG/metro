//
//  MLCartFootCollectionReusableView.h
//  Matro
//
//  Created by MR.Huang on 16/6/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"

#define kCartFootCollectionReusableView @"CartFootCollectionReusableView"

@interface MLCartFootCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;

@end

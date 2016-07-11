//
//  MLShopCartFootView.h
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"

@interface MLShopCartFootView : UIView
+ (MLShopCartFootView *)footView;
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;
@end

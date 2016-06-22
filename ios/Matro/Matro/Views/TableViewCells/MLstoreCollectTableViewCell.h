//
//  MLstoreCollectTableViewCell.h
//  Matro
//
//  Created by Matro on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"
#import "MLCollectstoresModel.h"

typedef void(^storeslistCheckBlock)(BOOL isSelected);

@interface MLstoreCollectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBoxbtn;
@property (weak, nonatomic) IBOutlet UIImageView *sImage;
@property (weak, nonatomic) IBOutlet UILabel *sName;
@property (weak, nonatomic) IBOutlet UIProgressView *sProgress;
@property (weak, nonatomic) IBOutlet UILabel *sPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectW;
@property (nonatomic,strong)MLCollectstoresModel *storeslistModel;
@property (nonatomic,copy)storeslistCheckBlock storeslistCheckBlock;
@end

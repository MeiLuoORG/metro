//
//  MLProductOrderCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/10.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLProductModel.h"

@interface MLProductOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tisLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (nonatomic,strong)MLProductModel *product;
@end

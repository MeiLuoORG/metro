//
//  MLLoginTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DeleteBlcok)();

@interface MLLoginTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *logininfoLabel;

@property (nonatomic,copy)DeleteBlcok deleteBlcok;

@end

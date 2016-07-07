//
//  MLOrderSubFaPiaoTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kOrderSubFaPiaoTableViewCell   @"orderSubFaPiaoTableViewCell"
@interface MLOrderSubFaPiaoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fapiaoType;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;



@property (nonatomic,assign)BOOL shifouKai;

@end

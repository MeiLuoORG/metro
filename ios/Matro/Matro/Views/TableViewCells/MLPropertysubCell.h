//
//  MLPropertysubCell.h
//  Matro
//
//  Created by Matro on 16/5/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SorceBlcok)();
typedef void(^ChargeBlock)();
typedef void(^MoneyBlock)();
#define kMLPropertysubCell  @"PropertysubCell"

@interface MLPropertysubCell : UITableViewCell
@property (nonatomic,copy)SorceBlcok  sorceBlcok;
@property (nonatomic,copy)ChargeBlock  chargeBlock;
@property (nonatomic,copy)MoneyBlock  moneyBlock;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labSorce;
@property (weak, nonatomic) IBOutlet UILabel *labCharge;

@end

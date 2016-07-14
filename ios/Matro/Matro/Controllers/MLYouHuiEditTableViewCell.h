//
//  MLYouHuiEditTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCommitOrderListModel.h"


typedef void(^YouHuiEditBlock)();

#define kYouHuiEditTableViewCell @"youHuiEditTableViewCell"
@interface MLYouHuiEditTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *yuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *editField;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,copy)YouHuiEditBlock changeBlock;

@property (nonatomic,strong)MLYouHuiQuanModel *youHuiQuan;



@end

//
//  MLSelAddressTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCheckBoxButton.h"
#import "MLAddressListModel.h"
#define kSelAddressTableViewCell @"selAddressTableViewCell"
typedef void(^SelAddressEditBlock)();
typedef void(^CheckBoxBlock)(BOOL isSelected);

@interface MLSelAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MLCheckBoxButton *checkBox;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftConstraint;

@property (nonatomic,copy)CheckBoxBlock checkBoxBlock;



@property (nonatomic,strong)MLAddressListModel *addressModel;

@property (nonatomic,copy)SelAddressEditBlock selAddressEditBlock;

@end

//
//  AddressManagerCell.h
//  Matro
//
//  Created by 陈文娟 on 16/5/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLAddressListModel.h"
@class AddressCheckBoxButton;

typedef void(^AddressManagerEdit)();
typedef void(^AddressManagerDel)();
typedef void(^AddressDefault)();
@interface AddressManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet AddressCheckBoxButton *checkBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,copy)AddressManagerEdit addressManagerEdit;
@property (nonatomic,copy)AddressManagerDel addressManagerDel;
@property (nonatomic,copy)AddressDefault addressDefault;

@property (nonatomic,strong)MLAddressListModel *address;



@end


@interface AddressCheckBoxButton : UIButton
@property (nonatomic,assign)BOOL isSelected;



@end

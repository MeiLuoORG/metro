//
//  AddressManagerCell.m
//  Matro
//
//  Created by 陈文娟 on 16/5/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "AddressManagerCell.h"
#import "HFSConstants.h"

@implementation AddressManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    
    self.editBtn.layer.borderColor = RGBA(178, 102, 37, 1).CGColor;
    self.editBtn.layer.borderWidth = 1;
    self.delBtn.layer.borderColor = RGBA(178, 102, 37, 1).CGColor;
    self.delBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setAddress:(MLAddressListModel *)address{
    if (_address != address) {
        _address = address;
        self.usernameLabel.text = address.name;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",_address.area,_address.address];
        self.phoneLabel.text = _address.mobile;
        self.checkBtn.addSelected = [address.default_set isEqualToString:@"2"];
    }
}

- (IBAction)editAction:(id)sender {

    if (self.addressManagerEdit) {
        self.addressManagerEdit();
        
    }
}
- (IBAction)delAction:(id)sender {
    if (self.addressManagerDel) {
        self.addressManagerDel();
    }
}
- (IBAction)checkBoxClick:(id)sender {
    if (self.addressDefault) {
        self.addressDefault();
    }
    
}

@end





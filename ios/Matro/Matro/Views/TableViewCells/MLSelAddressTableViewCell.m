//
//  MLSelAddressTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSelAddressTableViewCell.h"

@implementation MLSelAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editAction:(id)sender {
    if (self.selAddressEditBlock) {
        self.selAddressEditBlock();
    }
}


- (void)setAddressModel:(MLAddressListModel *)addressModel{
    if (_addressModel != addressModel) {
        _addressModel = addressModel;
        self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",_addressModel.area,_addressModel.address];
        self.phoneLabel.text = _addressModel.mobile;
        self.nameLabel.text = _addressModel.name;
        if (![_addressModel.default_set isEqualToString:@"2"]) { //不是默认的时候
            self.defaultLabel.hidden = YES;
            self.nameLeftConstraint.constant = -30;
        }
        
    }

    
}

- (IBAction)checkBoxAction:(id)sender {
    MLCheckBoxButton *btn = (MLCheckBoxButton *)sender;
    btn.addSelected = !btn.addSelected;
    if (self.checkBoxBlock) {
        self.checkBoxBlock(btn.addSelected);
    }
}


@end

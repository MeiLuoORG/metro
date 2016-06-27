//
//  MLPersonAccountCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonAccountCell.h"

@implementation MLPersonAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)accountClick:(id)sender {
    
    if (self.accountBlcok) {
        self.accountBlcok();
    }
}
- (IBAction)addressClick:(id)sender {
    if (self.addressBlcok) {
        self.addressBlcok();
    }
}
- (IBAction)storeClick:(id)sender {
    if (self.storeBlcok) {
        self.storeBlcok();
    }
}

@end

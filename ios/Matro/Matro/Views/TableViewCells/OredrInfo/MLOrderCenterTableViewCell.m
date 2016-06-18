//
//  MLOrderCenterTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderCenterTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MLOrderCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
//@property (weak, nonatomic) IBOutlet UILabel *goodsName;
//@property (weak, nonatomic) IBOutlet UILabel *goodsDesc;
//@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
//@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

- (void)setProductOrder:(MLPersonOrderProduct *)productOrder{
    _productOrder = productOrder;
    self.goodsName.text = _productOrder.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",_productOrder.price];
    self.goodsCount.text = [NSString stringWithFormat:@"*%@",_productOrder.num];
    self.goodsDesc.text = @"暂无数据";
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_productOrder.pic]];
    
}


@end

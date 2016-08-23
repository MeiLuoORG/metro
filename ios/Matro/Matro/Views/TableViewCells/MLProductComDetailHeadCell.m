//
//  MLProductComDetailHeadCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLProductComDetailHeadCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"


@implementation MLProductComDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    MLScoreView *view1 = [[MLScoreView alloc]initWithFrame:CGRectMake(35, 0, 150, 25)];
    self.scoreView = view1;
    [self.scoreBgView addSubview:view1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setProductModel:(MLProductCommentDetailProduct *)productModel{
    if (_productModel != productModel) {
        _productModel = productModel;
        
        if ([_productModel.pic hasSuffix:@"webp"]) {
            [self.goodsImg setZLWebPImageWithURLStr:_productModel.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_productModel.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        self.goodsName.text = _productModel.pname;
        [self.scoreView setStaticScore:_productModel.stars];
    }
}


@end

//
//  MLSaleServiceImageCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSaleServiceImageCell.h"
#import "Masonry.h"
#import "HFSConstants.h"
#import "UIButton+WebCache.h"

@implementation MLSaleServiceImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgBaseView.layer.masksToBounds = YES;
    self.imgBaseView.layer.borderWidth = 1;
    self.imgBaseView.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setImgUrlArray:(NSArray *)imgUrlArray{
    if (_imgUrlArray != imgUrlArray) {
        _imgUrlArray = imgUrlArray;
        
        NSInteger arrCount = _imgUrlArray.count>4?4:_imgUrlArray.count;
        
        for (int i = 0; i < arrCount; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.tag = 100+i;
            [btn  addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.imgBaseView addSubview:btn];
            CGFloat width = 63;
            CGFloat space = 13;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imgBaseView).offset(space + (width+space)*i);
                make.width.height.mas_equalTo(width);
                make.centerY.equalTo(self.imgBaseView);
            }];
            NSString *imgUrl = [_imgUrlArray objectAtIndex:i];
            [btn sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"imageloading"]];
            
        }

    }
}

- (void)imgClick:(UIButton *)sender{
    NSInteger index = sender.tag - 100;
    if (self.serviceImageClickBlock) {
        self.serviceImageClickBlock(index);
    }
}

- (IBAction)moreClick:(id)sender {
    if (self.serviceImageMoreBlock) {
        self.serviceImageMoreBlock();
    }
}

@end

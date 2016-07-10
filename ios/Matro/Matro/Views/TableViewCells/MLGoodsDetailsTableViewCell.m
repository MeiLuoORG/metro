//
//  MLGoodsDetailsTableViewCell.m
//  Matro
//
//  Created by NN on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsDetailsTableViewCell.h"

#import "UIColor+HeinQi.h"
#import "HFSConstants.h"

@implementation MLGoodsDetailsTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTags:(NSArray *)tags{
    if (_tags != tags) {
        _tags = tags;
        IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
        frame.tagsMinPadding = 5;
        frame.tagsMargin = 5;
        frame.tagsLineSpacing = 5;
        frame.tagsArray = _tags;
        
        IMJIETagView *tagView = [[IMJIETagView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.tagsHeight)];
        tagView.clickbool = YES;
        tagView.borderSize = 0.5;
        tagView.clickborderSize = 0.5;
        tagView.tagsFrame = frame;
        tagView.clickBackgroundColor = RGBA(255, 78, 37, 1) ;
        tagView.clickTitleColor = [UIColor whiteColor] ;
        tagView.clickStart = 0;
        tagView.delegate = self;
        tagView.clickString = self.clickStr;
        self.tisH.constant = frame.tagsHeight;
        [self.tagView addSubview:tagView];
    }
}

#pragma mark 选中
-(void)IMJIETagView:(NSArray *)tagArray{
    NSLog(@"%@",tagArray);
    if (self.goodsBiaoQianSelBlock) {
        self.goodsBiaoQianSelBlock(tagArray);
    }
}

@end

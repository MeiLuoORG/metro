//
//  MLWenTiBiaoQianTableViewCell.m
//  Matro
//
//  Created by 黄裕华 on 16/6/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLWenTiBiaoQianTableViewCell.h"
#import "HFSConstants.h"


@implementation MLWenTiBiaoQianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setTags:(NSArray *)tags{
    if (_tags != tags) {
        _tags = tags;
        IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
        frame.tagsMinPadding = 10;
        frame.tagsMargin = 10;
        frame.tagsLineSpacing = 10;
        frame.tagsArray = _tags;
        
        IMJIETagView *tagView = [[IMJIETagView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.tagsHeight)];
        tagView.clickbool = YES;
        tagView.borderSize = 0.5;
        tagView.clickborderSize = 0.5;
        tagView.tagsFrame = frame;
        tagView.clickBackgroundColor =RGBA(255, 78, 37, 1) ;
        tagView.clickTitleColor = [UIColor whiteColor] ;
        tagView.clickStart = 0;
        tagView.delegate = self;
        tagView.clickString = self.clickStr;
        self.tagViewHeight.constant = frame.tagsHeight;
        [self.tagView addSubview:tagView];
    }
}

#pragma mark 选中
-(void)IMJIETagView:(NSArray *)tagArray{
    
    if (self.wenTiBiaoQianSelBlock) {
        self.wenTiBiaoQianSelBlock(tagArray);
    }
}



@end

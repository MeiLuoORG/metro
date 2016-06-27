//
//  MLOrderSubComCell.m
//  Matro
//
//  Created by MR.Huang on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderSubComCell.h"
#import "MLScoreView.h"

@interface MLOrderSubComCell ()
@property (nonatomic,strong)MLScoreView *view1;
@property (nonatomic,strong)MLScoreView *view2;
@property (nonatomic,strong)MLScoreView *view3;
@property (nonatomic,strong)MLScoreView *view4;


@end

@implementation MLOrderSubComCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
    MLScoreView *view1 = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    view1.starViewBlock = ^(NSInteger score){
        if (self.shangpinBlock) {
            self.shangpinBlock(score);
        }
    };
    self.view1 = view1;
    [self.shangpingBgView addSubview:view1];
    
    MLScoreView *view2 = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    view2.starViewBlock = ^(NSInteger score){
        if (self.wuliuBlock) {
            self.wuliuBlock(score);
        }
    };
    self.view2 = view2;
    [self.wuliuBgView addSubview:view2];
    
    MLScoreView *view3 = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    view3.starViewBlock = ^(NSInteger score){
        if (self.fuwuBlock) {
            self.fuwuBlock(score);
        }
    };
    self.view3 = view3;
    [self.fuwuBgView addSubview:view3];
    
    MLScoreView *view4 = [[MLScoreView alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    view4.starViewBlock = ^(NSInteger score){
        if (self.fahuoBlock) {
            self.fahuoBlock(score);
        }
    };
    self.view4 = view4;
    [self.fahuoBgView addSubview:view4];
    
}

- (void)setComment_info:(NSDictionary *)comment_info{
    if (_comment_info != comment_info) {
        _comment_info = comment_info;
        NSString *snuma = _comment_info[@"snuma"];
        NSString *snumb = _comment_info[@"snumb"];
        NSString *snumc = _comment_info[@"snumc"];
        NSString *snumd = _comment_info[@"snumd"];
        [self.view1 setStaticScore:[snumd integerValue]];
        [self.view2 setStaticScore:[snuma integerValue]];
        [self.view3 setStaticScore:[snumb integerValue]];
        [self.view4 setStaticScore:[snumc integerValue]];
    }
}

@end

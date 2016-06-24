//
//  MLScoreView.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^StarViewBlock)(NSInteger score);

@interface MLScoreView : UIView

@property (nonatomic,strong)NSArray *starArray;
@property (nonatomic,copy)StarViewBlock starViewBlock;

- (void)setStaticScore:(NSInteger)score;


@end

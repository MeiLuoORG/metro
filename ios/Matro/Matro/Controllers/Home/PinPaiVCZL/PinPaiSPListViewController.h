//
//  PinPaiSPListViewController.h
//  Matro
//
//  Created by lang on 16/7/4.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface PinPaiSPListViewController : MLBaseViewController
@property (nonatomic) NSString *searchString;//上一个页面传过来的搜索文字


@property (nonatomic,retain) NSDictionary *filterParam;

@property (nonatomic, assign) BOOL isPinPaiChuan;
@end

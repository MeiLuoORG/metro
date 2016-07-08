//
//  MLshopGoodsListViewController.h
//  Matro
//
//  Created by Matro on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLshopGoodsListViewController : MLBaseViewController

@property (nonatomic) NSString *searchString;//上一个页面传过来的搜索文字
@property (nonatomic,retain) NSDictionary *filterParam;

@end

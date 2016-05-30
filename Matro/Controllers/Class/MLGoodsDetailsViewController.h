//
//  MLGoodsDetailsViewController.h
//  Matro
//
//  Created by NN on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLGoodsDetailsViewController : MLBaseViewController
@property(nonatomic,retain) NSDictionary *paramDic;
@property (weak, nonatomic) IBOutlet UIView *yuanchanView;
@property (weak, nonatomic) IBOutlet UIView *shuiView;
@property (weak, nonatomic) IBOutlet UIControl *xuzhiControl;
@property (nonatomic,strong)NSDictionary *shareDic;

@end

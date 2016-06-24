//
//  MLPingjiaListViewController.h
//  Matro
//
//  Created by Matro on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
typedef NS_ENUM(NSInteger,PingjiaType){
    PingjiaType_All,
    PingjiaType_Haoping,
    PingjiaType_Zhongping,
    PingjiaType_Chaping,
    PingjiaType_Shaitu,
};

@interface MLPingjiaListViewController : MLBaseViewController
@property(nonatomic,retain) NSDictionary *paramDic;
- (instancetype)initWithPingjiaType:(PingjiaType)PingjiaType;
@end

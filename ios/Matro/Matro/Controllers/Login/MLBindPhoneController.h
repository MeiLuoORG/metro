//
//  MLBindPhoneController.h
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "NavTopCommonImage.h"
#import "CommonHeader.h"
#import "VipCardModel.h"
#import "SettingMoCardView.h"
@interface MLBindPhoneController : MLBaseViewController
@property (nonatomic,copy)NSString *open_id;
@property (strong, nonatomic) NSString * imgUrl;
@property (strong, nonatomic) NSString * nickname;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSMutableArray * vipCardArray;
@property (strong, nonatomic)UIView *bkView;
@property (strong ,nonatomic) SettingMoCardView * settingMoCardView;
@end

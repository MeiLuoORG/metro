//
//  MLLoginViewController.h
//  Matro
//
//  Created by NN on 16/3/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "SettingMoCardView.h"
#import "CommonHeader.h"

@interface MLLoginViewController : MLBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic) BOOL isLogin;
@property (weak, nonatomic) IBOutlet UIButton *termBtn;

@property (strong ,nonatomic) SettingMoCardView * settingMoCardView;

@end

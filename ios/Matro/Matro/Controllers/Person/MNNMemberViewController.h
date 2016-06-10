//
//  MNNMemberViewController.h
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "HFSServiceClient.h"
#import "VipCardModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface MNNMemberViewController : MLBaseViewController


@property (assign, nonatomic) int moRenIndex;
@property (assign, nonatomic) int currentCardIndex;
@property (strong, nonatomic) NSMutableArray * cardARR;

- (void)loadData;
@end

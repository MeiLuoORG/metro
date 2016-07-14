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
#import <SDWebImage/UIImageView+WebCache.h>
#import "iCarousel.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "MLHttpManager.h"


@interface MNNMemberViewController : MLBaseViewController<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (assign, nonatomic) int moRenIndex;
@property (assign, nonatomic) int currentCardIndex;
@property (strong, nonatomic) NSMutableArray * cardARR;
@property (strong, nonatomic) VipCardModel * currentCardModel;
- (void)loadData;
@end

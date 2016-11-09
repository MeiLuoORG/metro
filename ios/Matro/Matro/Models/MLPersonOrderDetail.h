//
//  MLPersonOrderDetail.h
//  Matro
//
//  Created by MR.Huang on 16/6/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPersonOrderModel.h"
@class MLOrderDetailSellerinfo;


@interface MLPersonOrderDetail : MLPersonOrderModel
@property (nonatomic,copy)NSString *provinceid;
@property (nonatomic,copy)NSString *cityid;
@property (nonatomic,copy)NSString *areaid;
@property (nonatomic,copy)NSString *shipping_name;
@property (nonatomic,copy)NSString *shipping_area;
@property (nonatomic,copy)NSString *shipping_address;
@property (nonatomic,copy)NSString *shipping_mobile;
@property (nonatomic,copy)NSString *shipping_tel;
@property (nonatomic,assign)NSTimeInterval remainder;
@property (nonatomic,copy)NSString *process;
@property (nonatomic,assign)float b2cyhq;
@property (nonatomic,assign)NSInteger partial_return;

@property (nonatomic,strong)MLOrderDetailSellerinfo *sellerinfo;


@end


@interface MLOrderDetailSellerinfo : NSObject
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *catid;
@property (nonatomic,copy)NSString *maincompany;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *tel;
@property (nonatomic,copy)NSString *addr;
@property (nonatomic,copy)NSString *provinceid;
@property (nonatomic,copy)NSString *cityid;
@property (nonatomic,copy)NSString *areaid;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *main_pro;
@property (nonatomic,copy)NSString *logo;
@property (nonatomic,copy)NSString *Template;
@property (nonatomic,copy)NSString *stime;
@property (nonatomic,copy)NSString *etime;
@property (nonatomic,copy)NSString *statu;
@property (nonatomic,copy)NSString *rank;
@property (nonatomic,copy)NSString *view_times;
@property (nonatomic,copy)NSString *uptime;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSString *shop_statu;
@property (nonatomic,copy)NSString *credit;
@property (nonatomic,copy)NSString *shop_collect;
@property (nonatomic,copy)NSString *shop_intro;

@end



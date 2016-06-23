//
//  MLPersonOrderModel.h
//  Matro
//
//  Created by 黄裕华 on 16/6/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 定单状态 '-1'=>'已删除','0'=>'取消的订单','1'=>'等待买家付款','2'=>'等待卖家发货','3'=>'等待买家确认收货','4'=>'订单完成','5'=>'退货中的订单','6'=>'退货成功'
 */
typedef NS_ENUM(NSInteger,OrderStatus){
    OrderStatusYishanchu = -1,
    OrderStatusQuxiao = 0,
    OrderStatusDaifukuan,
    OrderStatusDaifahuo,
    OrderStatusDaiqueren,
    OrderStatusWancheng,
    OrderStatusTuihuozhong,
    OrderStatusTuihuochenggong,
};

@class MLInvinfo;



@interface MLPersonOrderModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *buyer_id;
@property (nonatomic,copy)NSString *seller_id;
@property (nonatomic,copy)NSString *buyer_name;
@property (nonatomic,copy)NSString *buyer_addr;
@property (nonatomic,copy)NSString *buyer_tel;
@property (nonatomic,copy)NSString *buyer_mobile;
@property (nonatomic,copy)NSString *buyer_zip;
@property (nonatomic,assign)float product_price;
@property (nonatomic,copy)NSString *logistics_type;
@property (nonatomic,assign)float logistics_price;
@property (nonatomic,assign)float tax_price;
@property (nonatomic,copy)NSString *change_price;
@property (nonatomic,assign)float discount_price;
@property (nonatomic,assign)OrderStatus status;
@property (nonatomic,copy)NSString *des;
@property (nonatomic,copy)NSString *seller_note;
@property (nonatomic,assign)NSTimeInterval creat_time;
@property (nonatomic,copy)NSString *uptime;
@property (nonatomic,copy)NSString *pay_time;
@property (nonatomic,copy)NSString *buyer_comment;
@property (nonatomic,assign)NSInteger seller_comment;
@property (nonatomic,assign)NSInteger invoice;
@property (nonatomic,copy)NSString *logistics;
@property (nonatomic,copy)NSString *deliver_id;
@property (nonatomic,copy)NSString *deliver_name;
@property (nonatomic,copy)NSString *deliver_code;
@property (nonatomic,copy)NSString *deliver_time;
@property (nonatomic,copy)NSString *deliver_addr_id;
@property (nonatomic,copy)NSString *time_expand;
@property (nonatomic,copy)NSString *way;
@property (nonatomic,copy)NSString *payment_name;
@property (nonatomic,copy)NSString *payment_id;
@property (nonatomic,copy)NSString *from_module;
@property (nonatomic,copy)NSString *warehousecode;
@property (nonatomic,copy)NSString *statuscode;
@property (nonatomic,copy)NSString *is_fxverify;
@property (nonatomic,copy)NSString *channel_id;
@property (nonatomic,copy)NSString *u_id;
@property (nonatomic,copy)NSString *tracking_code;
@property (nonatomic,copy)NSString *o2o_shop;
@property (nonatomic,copy)NSString *test;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *statu_text;
@property (nonatomic,copy)NSString *discount;
@property (nonatomic,copy)NSString *ways;
@property (nonatomic,strong)NSArray *product;
@property (nonatomic,assign)float order_price;
@property (nonatomic,strong)MLInvinfo *invinfo;



@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;



@end

@interface MLPersonOrderProduct : NSObject

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *buyer_id;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *tgid;
@property (nonatomic,copy)NSString *pcatid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,assign)float price;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *setmeal;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *rebate;
@property (nonatomic,copy)NSString *numOrder;
@property (nonatomic,copy)NSString *tax;
@property (nonatomic,copy)NSString *pcommission;
@property (nonatomic,copy)NSString *from_module;
@property (nonatomic,copy)NSString *xsmsp_id;
@property (nonatomic,copy)NSString *jmsp_id;
@property (nonatomic,copy)NSString *test;
@property (nonatomic,copy)NSString *shipfree;
@property (nonatomic,copy)NSString *sku;
@property (nonatomic,copy)NSString *presell;
@property (nonatomic,copy)NSString *way;
@property (nonatomic,copy)NSString *recomment_cash;
@property (nonatomic,copy)NSString *buy_cash;

@end



@interface MLInvinfo : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *rise;
@property (nonatomic,copy)NSString *content;

@end

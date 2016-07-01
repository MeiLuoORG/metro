//
//  MLShopingCartlistModel.h
//  Matro
//
//  Created by MR.Huang on 16/6/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLShopingCartlistModel : NSObject
@property (nonatomic,strong)NSMutableArray *cart;
@property (nonatomic,assign)float sumprice;
@property (nonatomic,assign)float reduce_price;
@property (nonatomic,assign)float sum_prepayment_total;


@end
@interface MLShopingCartModel : NSObject

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *sell_userid;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *setmeal;
@property (nonatomic,copy)NSString *from_module;
@property (nonatomic,strong)NSNumber *num;
@property (nonatomic,copy)NSString *package_id;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *logo;
@property (nonatomic,copy)NSString *tel;
@property (nonatomic,copy)NSString *way;
@property (nonatomic,copy)NSString *supplier;
@property (nonatomic,copy)NSString *shipfree;
@property (nonatomic,copy)NSString *warehousecode;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *start_time;
@property (nonatomic,copy)NSString *end_time;
@property (nonatomic,copy)NSString *is_show;
@property (nonatomic,copy)NSString *sumpackage_price;
@property (nonatomic,copy)NSString *summacth_price;
@property (nonatomic,copy)NSString *sumpromotion_reduce_price;
@property (nonatomic,copy)NSString *sumprice;
@property (nonatomic,copy)NSString *reduce_price;
@property (nonatomic,copy)NSString *sumtax;
@property (nonatomic,strong)NSArray *prolist;
@property (nonatomic,copy)NSString *shipping;
@property (nonatomic,copy)NSString *prepayment_total;
@property (nonatomic,copy)NSString *sublimit;
@property (nonatomic,copy)NSString *discount;
@property (nonatomic,copy)NSString *warehouse_nickname;
@property (nonatomic,strong)NSArray *dpyhq;
@property (nonatomic,assign)BOOL select_All;


@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;




@end


@interface MLProlistModel : NSObject

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *sell_userid;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,assign)NSInteger num;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *setmeal;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *from_module;
@property (nonatomic,assign)NSInteger is_check;
@property (nonatomic,copy)NSString *warehousecode;
@property (nonatomic,copy)NSString *package_id;
@property (nonatomic,copy)NSString *pack_up_time;
@property (nonatomic,copy)NSString *invoice;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *catid;
@property (nonatomic,copy)NSString *pname;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *tax;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *way;
@property (nonatomic,copy)NSString *freight;
@property (nonatomic,copy)NSString *freight_type;
@property (nonatomic,copy)NSString *cubage;
@property (nonatomic,copy)NSString *weight;
@property (nonatomic,copy)NSString *point;
@property (nonatomic,assign)NSInteger shipfree;
@property (nonatomic,assign)NSInteger shipfree_val;
@property (nonatomic,copy)NSString *limit_quantity;
@property (nonatomic,copy)NSString *limit_num;
@property (nonatomic,copy)NSString *market_price;
@property (nonatomic,copy)NSString *start_time;
@property (nonatomic,copy)NSString *end_time;
@property (nonatomic,assign)float pro_price;
@property (nonatomic,copy)NSString *promotion_price;
@property (nonatomic,copy)NSString *is_promotion;
@property (nonatomic,copy)NSString *promition_start_time;
@property (nonatomic,copy)NSString *promition_end_time;
@property (nonatomic,copy)NSString *is_use_discount;
@property (nonatomic,copy)NSString *setmealname;
@property (nonatomic,copy)NSString *stock;
@property (nonatomic,copy)NSString *pro_setmeal_price;
@property (nonatomic,copy)NSString *pro_setmeal_promotion_price;
@property (nonatomic,copy)NSString *commission;
@property (nonatomic,copy)NSString *old_price;
@property (nonatomic,copy)NSString *summatch_price;
@property (nonatomic,copy)NSString *taxprice;
@property (nonatomic,copy)NSString *mjtitle;


@end


//@interface MLYouhuiQuanModel : NSObject
//@property (nonatomic,copy)NSString *JLBH;
//@property (nonatomic,copy)NSString *YHQMC;
//@property (nonatomic,copy)NSString *YHQID;
//@property (nonatomic,copy)NSString *JE;
//@property (nonatomic,copy)NSString *YXQ_B;
//@property (nonatomic,copy)NSString *YXQ_E;
//@property (nonatomic,copy)NSString *CXLX;
//@property (nonatomic,copy)NSString *HYGROUPID;
//@property (nonatomic,copy)NSString *LQBJ;
//@property (nonatomic,copy)NSString *FLAG;
//
//
//@end



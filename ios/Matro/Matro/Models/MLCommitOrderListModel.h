//
//  MLCommitOrderListModel.h
//  Matro
//
//  Created by Matro on 16/7/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MLKuaiDiModel;
@class MLConsigneeInfo;
@interface MLCommitOrderListModel : NSObject

@property(nonatomic,strong)NSMutableArray *cart;
@property(nonatomic,strong)MLConsigneeInfo *consignee;
@property(nonatomic,copy)NSString *identity_card;
@property(nonatomic,copy)NSString *inv_info;
@property (nonatomic,assign)float discount_price;
@property (nonatomic,assign)float change_price;

@property (nonatomic,assign)float sumtax;
@property(nonatomic,assign)float sumprice;

@property (nonatomic,assign)BOOL fapiao;
@property (nonatomic,assign)BOOL geren;
@property (nonatomic,copy)NSString *mingxi;
@property (nonatomic,copy)NSString *fapiao_ID;




@property (nonatomic,assign)float realTax;
@property (nonatomic,assign)float realYunFei;
@property (nonatomic,assign)float realYouHui;





@end

@interface MLOrderCartModel : NSObject

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
@property (nonatomic,assign)float sumprice;
@property (nonatomic,copy)NSString *reduce_price;
@property (nonatomic,assign)float sumtax;
@property (nonatomic,strong)NSArray *prolist;
@property (nonatomic,strong)NSArray *shipping;
@property (nonatomic,copy)NSString *prepayment_total;
@property (nonatomic,copy)NSString *sublimit;
@property (nonatomic,copy)NSString *discount;
@property (nonatomic,copy)NSString *warehouse_nickname;
@property(nonatomic,strong)NSArray *yhqdata;
@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;




@property (nonatomic,assign)float dingdanXiaoji;


@property (nonatomic,strong)MLKuaiDiModel *kuaiDiFangshi;

@property (nonatomic,assign)BOOL openKuaiDi;
@property (nonatomic,assign)BOOL openYouHui;
@property (nonatomic,assign)BOOL canOpenKuaiDi;
@property (nonatomic,assign)BOOL canOpenYouHui;

@property (nonatomic,assign)float youhuiMoney;

@property (nonatomic,strong)UITextField *liuYan;



@end

@interface MLOrderProlistModel : NSObject

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *sell_userid;
@property (nonatomic,assign)float price;
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


@end


@interface MLKuaiDiModel : NSObject
@property (nonatomic,assign)float sumtax;
@property (nonatomic,assign)float s_tax;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *logistics_type;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,assign)float price;
@property (nonatomic,strong)NSNumber *is_show;
@property (nonatomic,assign)float mianfei;
@property (nonatomic,assign)float is_free;

@end




@interface MLYouHuiQuanModel : NSObject
@property (nonatomic,assign)float payable;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *end_date;
@property (nonatomic,copy)NSString *value_m;
@property (nonatomic,assign)float balance;
@property (nonatomic,copy)NSString *diff_deduct;
@property (nonatomic,copy)NSString *date_valid;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *stock_num;
@property (nonatomic,copy)NSString *summary;
@property (nonatomic,copy)NSString *begin_date;
@property (nonatomic,copy)NSString *vip_id;
@property (nonatomic,copy)NSString *validdate;
@property (nonatomic,copy)NSString *name;

@property (nonatomic,assign)float useSum;

@end

@interface MLConsigneeInfo : NSObject
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *delivery_address_id;
@end


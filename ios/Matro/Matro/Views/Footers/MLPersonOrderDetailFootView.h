//
//  MLPersonOrderDetailFootView.h
//  Matro
//
//  Created by MR.Huang on 16/6/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonOrderDetail.h"
typedef NS_ENUM(NSInteger,FooterType){
    FooterTypeDaifahuo,
    FooterTypeDaifukuan,
    FooterTypeDaiQueren,
    FooterTypeDaishouhuo,
    FooterTypeJiaoyiguanbi,
    FooterTypeJiaoyichenggong,
    FooterTypeQitazhuangtai,
    FooterTypeQuxiao,
   
};
typedef NS_ENUM(NSInteger,ButtonActionType){
    ButtonActionTypeShanchu,
    ButtonActionTypeFukuan,
    ButtonActionTypeQuxiao,
    ButtonActionTypeZhuizong,
    ButtonActionTypeQuerenshouhuo,
    ButtonActionTypePingJia,
    ButtonActionTypeTuiHuo,
    ButtonActionTypeTuiKuan
};




typedef void(^OrderDetailButtonActionBlock)(ButtonActionType);
@interface MLPersonOrderDetailFootView : UIView


+ (MLPersonOrderDetailFootView *)detailFooterView;

@property (weak, nonatomic) IBOutlet UILabel *daojishiLb;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *shengyufukuanLb;
@property (weak, nonatomic) IBOutlet UILabel *shenyuLb;
@property (nonatomic,assign)FooterType footerType;
@property (nonatomic,copy)OrderDetailButtonActionBlock  orderDetailButtonActionBlock;

@property (nonatomic,assign)NSInteger partial_return;
@end

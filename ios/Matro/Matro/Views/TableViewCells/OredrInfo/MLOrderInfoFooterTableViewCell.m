//
//  MLOrderInfoFooterTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderInfoFooterTableViewCell.h"
#import "HFSConstants.h"


@implementation MLOrderInfoFooterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.leftBtn.layer.borderWidth = 1.f;
    
    self.rightBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.rightBtn.layer.borderWidth = 1.f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderList:(MLPersonOrderModel *)orderList{
    if (_orderList != orderList) {
        _orderList = orderList;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderList.order_price];
        switch (self.orderList.status) {
            case OrderStatusQuxiao:
            {
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
            }
                break;
            case OrderStatusDaifukuan:
            {
                [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                self.leftBtn.hidden = self.rightBtn.hidden = NO;
            }
                break;
            case OrderStatusDaiqueren:
            {
                [self.leftBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"订单追踪" forState:UIControlStateNormal];
                self.leftBtn.hidden = self.rightBtn.hidden = NO;
            }
                break;
            case OrderStatusWancheng:
            {
                if (self.orderList.buyer_comment == 0) { //未评价 去评价
                    [self.rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                }  else{
                    
                    [self.rightBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                }
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
            }
                break;
            default:
            {
                self.leftBtn.hidden = self.rightBtn.hidden = YES;
            }
                break;
        }

    }
}


- (IBAction)leftAction:(id)sender {
    
    
    switch (self.orderList.status) {
            
        case OrderStatusDaifukuan:
        {
            if (self.cancelAction) {
                self.cancelAction();
            }
        }
            break;
        case OrderStatusDaiqueren:
        {
            if (self.shouHuoAction) {
                self.shouHuoAction();
            }
        }
            break;
//        case OrderStatusWancheng:
//        {
//            if (self.orderList.buyer_comment == 0) { //未评价 去评价
//                if (self.pingJiaAction) {
//                    self.pingJiaAction();
//                }
//
//            }
//            else{
//                if (self.kanPingJiaAction) {
//                    self.kanPingJiaAction();
//                }
//            }
//        }
//            break;
        default:
            break;
    }
    
    
}
- (IBAction)rightAction:(id)sender {

    switch (self.orderList.status) {
       case OrderStatusQuxiao:
        {
            if (self.shanchuAction) {
                self.shanchuAction();
            }
        }
          break;
        case OrderStatusDaifukuan:
        {
            if (self.fuKuanAction) {
                self.fuKuanAction();
            }
        }
            break;
        case OrderStatusDaiqueren:
        {
            if (self.zhuiZongAction) {
                self.zhuiZongAction();
            }
        }
            break;
        case OrderStatusWancheng:
        {
            if (self.orderList.buyer_comment == 0) { //未评价 去评价
                if (self.pingJiaAction) {
                    self.pingJiaAction();
                }
                
            }
            else{
                if (self.kanPingJiaAction) {
                    self.kanPingJiaAction();
                }
            }
        }
            break;
        default:
            break;
    }

}


@end

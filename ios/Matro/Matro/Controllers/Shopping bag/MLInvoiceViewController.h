//
//  MLInvoiceViewController.h
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"



typedef void(^InvoiceBlock)(BOOL,BOOL,NSString*,NSString*);

@protocol InvoiceDelegate <NSObject>
- (void)InvoiceDic:(NSDictionary *)dic;
@end

@interface MLInvoiceViewController : MLBaseViewController

@property (nonatomic) BOOL isNeed;

@property (nonatomic,assign)BOOL isGeren;
@property (nonatomic,copy)NSString *mingxi;



@property (assign,nonatomic,readwrite)id <InvoiceDelegate>delegate;

@property (nonatomic,copy)InvoiceBlock  invoiceBlock;


@end

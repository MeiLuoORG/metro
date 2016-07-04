//
//  OffLlineShopCart+CoreDataProperties.h
//  Matro
//
//  Created by 黄裕华 on 16/7/4.
//  Copyright © 2016年 HeinQi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OffLlineShopCart.h"

NS_ASSUME_NONNULL_BEGIN

@interface OffLlineShopCart (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *pid;
@property (nullable, nonatomic, retain) NSString *setmeal;
@property (nullable, nonatomic, retain) NSString *pic;
@property (nullable, nonatomic, retain) NSString *pname;
@property (nonatomic) float pro_price;
@property (nullable, nonatomic, retain) NSString *mjtitle;
@property (nonatomic) int16_t is_check;
@property (nonatomic) int16_t num;
@property (nullable, nonatomic, retain) NSString *company_id;
@property (nullable, nonatomic, retain) NSString *sid;
@property (nullable, nonatomic, retain) NSString *sku;

@end

NS_ASSUME_NONNULL_END

//
//  OffLlineShopCart+CoreDataProperties.h
//  Matro
//
//  Created by MR.Huang on 16/7/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OffLlineShopCart.h"

NS_ASSUME_NONNULL_BEGIN

@interface OffLlineShopCart (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *company_id;
@property (nonatomic) int16_t is_check;
@property (nullable, nonatomic, retain) NSString *mjtitle;
@property (nonatomic) int16_t num;
@property (nullable, nonatomic, retain) NSString *pic;
@property (nullable, nonatomic, retain) NSString *pid;
@property (nullable, nonatomic, retain) NSString *pname;
@property (nonatomic) float pro_price;
@property (nullable, nonatomic, retain) NSString *setmeal;
@property (nullable, nonatomic, retain) NSString *sid;
@property (nullable, nonatomic, retain) NSString *sku;
@property (nonatomic) int16_t amount;

@end

NS_ASSUME_NONNULL_END

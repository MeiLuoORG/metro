//
//  CompanyInfo+CoreDataProperties.h
//  Matro
//
//  Created by MR.Huang on 16/7/4.
//  Copyright © 2016年 HeinQi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) NSString *shopCart;
@property (nonatomic) int16_t checkAll;
@property (nullable, nonatomic, retain) NSString *cid;



@end

NS_ASSUME_NONNULL_END

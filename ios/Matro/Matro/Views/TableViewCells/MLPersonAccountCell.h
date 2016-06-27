//
//  MLPersonAccountCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AccountBlcok)();
typedef void(^StoreBlock)();
typedef void(^AddressBlock)();

#define kMLPersonAccountCell  @"PersonAccountCell"
@interface MLPersonAccountCell : UITableViewCell

@property (nonatomic,copy)AccountBlcok  accountBlcok;
@property (nonatomic,copy)StoreBlock  storeBlcok;
@property (nonatomic,copy)AddressBlock  addressBlcok;



@end

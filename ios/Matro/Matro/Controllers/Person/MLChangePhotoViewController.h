//
//  MLChangePhotoViewController.h
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"
#import "MLHttpManager.h"
#import "NSDatezlModel.h"


@interface MLChangePhotoViewController : MLBaseViewController


- (void)paiZhaoShangChuan;
- (void)xiangceShangChuan;
+ (NSString *)md65:(NSString *)str;
@end

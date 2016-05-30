//
//  MLCusHelpViewController.h
//  Matro
//
//  Created by 黄裕华 on 16/5/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"


typedef NS_ENUM(NSInteger,HelpType){
    GuidHelp,
    EnsureHelp,
    PayHelp,
    ServiceHelp,
    ProblemHelp,
};
@interface MLCusHelpViewController : MLBaseViewController

- (instancetype)initWithHelpType:(HelpType)helpType;

@property (nonatomic,assign)HelpType helpType;


@end

//
//  MLActiveWebViewController.h
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MLGoodsDetailsViewController.h"
@protocol ActiveWebJSObjectDelegate <JSExport>

- (void)skip:(NSString *)index Ui:(NSString *)sender;

@end

@interface MLActiveWebViewController : MLBaseViewController
@property (nonatomic,copy)NSString *link;

@end

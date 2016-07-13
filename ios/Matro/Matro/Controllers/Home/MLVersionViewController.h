//
//  MLVersionViewController.h
//  Matro
//
//  Created by Matro on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface MLVersionViewController : UIViewController

@property(nonatomic,copy)NSString *downlink;
@property(nonatomic,copy)NSString *versioninfoLabel;
@property(nonatomic,copy)NSString *versionLabel;

@end

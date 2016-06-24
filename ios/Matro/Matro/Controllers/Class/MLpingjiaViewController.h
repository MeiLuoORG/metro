//
//  MLpingjiaViewController.h
//  Matro
//
//  Created by Matro on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define MAIN_SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define MAIN_SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

@interface MLpingjiaViewController : WMPageController
@property(nonatomic,retain) NSDictionary *paramDic;

@end

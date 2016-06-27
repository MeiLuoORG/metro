//
//  MLShareGoodsViewController.h
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ShareGoodsErweimaBlock)();

@interface MLShareGoodsViewController : UIViewController

@property(nonatomic,retain) NSDictionary *paramDic;
@property (nonatomic,strong)UIImage *qzoneImg;


@property (nonatomic,copy)ShareGoodsErweimaBlock erweimaBlock;




@end

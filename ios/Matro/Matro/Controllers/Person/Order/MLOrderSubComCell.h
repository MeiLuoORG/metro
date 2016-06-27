//
//  MLOrderSubComCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOrderComSubCell @"OrderComSubCell"

typedef void(^OrderComSubBlock)()
;
typedef void(^OrderComWuliuBlock)(NSInteger score)
;
typedef void(^OrderComShangpinBlock)(NSInteger score)
;
typedef void(^OrderComFuwuBlock)(NSInteger score)
;
typedef void(^OrderComFahuoBlock)(NSInteger score)
;
@interface MLOrderSubComCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *wuliuBgView;
@property (weak, nonatomic) IBOutlet UIView *shangpingBgView;
@property (weak, nonatomic) IBOutlet UIView *fuwuBgView;

@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (nonatomic,copy)OrderComWuliuBlock wuliuBlock;
@property (nonatomic,copy)OrderComShangpinBlock shangpinBlock;
@property (nonatomic,copy)OrderComFuwuBlock fuwuBlock;
@property (nonatomic,copy)OrderComFahuoBlock fahuoBlock;
@property (weak, nonatomic) IBOutlet UIView *fahuoBgView;

@property (nonatomic,strong)NSDictionary *comment_info;


@end

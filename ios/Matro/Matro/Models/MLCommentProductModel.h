//
//  MLCommentProductModel.h
//  Matro
//
//  Created by 黄裕华 on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MLProductCommentDetailText;
@class MLProductCommentDetailProduct;
@class MLProductCommentDetailByuser;

@interface MLCommentProductModel : NSObject

@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *detail_id;
@property (nonatomic,assign)NSInteger is_commented;
@end



@interface MLProductCommentDetailModel : NSObject

@property (nonatomic,strong)MLProductCommentDetailProduct *product;
@property (nonatomic,strong)MLProductCommentDetailByuser *byuser;
@property (nonatomic,strong)MLProductCommentDetailText *comment_detail;

@end
@interface MLProductCommentDetailProduct : NSObject
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *pname;
@property (nonatomic,assign)NSInteger goodbad;
@end
@interface MLProductCommentDetailByuser : NSObject
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *logo;
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *uptime;


@end

@interface MLProductCommentDetailText : NSObject
@property (nonatomic,copy)NSString *con;
@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,copy)NSString *reply;

@property (nonatomic,assign)CGFloat cellHeight;


@end

@interface MLProductCommentImage : NSObject
@property (nonatomic,copy)NSString *src;
@property (nonatomic,copy)NSString *data_src;
@end


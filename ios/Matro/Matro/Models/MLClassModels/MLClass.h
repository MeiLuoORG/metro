//
//  MLClass.h
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MLClass : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *ENAME;
@property (nonatomic, copy, readonly) NSString *INX;
@property (nonatomic, copy, readonly) NSString *PCODE;
@property (nonatomic, copy, readonly) NSString *PNAME;
@property (nonatomic, copy, readonly) NSString *TYPE;
@property (nonatomic, copy, readonly) NSString *URL;
@property (nonatomic, copy, readonly) NSString *YXBJ;

@property (nonatomic, copy, readonly) NSString *CODE;//code
@property (nonatomic, copy, readonly) NSString *MC;//名称 mc
@property (nonatomic, copy, readonly) NSString *imgurl;//一级对应的图片
@property (nonatomic, copy, readonly) NSString *ishot;
@property (nonatomic, copy, readonly) NSString *istuij;
@property (nonatomic, copy, readonly) NSString *inx;
@end
/*
 
 "PCODE": null,
 "PNAME": null,
 "INX": "1",
 "YXBJ": "1",
 "URL": "",
 "TYPE": "0",
 "ENAME": "",
 "MC": "推荐",
 "CODE": "030302"
*/

/*
 code = "1010201",
 ishot = "0",
 istuij = "0",
 imgurl = "http://bbctest.matrojp.com/uploadfile/category/160622_5769f1ba63aa9.jpg",
 mc = "个人护理",
 inx = "0",
 
*/
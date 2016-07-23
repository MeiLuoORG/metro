//
//  MLClassInfo.h
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MLClassInfo : MTLModel <MTLJSONSerializing>

/*
@property (nonatomic, copy, readonly) NSString *HEIGHT;
@property (nonatomic, copy, readonly) NSString *HOTIMG;
@property (nonatomic, copy, readonly) NSString *CID;
@property (nonatomic, copy, readonly) NSString *MC;
@property (nonatomic, copy, readonly) NSURL *SRC;
@property (nonatomic, copy, readonly) NSString *TITLE;
@property (nonatomic, copy, readonly) NSString *URL;
@property (nonatomic, copy, readonly) NSString *WIDTH;
*/

@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *ishot;
@property (nonatomic, copy, readonly) NSString *istuij;
@property (nonatomic, copy, readonly) NSString *imgurl;
@property (nonatomic, copy, readonly) NSString *mc;
@property (nonatomic, copy, readonly) NSString *inx;
@property (nonatomic, copy, readonly) NSString *catid;

/*
 code = "101020101",
 ishot = "0",
 istuij = "0",
 imgurl = "",
 mc = "口腔护理",
 inx = "0",
 
 */

@end

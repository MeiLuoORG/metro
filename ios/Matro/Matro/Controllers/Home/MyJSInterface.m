//
//  MyJSInterface.m
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "MyJSInterface.h"

@implementation MyJSInterface

- (void) test{
	NSLog(@"test called");
}

- (void) navigationFloor:(NSString*)param;
{
    NSLog(@"navigationFloor called");
    
    // TODO
    NSLog(@"%@",param);
    NSMutableString *str = [param mutableCopy];
    
    NSString *result = @"";
    if([param rangeOfString:@"|"].location !=NSNotFound)//_roaldSearchText
    {
        NSRange range = [str rangeOfString:@"|"];
        result = [str substringToIndex:range.location];
    }
    else
    {
        result = str;
    }
    NSLog(@"%@",result);
    
    if (_delegate) {
        [_delegate navFloorAction:result];
    }


}
- (void) navigationScroll: (NSString*) param
{
    NSLog(@"navigationScroll called");

}
- (void) navigationChannel: (NSString*) param
{
    NSLog(@"navigationChannel called");

}
-(void)navigation:(NSString*)param Product:(NSString*)productId
{
    NSLog(@"product_click called");
    if (_delegate) {
        NSDictionary *parmdic = @{@"JMSP_ID":productId,@"ZCSP":param};

        [_delegate homeAction:parmdic];
    }
}


- (void) testWithParam: (NSString*) param{
	NSLog(@"test with param: %@", param);
}

- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2{
	NSLog(@"test with param: %@ and param2: %@", param, param2);
}

- (void) testWithFuncParam: (EasyJSDataFunction*) param{
	NSLog(@"test with func");
	
	param.removeAfterExecute = YES;
	NSString* ret = [param executeWithParam:@"blabla:\"bla"];
	
	NSLog(@"Return value from callback: %@", ret);
}

- (void) testWithFuncParam2: (EasyJSDataFunction*) param{
	NSLog(@"test with func 2 but not removing callback after invocation");
	
	param.removeAfterExecute = NO;
	[param executeWithParam:@"data 1"];
	[param executeWithParam:@"data 2"];
}

- (NSString*) testWithRet{
	NSString* ret = @"js";
	return ret;
}


//zhoulu
- (void)homeChannerClick:(NSString *)param{
    NSLog(@"nslog点击了");

}



@end

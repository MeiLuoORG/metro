//
//  MLCommentProductModel.m
//  Matro
//
//  Created by MR.Huang on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommentProductModel.h"
#import "HFSConstants.h"


@implementation MLCommentProductModel

@end
@implementation MLProductCommentDetailModel

@end
@implementation MLProductCommentDetailProduct

@end
@implementation MLProductCommentDetailByuser

@end
@implementation MLProductCommentDetailText

+ (NSDictionary *)objectClassInArray{
    return @{@"photos":[MLProductCommentImage class]};
}

- (void)setCon:(NSString *)con{
    _con = con;
    CGSize titleSize = [_con boundingRectWithSize:CGSizeMake(MAIN_SCREEN_WIDTH - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.cellHeight = titleSize.height + 16;
}


@end

@implementation MLProductCommentImage

@end

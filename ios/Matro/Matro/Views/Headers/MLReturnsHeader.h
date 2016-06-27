//
//  MLReturnsHeader.h
//  Matro
//
//  Created by MR.Huang on 16/5/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ReturnsSearchBlock)(NSString *searchText);
@interface MLReturnsHeader : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
+ (MLReturnsHeader *)returnsHeader;
@property (nonatomic,copy)ReturnsSearchBlock searchBlock;

@end

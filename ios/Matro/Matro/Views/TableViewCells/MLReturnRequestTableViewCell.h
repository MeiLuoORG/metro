//
//  MLReturnRequestTableViewCell.h
//  Matro
//
//  Created by MR.Huang on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
#import "CPStepper.h"

#define kMLReturnRequestTableViewCell @"returnRequestTableViewCell"

@interface MLReturnRequestTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet CPStepper *numField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

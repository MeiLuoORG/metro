//
//  MLOrderSubHeadView.h
//  Matro
//
//  Created by 黄裕华 on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^AddressHeadClick)();

@interface MLOrderSubHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *shenfenzhengField;
@property (weak, nonatomic) IBOutlet UILabel *sfLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sfLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fieldLeading;
@property (weak, nonatomic) IBOutlet UIControl *addressControl;

@property (nonatomic,copy)AddressHeadClick addressHeadClick;

+ (MLOrderSubHeadView *)headView;

@end

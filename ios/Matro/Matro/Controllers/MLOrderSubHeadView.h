//
//  MLOrderSubHeadView.h
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Add.h"


typedef void(^AddressHeadClick)();
typedef void(^OrderSubChangeInfo)(NSString *);
typedef void(^IDCardIsOK)(BOOL);

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
@property (nonatomic,copy)OrderSubChangeInfo orderSubChangeInfo;
@property (nonatomic,copy)AddressHeadClick addressHeadClick;

@property (weak, nonatomic) IBOutlet UIView *addressBgView;
@property (nonatomic,copy)IDCardIsOK   idcardisOk;


@property (nonatomic,assign)BOOL isShowSFZ;


@property (nonatomic,assign)BOOL isShowWarning;


- (IBAction)saveClick:(id)sender;

+ (MLOrderSubHeadView *)headView;
- (void)haveIdCardSave;

@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;

@property (weak, nonatomic) IBOutlet UIImageView *nameImage;





@end

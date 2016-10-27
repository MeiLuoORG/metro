//
//  ChongZhiViewController.h
//  Matro
//
//  Created by lang on 16/7/18.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "CommonHeader.h"
#import "HFSServiceClient.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ZhengZePanDuan.h"
#import "MBProgressHUD+Add.h"
#import "MLHttpManager.h"
#import "MLShouJiZhiViewController.h"
#import "MLLoginViewController.h"


@interface ChongZhiViewController : MLBaseViewController<ABPeoplePickerNavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIControl *firstView;
@property (weak, nonatomic) IBOutlet UIControl *secondView;
@property (weak, nonatomic) IBOutlet UIControl *thirdView;
@property (weak, nonatomic) IBOutlet UIControl *fourView;
@property (weak, nonatomic) IBOutlet UIControl *fiveView;
@property (weak, nonatomic) IBOutlet UIControl *sixView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *firstJiaGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondJiaGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdJiaGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourJiaGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveJiaGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixJiaGeLabel;


@property (assign, nonatomic) float  orderPrice;
@property (strong, nonatomic) NSString * orderNum;
@property (strong, nonatomic) NSString * subject;


@end

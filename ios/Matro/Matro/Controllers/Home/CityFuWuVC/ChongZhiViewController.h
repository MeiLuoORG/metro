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
@interface ChongZhiViewController : MLBaseViewController<ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIControl *firstView;
@property (weak, nonatomic) IBOutlet UIControl *secondView;
@property (weak, nonatomic) IBOutlet UIControl *thirdView;
@property (weak, nonatomic) IBOutlet UIControl *fourView;
@property (weak, nonatomic) IBOutlet UIControl *fiveView;
@property (weak, nonatomic) IBOutlet UIControl *sixView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;






@end

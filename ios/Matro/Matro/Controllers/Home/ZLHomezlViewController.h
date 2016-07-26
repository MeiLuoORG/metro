//
//  ZLHomezlViewController.h
//  Matro
//
//  Created by lang on 16/7/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//


#import "ViewPagerController.h"

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "ZLHomeSubViewController.h"

#import "MLLoginViewController.h"
#import "MLSearchViewController.h"
#import "MLGoodsListViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MMMaterialDesignSpinner.h"
#import "MyJSInterface.h"
#import "EasyJSWebView.h"
#import "HFSUtility.h"
#import "MLGoodsDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YMNavigationController.h"
#import "SYQRCodeViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLPushMessageModel.h"
#import "MJExtension.h"
#import "MLActiveWebViewController.h"
#import "MLReturnsDetailViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MBProgressHUD.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PinPaiZLViewController.h"
#import "CommonHeader.h"

#import "ZLLabelCustom.h"
#import "UILabel+HeinQi.h"

//测试 支付成功失败页
#import "MLPayresultViewController.h"
#import "MLPayShiBaiViewController.h"

#import "MNNMemberViewController.h"
#import "MLLoginViewController.h"
#import "MLShopInfoViewController.h"
#import "PinPaiSPListViewController.h"
#import "MLGoodsListViewController.h"
#import "JSBadgeView.h"
#import "MBProgressHUD+Add.h"
#import "MLPayViewController.h"
#import "CityFuWuViewController.h"
#import "Reachability.h"
#import "MLHttpManager.h"
@interface ZLHomezlViewController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate,UIGestureRecognizerDelegate,SearchDelegate,UIWebViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,ZLHomeSubVieDragProtocol,UIAlertViewDelegate>
@property (strong, nonatomic) UIView * firstTopView;
@property(nonatomic,strong)JSContext *contextjs;
@property (assign, nonatomic) float historyOffestY;
@property (strong, nonatomic) UIImageView * dakaImageView;
@property (strong, nonatomic) JSBadgeView * messageBadgeView;
@property (strong, nonatomic) UIButton * newsButton;
@property (nonatomic, strong) Reachability *conn;

@property (strong, nonatomic) UIImageView * wangluoImageView;

@property (assign, nonatomic) BOOL titleLoadFinished;
@end

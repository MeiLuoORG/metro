//
//  APPSettingViewController.h
//  Matro
//
//  Created by 陈文娟 on 16/5/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "HFSServiceClient.h"

@interface APPSettingViewController : MLBaseViewController<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingTable;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) UILabel * cityNameLabel;

@property (nonatomic, assign) CGFloat longitude;  // 经度
@property (nonatomic, assign) CGFloat latitude; // 纬度

@property (strong, nonatomic) NSString * currentCityNameStr;
@property (strong, nonatomic) NSString * locationCity;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)startLocationUser;
@end

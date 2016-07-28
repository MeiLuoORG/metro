//
//  MLVersionViewController.h
//  Matro
//
//  Created by Matro on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
typedef void(^VersionBlock)();

@interface MLVersionViewController : UIViewController

@property(nonatomic,copy)NSString *downlink;
@property(nonatomic,copy)NSString *versioninfoLabel;
@property(nonatomic,copy)NSString *versionLabel;
@property(nonatomic,assign)NSNumber *qzversionlabel;
@property(nonatomic,strong)NSArray *versionInfoArr;
@property (weak, nonatomic) IBOutlet UILabel *VerssionLab;
@property (weak, nonatomic) IBOutlet UILabel *VersionInfoLab;
@property (weak, nonatomic) IBOutlet UIView *CaozuoView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionViewH;
@property (weak, nonatomic) IBOutlet UIButton *qzdownloadBtn;

@property (nonatomic,copy)VersionBlock versionblock;

@end

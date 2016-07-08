//
//  MLVersionViewController.m
//  Matro
//
//  Created by Matro on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVersionViewController.h"
#import "HFSServiceClient.h"

@interface MLVersionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *VerssionLab;
@property (weak, nonatomic) IBOutlet UILabel *VersionInfoLab;
@property (weak, nonatomic) IBOutlet UIView *CaozuoView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIView *versionView;

@end

@implementation MLVersionViewController
@synthesize downlink,versionLabel,versioninfoLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionView.layer.cornerRadius = 4.f;
    self.versionView.layer.masksToBounds = YES;
    self.downloadBtn.layer.cornerRadius = 4.f;
    self.downloadBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 4.f;
    self.cancelBtn.layer.masksToBounds = YES;
    self.VerssionLab.text = [NSString stringWithFormat:@"美罗全球精品购V%@",self.versionLabel];
    self.VersionInfoLab.text = [NSString stringWithFormat:@"1.%@\n\n2.%@\n\n3.%@\n\n4.%@\n\n5.%@",self.versioninfoLabel,self.versioninfoLabel,self.versioninfoLabel,self.versioninfoLabel,self.versioninfoLabel];
}

- (IBAction)actCancel:(id)sender {
    self.versionView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actDownload:(id)sender {
    NSLog(@"去下载downlink===%@",self.downlink);
    self.versionView.hidden = YES;
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/su-zhou-mei-luo-jing-pin/id1112037018?mt=8"];
    [[UIApplication sharedApplication]openURL:url];
    [self dismissViewControllerAnimated:YES completion:nil];
    /*
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",
                     @"1023257602"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
}






@end

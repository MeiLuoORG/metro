//
//  MLVersionViewController.m
//  Matro
//
//  Created by Matro on 16/7/6.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVersionViewController.h"
#import "HFSServiceClient.h"
#import "MLLoginViewController.h"

@interface MLVersionViewController ()
{
    NSString *version;
}
@end

@implementation MLVersionViewController
@synthesize downlink,versionLabel,versioninfoLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getVersion];
    self.versionView.layer.cornerRadius = 4.f;
    self.versionView.layer.masksToBounds = YES;
    self.downloadBtn.layer.cornerRadius = 4.f;
    self.downloadBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 4.f;
    self.cancelBtn.layer.masksToBounds = YES;
    self.qzdownloadBtn.layer.cornerRadius = 4.f;
    self.qzdownloadBtn.layer.masksToBounds = YES;
    self.qzdownloadBtn.hidden = YES;
    self.VerssionLab.text = [NSString stringWithFormat:@"美罗全球精品购V%@",self.versionLabel];
    
    if ([_qzversionlabel isEqual:@1]) {
        self.cancelBtn.hidden = YES;
        self.downloadBtn.hidden = YES;
        self.qzdownloadBtn.hidden = NO;
        
    }else{
    
        self.cancelBtn.hidden = NO;
        self.downloadBtn.hidden = NO;
        self.qzdownloadBtn.hidden = YES;
    }
    
    
    if (_versionInfoArr.count == 0) {
        self.VersionInfoLab.text = @"";
        
        self.versionViewH.constant  = 165;
    }
    
    if (_versionInfoArr.count == 1 ) {
        
        self.VersionInfoLab.text = [NSString stringWithFormat:@"%@",_versionInfoArr[0]];
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        
        CGSize theSize = [self.VersionInfoLab.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        
        self.versionViewH.constant = 165 + theSize.height;
        
    }else if(_versionInfoArr.count == 2){
    
        self.VersionInfoLab.text = [NSString stringWithFormat:@"%@\n%@",_versionInfoArr[0],_versionInfoArr[1]];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        
        CGSize theSize = [self.VersionInfoLab.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        
        self.versionViewH.constant = 165 + theSize.height + 25;
        
    }else if(_versionInfoArr.count == 3){
        
        self.VersionInfoLab.text = [NSString stringWithFormat:@"%@\n%@\n%@",_versionInfoArr[0],_versionInfoArr[1],_versionInfoArr[2]];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        
        CGSize theSize = [self.VersionInfoLab.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        
        self.versionViewH.constant = 165 + theSize.height +50;
        
    }else if(_versionInfoArr.count == 4){
        
        self.VersionInfoLab.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",_versionInfoArr[0],_versionInfoArr[1],_versionInfoArr[2],_versionInfoArr[3]];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        
        CGSize theSize = [self.VersionInfoLab.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        
        self.versionViewH.constant = 165 + theSize.height +75;
        
    }else if(_versionInfoArr.count == 5){
        
        self.VersionInfoLab.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",_versionInfoArr[0],_versionInfoArr[1],_versionInfoArr[2],_versionInfoArr[3],_versionInfoArr[4]];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        
        CGSize theSize = [self.VersionInfoLab.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        
        self.versionViewH.constant = 165 + theSize.height +100;
        
    }else if(_versionInfoArr.count == 6){
        
        self.VersionInfoLab.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",_versionInfoArr[0],_versionInfoArr[1],_versionInfoArr[2],_versionInfoArr[3],_versionInfoArr[4],_versionInfoArr[5]];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        
        CGSize theSize = [self.VersionInfoLab.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        
        self.versionViewH.constant = 165 + theSize.height +125;
        
    }
   
    
}

- (NSString*)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version===%@",version);
    return version;
}

- (IBAction)actCancel:(id)sender {
    self.versionView.hidden = YES;
    if (self.versionblock) {
        self.versionblock ();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actDownload:(id)sender {
    NSLog(@"去下载downlink===%@",self.downlink);
    self.versionView.hidden = YES;
    
    if (self.versionblock) {
        self.versionblock ();
    }
    
   // NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/su-zhou-mei-luo-jing-pin/id1112037018?mt=8"];
    NSURL *url = [NSURL URLWithString:self.downlink];
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

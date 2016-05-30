//
//  MLChangePhotoViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLChangePhotoViewController.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"
#import "GTMNSString+URLArguments.h"

@interface MLChangePhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation MLChangePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)paizhaoClick:(id)sender {
    
    if ([self isCameraAvailable]) {
        [self showImagePickerView:UIImagePickerControllerSourceTypeCamera];
    }else{
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"该设备不支持相机拍照";
        [_hud hide:YES afterDelay:2];
    }
    
}
- (IBAction)bendiClick:(id)sender {
    [self showImagePickerView:UIImagePickerControllerSourceTypePhotoLibrary];
}



- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

-(void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        
        
        NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
        UIImage *avatorimg = [UIImage imageWithData:imageData];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
        
        BOOL result = [UIImagePNGRepresentation(avatorimg)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
        
        if (result) {
            NSData *imgdata = [NSData dataWithContentsOfFile:filePath];
            
            NSString *_encodedImageStr =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imgdata base64EncodedStringWithOptions:0]] ;
            NSDictionary *persondic = @{@"imgFileName":@"avator.jpg",@"imgType":@"ReduceResolution",@"imgContent":_encodedImageStr};
            
            SBJSON *sbjson = [SBJSON new];
            NSString *sbstr = [sbjson stringWithObject:persondic error:nil];
            
            HFSServiceClient *_client = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
            
            _client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
            if (!accessToken) {
                accessToken = @"";
            }
            [_client.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [_client POST:@"image/upload" parameters:sbstr success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                if (responseObject) {
                    NSDictionary *result = (NSDictionary *)responseObject;
                    if(result) {
                        NSString *imgrurl = result[@"imgUrl"];
                        if (imgrurl) {
                            
                            [self uploadImageUrl:imgrurl];
                            
                        }
                    }
                }
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
            
        }
        
        
    }

    
}

- (void)uploadImageUrl:(NSString *)imgUrl{
    
    NSString *mphone = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERPHONE];
    NSString *cardno = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERCARDNO];
    NSString *nikeName = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *dic = @{@"appId":APP_ID,@"nickname":nikeName,@"cardno":cardno,@"mphone":mphone,@"headPicUrl":imgUrl};
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    
    
   HFSServiceClient  *_client = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
    
    _client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",  @"text/plain",nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
    if (!accessToken) {
        accessToken = @"";
    }
    [_client.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];

 
    [_client POST:@"vip/updateUserInfo" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            
//            [_hud show:YES];
//            _hud.mode = MBProgressHUDModeText;
//            _hud.labelText = @"头像修改成功";
//            [_hud hide:YES afterDelay:2];
            
            [[NSUserDefaults standardUserDefaults] setObject:imgUrl forKey:kUSERDEFAULT_USERAVATOR];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGEUSERINFO object:nil];
            
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"msg"];
            [_hud hide:YES afterDelay:2];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}





@end

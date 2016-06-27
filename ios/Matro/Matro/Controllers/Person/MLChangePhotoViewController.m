//
//  MLChangePhotoViewController.m
//  Matro
//
//  Created by MR.Huang on 16/5/12.
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
#import "CommonHeader.h"
#import <CommonCrypto/CommonDigest.h>

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
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)paizhaoClick:(id)sender {
    

}
- (IBAction)bendiClick:(id)sender {
    
}

- (void)xiangceShangChuan{
    [self showImagePickerView:UIImagePickerControllerSourceTypePhotoLibrary];
    
    
}
- (void)paiZhaoShangChuan{
    if ([self isCameraAvailable]) {
        [self showImagePickerView:UIImagePickerControllerSourceTypeCamera];
    }else{
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"该设备不支持相机拍照";
        [_hud hide:YES afterDelay:2];
        [self dismissViewControllerAnimated:NO completion:nil];
    }

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
    NSLog(@"图片调用代理方法");
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
        UIImage *avatorimg = [UIImage imageWithData:imageData];
        
        /*
         
         // 1.创建请求管理者
         AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
         NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
         NSString *accessTokenStr =[accessToken substringToIndex:12];
         NSString *bbc_token = [[NSUserDefaults standardUserDefaults]objectForKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
         NSTimeInterval timestamp = [[NSDatezlModel shareDate] currentTimeDate];
         NSString *signStr =[NSString stringWithFormat:@"%@%f",accessTokenStr,timestamp];
         NSString *sign = [self md5:signStr];
         NSString *newUrl = [NSString stringWithFormat:@"%@&bbc_token=%@&sign=%@&timestamp=%f",url,bbc_token,sign,timestamp];
         
         
         */
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
        NSString *accessTokenStr =[accessToken substringToIndex:12];
        NSString *bbc_token = [[NSUserDefaults standardUserDefaults]objectForKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
        NSTimeInterval timestamp = [[NSDatezlModel sharedInstance] currentTimeDate];
        NSString *signStr =[NSString stringWithFormat:@"%@%@%.f%@",accessTokenStr,@"uploadimg",timestamp,@"index"];
        NSString *sign = [self md65:signStr];
        
        NSString *newUrl = [NSString stringWithFormat:@"%@&timestamp=%.f&bbc_token=%@&sign=%@",UPLOADTOUXIANG_IMAGE_URLString,timestamp,bbc_token,sign];
        
        
        NSData *imgData = UIImageJPEGRepresentation(avatorimg, 0.3);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
        
        BOOL result = [UIImagePNGRepresentation(avatorimg)writeToFile: filePath atomically:YES]; // 保存成功会返回YES
        NSLog(@"是否保存到本地:%d",result);
        //picture: 上传的图片
        //method: header（固定值）
        //NSDictionary *params = @{@"method":@"refund_img",@"order_id":@"123456"};
        NSDictionary *params = @{@"method":@"header"};
        /*
         method: refund_img（固定值）
         
         order_id: 订单号
         */
        [manager POST:newUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imgData name:@"picture" fileName:@"uploadimg.jpg" mimeType:@"image/jpg"];
            
            //formData appendpar
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            
            NSLog(@"长传头像++%@",result);
            NSDictionary * dataDic = result[@"data"];
            if ([result[@"code"] isEqual:@0]) { //上传成功
                
                if (dataDic[@"pic_url"]) {
                    
                    [self uploadImageUrl:dataDic[@"pic_url"]];
                }
                /*
                NSDictionary *data = result[@"data"];
                NSString *url = data[@"pic_url"];
                [self.imgsUrlArray addObject:url];
                already++;
                if (already == uploadCount) { //图片上传完成  请求退货操作
                    [self submitTuihuoAction];
                    
                }
                 */
            }else{//上传失败就跳过 少传一张
                //uploadCount -- ;
            }
            NSLog(@"%@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
        
        
        
        
        /*
        NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
        UIImage *avatorimg = [UIImage imageWithData:imageData];
        */
        
        
        //[self zlShangChuanTupianwith:avatorimg with:info];
        /*
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
        
        BOOL result = [UIImagePNGRepresentation(avatorimg)writeToFile: filePath atomically:YES]; // 保存成功会返回YES
        
        if (result) {
            NSData *imgdata = [NSData dataWithContentsOfFile:filePath];
            
            NSString *_encodedImageStr =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imgdata base64EncodedStringWithOptions:0]];
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
            
            //http://app.matrojp.com/P2MLinkCenter/"
            [_client POST:@"http://app.matrojp.com/P2MLinkCenter/image/upload" parameters:sbstr success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"修改头像信息%@",responseObject);
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
                _hud.labelText = REQUEST_ERROR_ZL;
                [_hud hide:YES afterDelay:2];
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
            
        }
        */
        
    }

    
}

- (void)zlShangChuanTupianwith:(UIImage *)img with:(NSDictionary *)info{
    
    //if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        
        
        NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
        UIImage *avatorimg = [UIImage imageWithData:imageData];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
        
        BOOL result = [UIImagePNGRepresentation(avatorimg)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
        
        if (result) {
            NSData *imgdata = [NSData dataWithContentsOfFile:filePath];
            
            NSString *_encodedImageStr =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imgdata base64EncodedStringWithOptions:0]];
            NSDictionary *persondic = @{@"imgFileName":@"avator.jpg",@"imgType":@"ReduceResolution",@"imgContent":_encodedImageStr};
            
            SBJSON *sbjson = [SBJSON new];
            NSString *sbstr = [sbjson stringWithObject:persondic error:nil];
            
        
        
    //}
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
    //NSDictionary *params = @{@"method":@"refund_img",@"order_id":self.returnsDetail.order_id};
            [manager POST:@"http://app.matrojp.com/P2MLinkCenter/image/upload" parameters:persondic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *result = (NSDictionary *)responseObject;
                NSLog(@"上传图片新：%@",result);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"shangchuan错误%@",error);

            }];
            /*
    [manager POST:@"http://app.matrojp.com/P2MLinkCenter/image/upload" parameters:sbstr constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFileData:imgData name:@"picture" fileName:@"uploadimg.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"上传图片新：%@",result);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"shangchuan错误%@",error);
    }];
    
*/
}

}


- (void)uploadImageUrl:(NSString *)imgUrl{
    
    NSString *mphone = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERPHONE];
    NSString *cardno = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERCARDNO];
    NSString *nikeName = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":mphone,@"img":imgUrl}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"phone":mphone,
                            @"img":imgUrl,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };
    
    NSData *data = [HFSUtility RSADicToData:dic2] ;
    NSString *ret = base64_encode_data(data);
    [self yuanShengRegisterAcrionWithRet2:ret withUrl:imgUrl];
    
    /*
   HFSServiceClient  *_client = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
    
    _client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",  @"text/plain",nil];
    /*
    if (!accessToken) {
        accessToken = @"";
    }
    */
    /*
    [_client.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];

 
    [_client POST:XiuGaiInfo_URLString parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"修改头像imgUrl:%@",result);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    */
}

- (void) yuanShengRegisterAcrionWithRet2:(NSString *)ret2 withUrl:(NSString *)imgUrl{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",XiuGaiInfo_URLString];
        NSURL * URL = [NSURL URLWithString:urlStr];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"post"]; //指定请求方式
        NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data3];
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSLog(@"修改头像 原生错误error:%@",error);
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                                  if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                      
                                                      //            [_hud show:YES];
                                                      //            _hud.mode = MBProgressHUDModeText;
                                                      //            _hud.labelText = @"头像修改成功";
                                                      //            [_hud hide:YES afterDelay:2];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                      [[NSUserDefaults standardUserDefaults] setObject:imgUrl forKey:kUSERDEFAULT_USERAVATOR];
                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGEUSERINFO object:nil];
                                                       });
                                                      
                                                  }else{
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = result[@"msg"];
                                                      [_hud hide:YES afterDelay:2];
                                                       });
                                                  }
                                                  [self dismissViewControllerAnimated:NO completion:^{
                                                      
                                                  }];

                                                  
                                              }
                                          }
                                          else{
                                              //请求有错误
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = REQUEST_ERROR_ZL;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:1];
                                                  [self dismissViewControllerAnimated:NO completion:nil];
                                              });
                                              
                                          }
                                          
                                      }];
        
        [task resume];
    //});
}


- (NSString *)md65:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end

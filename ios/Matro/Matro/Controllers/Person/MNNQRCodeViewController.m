//
//  MNNQRCodeViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNQRCodeViewController.h"

@interface MNNQRCodeViewController ()

@end

@implementation MNNQRCodeViewController{
    
    UILabel * _label1;
    UILabel * _label2;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员卡二维码";
    
    //vipCard
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    _label1.text = @"使用时向服务员出示二维码";
    _label1.font = [UIFont systemFontOfSize:12];
    _label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label1];
    // Do any additional setup after loading the view, typically from a nib.

    
    // set shadow
    self.qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, CGRectGetMaxY(_label1.frame)+20, 200, 200)];
    //self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 2);
    //self.qrcodeView.layer.shadowRadius = 2;
    //self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.qrcodeView.layer.shadowOpacity = 0.5;
    [self.view addSubview:self.qrcodeView];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.qrcodeView.frame)+10, self.view.frame.size.width, 20)];
    //_label2.text = @"每60秒刷新";
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.alpha = 0.5;
    _label2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_label2];
    
    //[self createViews];
    // Do any additional setup after loading the view.
    //[NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(getCardInfo) userInfo:nil repeats:YES];
    [self getCardInfo];
}

- (void)getCardInfo{

    /*
     zhoulu
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    //{"appId": "test0002","phone":"18020260894","sign":$sign,"accessToken":$accessToken}
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"cardNo":self.cardNo}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"cardNo":self.cardNo,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    [self yuanShengRegisterAcrionWithRet2:ret2];
    
    /*
    //@"vip/AuthUserInfo"
    [[HFSServiceClient sharedClient] POST:VIPCardJiFen_URLString parameters:ret2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        NSDictionary *result = (NSDictionary *)responseObject;

     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
*/

}
- (void) yuanShengRegisterAcrionWithRet2:(NSString *)ret2{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",VIPCardJiFen_URLString];
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
                                          NSLog(@"原生错误error:%@",error);
                                          
                                          //请求没有错误
                                          if (!error) {
                                              if (data && data.length > 0) {
                                                  //JSON解析
                                                  // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                  //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                                  NSDictionary * userDataDic = result[@"data"];
                                                  NSLog(@"获取会员卡信息%@",result);
                                                  if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      //vipCard
                                                      // Do any additional setup after loading the view, typically from a nib.
                                                      NSString * erWeiMaString = userDataDic[@"QRCODE"];
                                                      UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:erWeiMaString] withSize:200.0f];
                                                      UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
                                                      
                                                      // set shadow
                                                      self.qrcodeView.image = customQrcode;
                                                      //self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 2);
                                                      //self.qrcodeView.layer.shadowRadius = 2;
                                                      //self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;
                                                      //self.qrcodeView.layer.shadowOpacity = 0.5;

                                                      });
                                                      
                                                  }else{
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = result[@"errMsg"];
                                                      [_hud hide:YES afterDelay:2];
                                                      });
                                                      /*
                                                       UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"账户已过期" message:nil delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                                                       [alert show];
                                                       */
                                                  }
                                                  
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
                                              });
                                              
                                          }
                                          
                                      }];
        
        [task resume];
    //});
}

- (void)createViews {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    label.text = @"使用时向服务员出示二维码";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, CGRectGetMaxY(label.frame)+20, 200, 200)];
//    imageView.image = [UIImage imageNamed:@""];
    imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:imageView];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, self.view.frame.size.width, 20)];
    label1.text = @"每60秒刷新";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.alpha = 0.5;
    label1.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label1];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-30, 100, 20)];
//    view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:view];
}

- (void)loadImageViewErWei{



}

//生成二维码
#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

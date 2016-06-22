//
//  MLGoodsSharePhotoViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsSharePhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"
#import "UMSocial.h"
#import "MBProgressHUD+Add.h"
#import "SBJSON.h"
#import "HFSServiceClient.h"



@interface MLGoodsSharePhotoViewController ()
{
    NSString *share_Url;
}
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *shareImageView;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation MLGoodsSharePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.shareView.layer.masksToBounds = YES;
    self.shareView.layer.cornerRadius = 4.f;
    
    
    self.titleLabel.text = self.goodsDetail[@"pname"];
    
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.goodsDetail[@"pic"]] placeholderImage:PLACEHOLDER_IMAGE];
    
    float pricef = [_goodsDetail[@"price"] floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
    
    
    if ([_paramDic[@"way"] isEqualToString:@"5"]) {
        share_Url = [NSString stringWithFormat:@"http://m.matrojp.com/products/products_hwg.aspx?JMSP_ID=%@",_paramDic[@"jmsp_id"]];
    }
    else{
        share_Url = [NSString stringWithFormat:@"http://m.matrojp.com/products/products_cs.aspx?JMSP_ID=%@",_paramDic[@"jmsp_id"]];
    }
    
    [self erweimaWithUrl:share_Url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pengyouquanClick:(id)sender {
    self.closeBtn.hidden = YES;
    UIImage *img =  [self getImage];
    self.closeBtn.hidden = NO;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = share_Url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.titleLabel.text image:img location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [MBProgressHUD showMessag:@"分享成功" toView:self.view];
        }
    }];
    
}
- (IBAction)weixinClick:(id)sender {
    
    self.closeBtn.hidden = YES;
    UIImage *img =  [self getImage];
    self.closeBtn.hidden = NO;
//    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc]init];
//    resource.url = share_Url;
//    resource.resourceType = UMSocialUrlResourceTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = share_Url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.titleLabel.text image:img location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [MBProgressHUD showMessag:@"分享成功" toView:self.view];
        }
    }];
}


- (void)shareUploadImage:(BOOL)weixin{
    self.closeBtn.hidden = YES;
    UIImage *img =  [self getImage];
    self.closeBtn.hidden = NO;
    
    NSData *imageData = UIImageJPEGRepresentation(img, 1);
    UIImage *avatorimg = [UIImage imageWithData:imageData];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
    
    BOOL result = [UIImagePNGRepresentation(avatorimg)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
    
    
    if (result) {
        NSData *imgdata = [NSData dataWithContentsOfFile:filePath];
        
        NSString *_encodedImageStr =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imgdata base64EncodedStringWithOptions:0]] ;
        //            _encodedImageStr=[_encodedImageStr gtm_stringByEscapingForURLArgument];
        NSDictionary *persondic = @{@"imgFileName":@"avator.jpg",@"imgType":@"ReduceResolution",@"imgContent":_encodedImageStr};
        
        SBJSON *sbjson = [SBJSON new];
        NSString *sbstr = [sbjson stringWithObject:persondic error:nil];
        
        
        [[HFSServiceClient sharedClientwithUrl:SERVICE_BASE_URL] POST:@"image/upload" parameters:sbstr success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            if (responseObject) {
                NSDictionary *result = (NSDictionary *)responseObject;
                if(result) {
                    NSString *imgrurl = result[@"imgUrl"];
                    if (imgrurl) {
                        
                        UMSocialUrlResource *resource = [[UMSocialUrlResource alloc]init];
                        resource.url = imgrurl;
                        resource.resourceType = UMSocialUrlResourceTypeImage;
                        
                        NSArray *shareArray = nil;
                        if (weixin) {
                            shareArray =  @[UMShareToWechatSession];
                        }
                        else{
                            shareArray = @[UMShareToWechatTimeline];
                        }
                        
                        [[UMSocialDataService defaultDataService]  postSNSWithTypes:shareArray content:share_Url image:nil location:nil urlResource:resource presentedController:self completion:^(UMSocialResponseEntity *response){
                            if (response.responseCode == UMSResponseCodeSuccess) {
                                [MBProgressHUD showMessag:@"分享成功" toView:self.view];
                            }
                        }];
                        
                        
                    }
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }

}



- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeWindow:(id)sender {
       [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)getImage {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(228, 322), NO, 1.0);  //NO，YES 控制是否透明
    [self.shareImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    
    return image;
}


-(void)erweimaWithUrl:(NSString *)url
{
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
    NSData *data=[url dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    _erweimaImage.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
    
    
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    _erweimaImage.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
    
    _erweimaImage.layer.shadowRadius=1;//设置阴影的半径
    
    _erweimaImage.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    _erweimaImage.layer.shadowOpacity=0.3;
    
    
    
}



//改变二维码大小

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}



@end

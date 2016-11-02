//
//  MLQQGshenfenViewController.m
//  Matro
//
//  Created by lang on 16/10/31.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLQQGshenfenViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMNSString+URLArguments.h"
#import "KZPhotoManager.h"
#import "ZhengZePanDuan.h"
#import "MLLoginViewController.h"
#import "MBProgressHUD+Add.h"

@interface MLQQGshenfenViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    UITextField * _xingMingLabel;
    UITextField * _shenFenCardId;
    UIButton * _shangChuanButton1;
    UIButton * _shangChuanButton2;

    BOOL _isUploadIMG_OK;//判断是否上传成功
    BOOL isBtn;//判断是点的哪一个按钮
    NSString * _uploadIMG_URLString1;//正面
    NSString * _uploadIMG_URLString2;//反面
}
@end

@implementation MLQQGshenfenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"身份实名认证";

    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 22)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [rightBtn addTarget:self action:@selector(buttonAction1) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];

    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
    [self createView];

}

-(void)buttonAction1{
    NSLog(@"_uploadIMG_URLString1===%@-----_uploadIMG_URLString2===%@",_uploadIMG_URLString1,_uploadIMG_URLString2);
    NSDictionary *params = @{@"zcard_pic":_uploadIMG_URLString1,@"fcard_pic":_uploadIMG_URLString2};
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_member&action=add_idcardpic&order_id=%@",ZHOULU_ML_BASE_URLString,self.order_id];
    NSLog(@"url====%@",url);
    [MLHttpManager post:url params:params m:@"member" s:@"admin_member" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        if ([responseObject[@"code"]isEqual:@0]) {
            [MBProgressHUD show:@"保存成功" view:self.view];
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
        
    } failure:^(NSError *error) {
        NSString *msg = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:msg view:self.view];
    }];
    
    

}
- (void)viewWillAppear:(BOOL)animated{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    [self loadPersonData];
}


//一进来就开始请求订单人的信息
-(void)loadPersonData{
    //http://bbctest.matrojp.com/api.php?m=product&s=admin_buyorder&action=order_idcardno&order_id=201610311432524240
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=order_idcardno&order_id=%@",ZHOULU_ML_BASE_URLString,self.order_id];
    [MLHttpManager get:url params:nil m:@"product" s:@"admin_buyorder" success:^(id responseObject) {
        NSLog(@"请求成功responseObject===%@",responseObject);
        if ([responseObject[@"code"]isEqual:@0]) {
            NSDictionary *dic = responseObject[@"data"][@"idcardata"];
            NSString *buyer_name = dic[@"buyer_name"]?:@"";
            NSString *identity_card = dic[@"identity_card"]?:@"";
            NSString *zidcard_url = dic[@"zidcard_url"]?:@"";
            NSString *fidcard_url = dic[@"fidcard_url"]?:@"";
            if (buyer_name.length > 0) {
                _xingMingLabel.text = buyer_name;
                
            }
            if (identity_card.length > 0) {
                _shenFenCardId.text = identity_card;
            }
            /*
            if (zidcard_url.length > 0) {
                if ([zidcard_url hasSuffix:@"webp"]) {
                    [_shangChuanButton1 setZLWebPButton_ImageWithURLStr:zidcard_url withPlaceHolderImage:[UIImage imageNamed:@"jiahao"]];
                } else {
                    [_shangChuanButton1 sd_setImageWithURL:[NSURL URLWithString:zidcard_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiahao"]];
                }
            }
            if (fidcard_url.length > 0) {
                if ([fidcard_url hasSuffix:@"webp"]) {
                    [_shangChuanButton2 setZLWebPButton_ImageWithURLStr:fidcard_url withPlaceHolderImage:[UIImage imageNamed:@"jiahao"]];
                } else {
                    [_shangChuanButton2 sd_setImageWithURL:[NSURL URLWithString:fidcard_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiahao"]];
                }
            }
             */
          
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        NSString *msg = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:msg view:self.view];
    }];
    
}

- (void)backBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)createView{
    //真实姓名
    UILabel * xingMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 30, 75, 22)];
    xingMingLabel.text = @"真实姓名";
    xingMingLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:xingMingLabel];

    UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    _xingMingLabel = [[UITextField alloc]initWithFrame:CGRectMake(110, 20, SIZE_WIDTH-110-19, 41)];
    _xingMingLabel.layer.borderColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor].CGColor;
    _xingMingLabel.layer.borderWidth = 1.0f;
    _xingMingLabel.layer.masksToBounds = YES;
    _xingMingLabel.layer.cornerRadius = 4.0f;
    _xingMingLabel.leftView = kongView;
    _xingMingLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _xingMingLabel.leftViewMode = UITextFieldViewModeAlways;
    _xingMingLabel.enabled = NO;

    [self.view addSubview:_xingMingLabel];


    //证件号码
    UILabel * shenLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 80, 75, 22)];
    shenLabel.text = @"证件号码";
    shenLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:shenLabel];
    UIView * kongView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    _shenFenCardId = [[UITextField alloc]initWithFrame:CGRectMake(110, 70, SIZE_WIDTH-110-19, 41)];
    _shenFenCardId.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _shenFenCardId.layer.borderColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor].CGColor;
    _shenFenCardId.layer.borderWidth = 1.0f;
    _shenFenCardId.layer.masksToBounds = YES;
    _shenFenCardId.layer.cornerRadius = 4.0f;
    _shenFenCardId.leftView = kongView2;
    _shenFenCardId.leftViewMode = UITextFieldViewModeAlways;
    _shenFenCardId.enabled = NO;
    
    [self.view addSubview:_shenFenCardId];
    //分割线
    UIView * spView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shenFenCardId.frame)+30, SIZE_WIDTH, 1)];
    spView3.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView3];

    //正面照
    UILabel * zhenglabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView3.frame)+30, 200, 22)];
    zhenglabel.text = @"上传身份证正面照";
    [self.view addSubview:zhenglabel];

    _shangChuanButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shangChuanButton1 setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton1 setFrame:CGRectMake(22, CGRectGetMaxY(zhenglabel.frame)+20, 80, 80)];
    [_shangChuanButton1 addTarget:self action:@selector(shangChuanTuPian1) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_shangChuanButton1];

    //反面照
    UILabel * fanlabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(_shangChuanButton1.frame)+30, 200, 22)];
    fanlabel.text = @"上传身份证反面照";
    [self.view addSubview:fanlabel];

    _shangChuanButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shangChuanButton2 setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton2 setFrame:CGRectMake(22, CGRectGetMaxY(fanlabel.frame)+20, 80, 80)];
    [_shangChuanButton2 addTarget:self action:@selector(shangChuanTuPian2) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_shangChuanButton2];

    
}

//点击了第一个按钮
- (void)shangChuanTuPian1{
    isBtn = YES;
    [KZPhotoManager getImage:^(UIImage *image) {
        [self uploadImgWith:image];
    } showIn:self AndActionTitle:@"选择照片"];
    
    
}

//点击了第二个按钮
- (void)shangChuanTuPian2{
    isBtn = NO;
    [KZPhotoManager getImage:^(UIImage *image) {
        [self uploadImgWith:image];
    } showIn:self AndActionTitle:@"选择照片"];
    
    
}

- (void)uploadImgWith:(UIImage *)img{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * accessTokenString = [accessToken URLEncodedString];
    NSString *accessTokenStr =[accessTokenString substringToIndex:12];
    NSString *bbc_token = [[NSUserDefaults standardUserDefaults]objectForKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
    NSTimeInterval timestamp = [[NSDatezlModel sharedInstance] currentTimeDate];
    NSString *signStr =[NSString stringWithFormat:@"%@%@%.f%@",accessTokenStr,@"uploadimg",timestamp,@"index"];
    NSString *sign = [self md65:signStr];
    
    NSString *newUrl = [NSString stringWithFormat:@"%@&timestamp=%.f&bbc_token=%@&sign=%@",UPLOADTOUXIANG_IMAGE_URLString,timestamp,bbc_token,sign];
    
    NSLog(@"newUrl===%@",newUrl);
    NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
    
    BOOL result = [UIImagePNGRepresentation(img)writeToFile: filePath atomically:YES]; // 保存成功会返回YES
    NSLog(@"是否保存到本地:%d",result);
    NSDictionary *params = @{@"method":@"identity_pic"};
    
    
    [MLHttpManager post:UPLOADTOUXIANG_IMAGE_URLString params:params m:@"uploadimg" s:@"index" sconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgData name:@"picture" fileName:@"uploadimg.jpg" mimeType:@"image/jpg"];
    } success:^(id responseObject) {
        NSLog(@"上传身份证++%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary * dataDic = result[@"data"];
        if ([result[@"code"] isEqual:@0]) { //上传成功
            
            if (dataDic[@"pic_url"]) {
                
                _isUploadIMG_OK = YES;
                if (isBtn == YES) {
                    _uploadIMG_URLString1 = dataDic[@"pic_url"];
                    if ([_uploadIMG_URLString1 hasSuffix:@"webp"]) {
                        [_shangChuanButton1 setZLWebPButton_ImageWithURLStr:_uploadIMG_URLString1 withPlaceHolderImage:[UIImage imageNamed:@"jiahao"]];
                    } else {
                        [_shangChuanButton1 sd_setImageWithURL:[NSURL URLWithString:_uploadIMG_URLString1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiahao"]];
                    }
                }else{
                    _uploadIMG_URLString2 = dataDic[@"pic_url"];
                    if ([_uploadIMG_URLString2 hasSuffix:@"webp"]) {
                        [_shangChuanButton2 setZLWebPButton_ImageWithURLStr:_uploadIMG_URLString2 withPlaceHolderImage:[UIImage imageNamed:@"jiahao"]];
                    } else {
                        [_shangChuanButton2 sd_setImageWithURL:[NSURL URLWithString:_uploadIMG_URLString2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiahao"]];
                    }
                }
                
                //[self uploadImageUrl:dataDic[@"pic_url"]];
            }
            else{
                _isUploadIMG_OK = NO;
            }
            
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"上传身份证错误信息：%@",error);
        _isUploadIMG_OK = NO;
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        NSLog(@"上传身份证错误信息：%@",error);
    }];
      
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击了第几个按钮result = %d", (int)buttonIndex);
    if(buttonIndex == 0){
        
        [self xiangceShangChuan];

    }
    else if (buttonIndex == 1){

        [self paiZhaoShangChuan];
    }


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
        /*
         NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
         UIImage *avatorimg = [UIImage imageWithData:imageData];
         */

    }

    
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

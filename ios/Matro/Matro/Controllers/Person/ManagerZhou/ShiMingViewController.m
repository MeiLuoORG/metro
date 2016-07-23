//
//  ShiMingViewController.m
//  Matro
//
//  Created by lang on 16/6/24.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "ShiMingViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMNSString+URLArguments.h"
#import "KZPhotoManager.h"
#import "ZhengZePanDuan.h"
@interface ShiMingViewController ()

@end

@implementation ShiMingViewController{

    UILabel * _usePhoneLabel;
    UITextField * _xingMingLabel;
    UITextField * _shenFenCardId;
    UIButton * _shangChuanButton;

    BOOL _isUploadIMG_OK;
    NSString * _uploadIMG_URLString;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"实名认证";
    
    NavTopCommonImage * navTop = [[NavTopCommonImage alloc]initWithTitle:@"实名认证"];
    [navTop loadLeftBackButtonwith:0];
    
    [navTop backButtonAction:^(BOOL succes) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //[self.view addSubview:navTop];

    if (self.isRenZheng == YES) {

        [self createView1];
    }
    else{
        
        [self createView2];
        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(0, 0, 40, 22)];
        [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [rightBtn addTarget:self action:@selector(buttonAction1) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = item;
        
        
    }
    
    if (self.isRenZheng == YES) {
    }
    else{
        
        if (![self.userName isEqual:[NSNull null]]) {
            _xingMingLabel.text = self.userName;
        }
        if (![self.userShenFenCardID isEqual:[NSNull null]]) {
            _shenFenCardId.text = self.userShenFenCardID;

        }
        NSLog(@"传入的身份证图片链接为：%@",self.shenFenImageURLStr);
        if (![self.shenFenImageURLStr isEqual:[NSNull null]] && ![self.shenFenImageURLStr isEqualToString:@""] && ![self.shenFenImageURLStr isKindOfClass:[NSNull class]]) {
            [_shangChuanButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.shenFenImageURLStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiahao"]];
            _isUploadIMG_OK = YES;
            _uploadIMG_URLString = self.shenFenImageURLStr;
        }
        
        
    }

}


- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewWillAppear:(BOOL)animated{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    if (self.isRenZheng == YES) {
        
        _xingMingLabel.text = self.userName;
       
        
        if (self.userShenFenCardID.length == 18) {
            NSString * str = [self.userShenFenCardID stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
            _shenFenCardId.text = str;
            
        }else{
        
             _shenFenCardId.text = self.userShenFenCardID;
        }
        
        //[_shangChuanButton sd_setImageWithURL:[NSURL URLWithString:self.shenFenImageURLStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        [_shangChuanButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.shenFenImageURLStr] forState:UIControlStateNormal];
    }


}

- (void)buttonAction1{
    [_xingMingLabel resignFirstResponder];
    [_shenFenCardId resignFirstResponder];
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    if([_xingMingLabel.text isEqualToString:@""] || ![ZhengZePanDuan checkZhongWen:_xingMingLabel.text]){
    
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"真是姓名填写错误，请确认";
        [_hud hide:YES afterDelay:1];
        return;
    }
    
    if (_shenFenCardId.text.length != 18) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"身份证号码填写错误，请确认";
        [_hud hide:YES afterDelay:1];
        return;
    }
    if (_isUploadIMG_OK == NO ) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请上传身份证正面照";
        [_hud hide:YES afterDelay:1];
        return;
    }
    
    //上传信息
    [self tianjiaRenZhengInfo];
}
//添加认证信息接口
- (void)tianjiaRenZhengInfo{
    __weak typeof(self) weakself = self;
    NSDictionary * ret = @{@"pay_mobile":[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERPHONE],
                           @"real_name":_xingMingLabel.text?:@"",
                           @"identity_card":_shenFenCardId.text?:@"",
                           @"identity_pic":_uploadIMG_URLString?:@""
                           };
    NSLog(@"用户名：%@,真是姓名：%@,身份证号：%@,图片路径：%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERPHONE],_xingMingLabel.text,_shenFenCardId.text,_uploadIMG_URLString);
    [MLHttpManager post:SHANGCHUAN_RENZHENG_URLString params:ret m:@"member" s:@"admin_member" success:^(id responseObject) {
        NSDictionary * result = (NSDictionary *)responseObject;
        NSLog(@"添加认证信息接口：%@",result);
        NSDictionary * dataDic = result[@"data"];
        BOOL is_Add_suc = dataDic[@"identity_add"];
        if (is_Add_suc) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"上传失败";
            [_hud hide:YES afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
    }];
}


- (void)createView1{
    //1
    UILabel * zhanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, 65, 22)];
    zhanghuLabel.text = @"账户";
    zhanghuLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:zhanghuLabel];
    
    UILabel * zhangHuValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 22)];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    zhangHuValueLabel.text = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    zhangHuValueLabel.font = [UIFont systemFontOfSize:15.0f];
    zhangHuValueLabel.textAlignment = NSTextAlignmentLeft;
    zhangHuValueLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    [self.view addSubview:zhangHuValueLabel];
    UIView * spView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SIZE_WIDTH, 1)];
    spView.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView];
    
    
    //2
    UILabel * xingMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView.frame)+10, 80, 22)];
    xingMingLabel.text = @"真实姓名";
    xingMingLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:xingMingLabel];
    _xingMingLabel = [[UITextField alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(spView.frame)+1, SIZE_WIDTH-90-19, 41)];
    _xingMingLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _xingMingLabel.enabled = NO;
    
    [self.view addSubview:_xingMingLabel];
    UIView * spView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 83, SIZE_WIDTH, 1)];
    spView2.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView2];
    
    //3.
    UILabel * shenLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView2.frame)+10, 80, 22)];
    shenLabel.text = @"身份证号";
    shenLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:shenLabel];
    _shenFenCardId = [[UITextField alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(spView2.frame)+1, SIZE_WIDTH-90-19, 41)];
    _shenFenCardId.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _shenFenCardId.enabled = NO;
    
    [self.view addSubview:_shenFenCardId];
    
    //4
    UIView * spView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 123, SIZE_WIDTH, 1)];
    spView3.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView3];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView3.frame)+10, 200, 22)];
    label.text = @"上传身份证正面照";
    [self.view addSubview:label];
    
    _shangChuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_shangChuanButton setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton setFrame:CGRectMake(22, CGRectGetMaxY(label.frame)+20, 80, 80)];
    _shangChuanButton.enabled = NO;
    
    [self.view addSubview:_shangChuanButton];

    

}

- (void)createView2{
    //1
    UILabel * zhanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 30, 75, 22)];
    zhanghuLabel.text = @"账户";
    zhanghuLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:zhanghuLabel];
   /*
    [zhanghuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    */
    
    UILabel * zhangHuValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 30, 200, 22)];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    zhangHuValueLabel.text = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    zhangHuValueLabel.font = [UIFont systemFontOfSize:15.0f];
    zhangHuValueLabel.textAlignment = NSTextAlignmentLeft;
    zhangHuValueLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    [self.view addSubview:zhangHuValueLabel];
    
    
    //2
    UILabel * xingMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 80, 75, 22)];
    xingMingLabel.text = @"真实姓名";
    xingMingLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:xingMingLabel];

    UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    _xingMingLabel = [[UITextField alloc]initWithFrame:CGRectMake(110, 70, SIZE_WIDTH-110-19, 41)];
    _xingMingLabel.layer.borderColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor].CGColor;
    _xingMingLabel.layer.borderWidth = 1.0f;
    _xingMingLabel.layer.masksToBounds = YES;
    _xingMingLabel.layer.cornerRadius = 4.0f;
    _xingMingLabel.leftView = kongView;
    _xingMingLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _xingMingLabel.leftViewMode = UITextFieldViewModeAlways;
    
    
    [self.view addSubview:_xingMingLabel];

    
    //3.
    UILabel * shenLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 130, 75, 22)];
    shenLabel.text = @"身份证号";
    shenLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:shenLabel];
     UIView * kongView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    _shenFenCardId = [[UITextField alloc]initWithFrame:CGRectMake(110, 120, SIZE_WIDTH-110-19, 41)];
    _shenFenCardId.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
    _shenFenCardId.layer.borderColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor].CGColor;
    _shenFenCardId.layer.borderWidth = 1.0f;
    _shenFenCardId.layer.masksToBounds = YES;
    _shenFenCardId.layer.cornerRadius = 4.0f;
    _shenFenCardId.leftView = kongView2;
    _shenFenCardId.leftViewMode = UITextFieldViewModeAlways;
    //_shenFenCardId.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_shenFenCardId];
    //4
    UIView * spView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shenFenCardId.frame)+30, SIZE_WIDTH, 1)];
    spView3.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView3];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView3.frame)+30, 200, 22)];
    label.text = @"上传身份证正面照";
    [self.view addSubview:label];
    
    _shangChuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shangChuanButton setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton setFrame:CGRectMake(22, CGRectGetMaxY(label.frame)+20, 80, 80)];
    [_shangChuanButton addTarget:self action:@selector(shangChuanTuPian) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_shangChuanButton];
    
    //UITextField * zhanghuValueField  = [UITextField alloc]initWithFrame:CGRectMake(112, 20, 200, <#CGFloat height#>);

}


- (void)shangChuanTuPian{
//    
//    [_xingMingLabel resignFirstResponder];
//    [_shenFenCardId resignFirstResponder];
//    //NSLog(@"点击了上传按钮");
//    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册上传" otherButtonTitles:@"拍照上传", nil];
//    //sheet.destructiveButtonIndex = 1;
//    [sheet showInView:self.view];
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
    
    
    NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
    
    BOOL result = [UIImagePNGRepresentation(img)writeToFile: filePath atomically:YES]; // 保存成功会返回YES
    NSLog(@"是否保存到本地:%d",result);
    //picture: 上传的图片
    //method: header（固定值）
    //NSDictionary *params = @{@"method":@"refund_img",@"order_id":@"123456"};
    NSDictionary *params = @{@"method":@"card_type"};
    
    
    [MLHttpManager post:UPLOADTOUXIANG_IMAGE_URLString params:params m:@"uploadimg" s:@"index" sconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgData name:@"picture" fileName:@"uploadimg.jpg" mimeType:@"image/jpg"];
    } success:^(id responseObject) {
         NSLog(@"上传身份证++%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        
        NSLog(@"上传身份证++%@",result);
        NSDictionary * dataDic = result[@"data"];
        if ([result[@"code"] isEqual:@0]) { //上传成功
            
            if (dataDic[@"pic_url"]) {
                
                _isUploadIMG_OK = YES;
                _uploadIMG_URLString = dataDic[@"pic_url"];
                [_shangChuanButton sd_setImageWithURL:[NSURL URLWithString:_uploadIMG_URLString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiahao"]];
                //[self uploadImageUrl:dataDic[@"pic_url"]];
            }
            else{
                _isUploadIMG_OK = NO;
            }
            
        }else{
            
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
    
    
    /*
     method: refund_img（固定值）
     
     order_id: 订单号
     */
    /*
    [manager POST:newUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        //formData appendpar
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
    }];
*/


}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击了第几个按钮result = %d", (int)buttonIndex);
    if(buttonIndex == 0){
        /*
        MLChangePhotoViewController *vc = [[MLChangePhotoViewController alloc]init];
        //vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        vc.view.backgroundColor = [UIColor clearColor];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        [self presentViewController:vc  animated:NO completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             [vc xiangceShangChuan];
             
         }];
        */
        [self xiangceShangChuan];
        
    }
    else if (buttonIndex == 1){
        /*
        MLChangePhotoViewController *vc = [[MLChangePhotoViewController alloc]init];
        //vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        vc.view.backgroundColor = [UIColor clearColor];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        [self presentViewController:vc  animated:NO completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             [vc paiZhaoShangChuan];
         }];
        */
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


- (void)uploadImageUrl:(NSString *)imgUrl{
    
    NSString *mphone = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERPHONE];
    //NSString *cardno = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERCARDNO];
    //NSString *nikeName = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERNAME];
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
                                      NSLog(@"实名认证 原生错误error:%@",error);
                                      
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
                                                      //[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGEUSERINFO object:nil];
                                                      
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

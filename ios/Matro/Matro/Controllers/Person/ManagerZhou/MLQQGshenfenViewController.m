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

@interface MLQQGshenfenViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    UITextField * _xingMingLabel;
    UITextField * _shenFenCardId;
    UIButton * _shangChuanButton1;
    UIButton * _shangChuanButton2;


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
    

}
- (void)viewWillAppear:(BOOL)animated{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];  
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
    //_shenFenCardId.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_shenFenCardId];
    //4
    UIView * spView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shenFenCardId.frame)+30, SIZE_WIDTH, 1)];
    spView3.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [self.view addSubview:spView3];

    UILabel * zhenglabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(spView3.frame)+30, 200, 22)];
    zhenglabel.text = @"上传身份证正面照";
    [self.view addSubview:zhenglabel];

    _shangChuanButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shangChuanButton1 setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton1 setFrame:CGRectMake(22, CGRectGetMaxY(zhenglabel.frame)+20, 80, 80)];
    [_shangChuanButton1 addTarget:self action:@selector(shangChuanTuPian) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_shangChuanButton1];

    UILabel * fanlabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(_shangChuanButton1.frame)+30, 200, 22)];
    fanlabel.text = @"上传身份证反面照";
    [self.view addSubview:fanlabel];

    _shangChuanButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shangChuanButton2 setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_shangChuanButton2 setFrame:CGRectMake(22, CGRectGetMaxY(fanlabel.frame)+20, 80, 80)];
    [_shangChuanButton2 addTarget:self action:@selector(shangChuanTuPian) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_shangChuanButton2];

    
}

- (void)shangChuanTuPian{
   
    [KZPhotoManager getImage:^(UIImage *image) {
//        [self uploadImgWith:image];
    } showIn:self AndActionTitle:@"选择照片"];
    
    
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

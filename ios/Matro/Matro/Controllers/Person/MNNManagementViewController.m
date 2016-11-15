//
//  MNNManagementViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNManagementViewController.h"
#import "MNNModifyNameViewController.h"
#import "MNNModifyPasswordViewController.h"
#import "MLAddressSelectViewController.h"
#import "MLBasicInfoViewController.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"
#import "GTMNSString+URLArguments.h"
#import "MyAddressManagerViewController.h"
#import "MLChangePhotoViewController.h"
#import "CommonHeader.h"
#import "MBProgressHUD+Add.h"

@interface MNNManagementViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UITableView *_tableView;
    UILabel *_lable;
    UIImageView *_imageView;
    NSString *loginid ;
    NSString *avatorurl;
    NSUserDefaults *userDefaults;
    UIAlertController *alertController;

}

@end

@implementation MNNManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户信息设置";
    [self createTableView];

    
    
    // Do any additional setup after loading the view.
}
//创建tableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"  基本信息";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"  收货地址";
    }else{
        cell.textLabel.text = @"  修改密码";
    }
    //tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * spView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SIZE_WIDTH, 1)];
    spView.backgroundColor = [HFSUtility hexStringToColor:Main_spelBackgroundColor];
    [cell addSubview:spView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //基本信息
    if (indexPath.row == 0) {
        MLBasicInfoViewController *vc = [[MLBasicInfoViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    //收货地址
    if (indexPath.row == 1) {
        MyAddressManagerViewController *vc = [[MyAddressManagerViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //修改密码
    if (indexPath.row == 2) {
        self.hidesBottomBarWhenPushed = YES;
        
        XiuGaiPasswordViewController * VC = [[XiuGaiPasswordViewController alloc]init];
        
        [self.navigationController pushViewController:VC animated:YES];
    }

}


/*
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


-(void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        
        
        NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
        UIImage *avatorimg = [UIImage imageWithData:imageData];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
        
        BOOL result = [UIImagePNGRepresentation(avatorimg)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
        _imageView.image = [UIImage imageWithData:imageData];

        if (result) {
            NSData *imgdata = [NSData dataWithContentsOfFile:filePath];
            
            NSString *_encodedImageStr =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imgdata base64EncodedStringWithOptions:0]] ;
            NSDictionary *persondic = @{@"imgFileName":@"avator.jpg",@"imgType":@"ReduceResolution",@"imgContent":_encodedImageStr};
            
            SBJSON *sbjson = [SBJSON new];
            NSString *sbstr = [sbjson stringWithObject:persondic error:nil];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[HFSServiceClient sharedClientwithUrl:SERVICE_BASE_URL] POST:@"image/upload" parameters:sbstr success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
            
        }
 
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSString *)StringNDic:(NSDictionary *)dic{
    
    NSMutableString *orderSpec = [NSMutableString string];
    NSArray *sortedKeys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
    for (NSString *key in sortedKeys) {
        [orderSpec appendFormat:@"%@=%@&", key, [dic objectForKey:key]];
    }
    
    return orderSpec;
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadImageUrl:(NSString *)imgUrl{
    
    NSString *mphone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    NSString *cardno = [userDefaults objectForKey:kUSERDEFAULT_USERCARDNO];
    NSString *nikeName = [userDefaults objectForKey:kUSERDEFAULT_USERNAME];
    [userDefaults synchronize];
    NSDictionary *dic = @{@"appId":APP_ID,@"nickname":nikeName,@"cardno":cardno,@"mphone":mphone,@"headPicUrl":imgUrl};
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient]POST:@"vip/updateUserInfo" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"头像修改成功";
            [_hud hide:YES afterDelay:2];
            
            [userDefaults setObject:imgUrl forKey:kUSERDEFAULT_USERAVATOR];
            
            
            if ([imgUrl hasSuffix:@"webp"]) {
                [_imageView setZLWebPImageWithURLStr:imgUrl withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGEUSERINFO object:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"msg"];
            [_hud hide:YES afterDelay:2];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

}
*/
@end

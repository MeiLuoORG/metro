//
//  MLBasicInfoViewController.m
//  Matro
//
//  Created by Matro on 2016/11/14.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBasicInfoViewController.h"
#import "MLChangePhotoViewController.h"
#import "MNNModifyNameViewController.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"
#import "GTMNSString+URLArguments.h"
#import "CommonHeader.h"
#import "MBProgressHUD+Add.h"
#import "MLHttpManager.h"
#import "Masonry.h"
#import "MLShippingaddress.h"
#import "MJExtension.h"
#import "MJRefresh.h"
@interface MLBasicInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,MNNModifyNameViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIImageView *_imageView;
    NSString *avatorurl;
    UILabel *niChengLabel;
    UILabel *sexLabel;
    UILabel *realNameLabel;
    UILabel *IDcardLabel;
    UILabel *areaLabel;
    UILabel *addressLabel;
    NSUserDefaults *userDefaults;
    BOOL isHeader;
    int seltype;
    UIControl *_blackView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *pickerRootView;
@property (strong, nonatomic) IBOutlet UIPickerView *addressPickerView;
@property (nonatomic,strong)NSMutableArray *addressData;
@property (strong,nonatomic)NSDictionary *inforesult;
@end

static MLShippingaddress *province,*city,*area;
@implementation MLBasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本信息设置";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [self creatTableView];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo) name:NOTIFICATION_CHANGEUSERINFO object:nil];
    
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT -  160)];
    [_blackView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];
    [self loadData];
    
    NSString *string = [[NSString alloc]initWithContentsOfFile:[self getDocumentpath] encoding:NSUTF8StringEncoding error:nil];
    
    if (!string) {
        [self getAllarea];
    }
    else{
        SBJSON *sbjson = [SBJSON new];
        NSArray *ary = [sbjson objectWithString:string error:nil];
        
        NSArray *modelArt = [MLShippingaddress mj_objectArrayWithKeyValuesArray:ary];
        self.addressData = [modelArt mutableCopy];
        
        province = [self.addressData firstObject];
        if (province.sub.count>0) {
            city = [province.sub firstObject];
            if (city.sub.count>0) {
                area = [city.sub firstObject];
            }
        }
        [self.addressPickerView reloadAllComponents];
        
    }
    
}
//-(void)viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:YES];
//    self.inforesult  = [NSDictionary dictionary];
//    [self loadData];
////    [self.tableView reloadData];
//   
//}

-(void)creatTableView{
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.tableView.header endRefreshing];
//        [self.tableView reloadData];
//        
//    }];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
//    [self.view addSubview:_tableView];
    
}
- (void)updateUserInfo{
    avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
    
    if ([avatorurl hasSuffix:@"webp"]) {
        [_imageView setZLWebPImageWithURLStr:avatorurl withPlaceHolderImage:PLACEHOLDER_IMAGE];
    } else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:avatorurl] placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
    }
    niChengLabel.text = [userDefaults objectForKey:kUSERDEFAULT_USERNAME];
    realNameLabel.text = [userDefaults objectForKey:@"name"];
    
    NSString *sfzstr = [userDefaults objectForKey:KUSERDEFAULT_IDCARD_SHENFEN];;
    if (sfzstr.length > 0) {
        NSMutableString *Mutablestr = [NSMutableString stringWithString:sfzstr];
        [Mutablestr replaceCharactersInRange:NSMakeRange(6, 8)withString:@"********"];
        NSString *newsfzstr = [Mutablestr copy];
        IDcardLabel.text = newsfzstr;
    }else{
        IDcardLabel.text = @"";
    }
    
    
    addressLabel.text = [userDefaults objectForKey:@"txAddr"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"inforesult===%@",self.inforesult);
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"  头像";
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH-90, 2, 36, 36)];
        _imageView.layer.cornerRadius = 18;
        _imageView.layer.masksToBounds = YES;
        if (self.inforesult[@"img"] && ![@"" isEqualToString:self.inforesult[@"img"]]) {
            NSString *img = self.inforesult[@"img"];
            avatorurl = img;
            
        }
        if (avatorurl) {
            
            if ([avatorurl hasSuffix:@"webp"]) {
                [_imageView setZLWebPImageWithURLStr:avatorurl withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:avatorurl] placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
            }
        }
        [cell.contentView addSubview:_imageView];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"  用户名";
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH-250, 10, 200, 20)];
        lable.text = self.inforesult[@"phone"];
        lable.textAlignment = NSTextAlignmentRight;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        UIView * kongView = [[UIView alloc]init];
        cell.accessoryView = kongView;
        [cell.contentView addSubview:lable];
        
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"  昵称";
        niChengLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        if ([self.inforesult[@"nickName"] isEqualToString:@""] || !self.inforesult[@"nickName"]) {
            NSString *nickName = self.inforesult[@"phone"];
            niChengLabel.text = nickName;
        }
        else{
            
            NSString *nickName = self.inforesult[@"nickName"];
            niChengLabel.text = nickName;
        }
        
        niChengLabel.textAlignment = NSTextAlignmentRight;
        niChengLabel.font = [UIFont systemFontOfSize:15.0];
        niChengLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        
        [cell.contentView addSubview:niChengLabel];
        
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"  性别";
        sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        NSString *sexLX = self.inforesult[@"sex"];
        if ([sexLX isEqual:@0]) {
            sexLabel.text = @"男";
        }else if([sexLX isEqual:@1]){
            sexLabel.text = @"女";
        }
        sexLabel.textAlignment = NSTextAlignmentRight;
        sexLabel.font = [UIFont systemFontOfSize:15.0];
        sexLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        
        [cell.contentView addSubview:sexLabel];
        
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"  真实姓名";
        realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        realNameLabel.text = self.inforesult[@"name"]?:@"";
        realNameLabel.textAlignment = NSTextAlignmentRight;
        realNameLabel.font = [UIFont systemFontOfSize:15.0];
        realNameLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        
        [cell.contentView addSubview:realNameLabel];
        
    }else if (indexPath.row == 5){
        cell.textLabel.text = @"  身份证";
        IDcardLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        NSString *sfzstr ;
        if (self.inforesult[@"idcard"]) {
            
            sfzstr = self.inforesult[@"idcard"];
        }
        else{
            sfzstr = @"";
        }
        if (sfzstr && ![sfzstr isEqualToString:@""]) {
            NSMutableString *Mutablestr = [NSMutableString stringWithString:sfzstr];
            [Mutablestr replaceCharactersInRange:NSMakeRange(6, 8)withString:@"********"];
            NSString *newsfzstr = [Mutablestr copy];
            IDcardLabel.text = newsfzstr;
        }else{
            IDcardLabel.text = @"";
        }

        IDcardLabel.textAlignment = NSTextAlignmentRight;
        IDcardLabel.font = [UIFont systemFontOfSize:15.0];
        IDcardLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        
        [cell.contentView addSubview:IDcardLabel];
        
    }else if (indexPath.row == 6){
        cell.textLabel.text = @"  邮箱";
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH-250, 10, 200, 20)];
        
////        lable.text = @"";
//        if (self.inforesult[@"email"] && ![self.inforesult[@"email"] isEqualToString:@""]) {
//            
//            lable.text = self.inforesult[@"email"];
//            
//        }else{
//            NSString *comstr = @"@matrojp.com";
//            NSString *phone = self.inforesult[@"phone"];
//            NSString *pjemail = [NSString stringWithFormat:@"%@%@",phone,comstr];
//            lable.text = pjemail;
////            lable.text = [NSString stringWithFormat:@"%@%@",phone,comstr];
////            lable.text = pjemail;
//        }
        lable.text = [userDefaults objectForKey:@"email"];;
        lable.textAlignment = NSTextAlignmentRight;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        UIView * kongView = [[UIView alloc]init];
        cell.accessoryView = kongView;
        [cell.contentView addSubview:lable];
        
    }else if (indexPath.row == 7){
        cell.textLabel.text = @"  手机";
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH-250, 10, 200, 20)];
        lable.text = self.inforesult[@"phone"];
        lable.textAlignment = NSTextAlignmentRight;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        UIView * kongView = [[UIView alloc]init];
        cell.accessoryView = kongView;
        [cell.contentView addSubview:lable];
        
    }else if (indexPath.row == 8){
        cell.textLabel.text = @"  所在地区";
        areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        NSDictionary *address = self.inforesult[@"address"];
        if (address) {
            NSString *province = address[@"province"];
            NSString *city = address[@"city"];
            NSString *county = address[@"county"];
            NSString *userAddr = [NSString stringWithFormat:@"%@ %@ %@",province,city,county];
            
            areaLabel.text = userAddr;
        
        }else{
           
            areaLabel.text = @"";
            
        }
        areaLabel.textAlignment = NSTextAlignmentRight;
        areaLabel.font = [UIFont systemFontOfSize:15.0];
        areaLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        
        [cell.contentView addSubview:areaLabel];
        
    }else if (indexPath.row == 9){
        cell.textLabel.text = @"  通讯地址";
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        addressLabel.text = [userDefaults objectForKey:@"txAddr"];
        NSDictionary *address = self.inforesult[@"address"];
        if (address) {
           
            NSString *txAddr = address[@"address"];
          
            addressLabel.text = txAddr;
            
            
        }else{
            addressLabel.text = @"";
        }
        addressLabel.textAlignment = NSTextAlignmentRight;
        addressLabel.font = [UIFont systemFontOfSize:15.0];
        addressLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        
        [cell.contentView addSubview:addressLabel];
        
    }
    if (indexPath.row != 1 || indexPath.row != 6 || indexPath.row != 7) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (indexPath.row == 0) {
        isHeader = YES;
        [self someButtonClicked];
    }else if (indexPath.row == 2){
        self.hidesBottomBarWhenPushed = YES;
        MNNModifyNameViewController *modifyNameVC = [MNNModifyNameViewController new];
        modifyNameVC.navTitle = @"修改昵称";
        modifyNameVC.xiugaitype = @"1";
        seltype = 1;
        modifyNameVC.delegate = self;
//        modifyNameVC.currentName = [userDefaults objectForKey:kUSERDEFAULT_USERNAME];
        modifyNameVC.currentName = niChengLabel.text;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    }else if (indexPath.row == 3){
        isHeader = NO;
        [self someButtonClicked];
    }else if (indexPath.row == 4){
        self.hidesBottomBarWhenPushed = YES;
        MNNModifyNameViewController *modifyNameVC = [MNNModifyNameViewController new];
        modifyNameVC.navTitle = @"修改真实姓名";
        modifyNameVC.xiugaitype = @"2";
        seltype = 2;
        modifyNameVC.delegate = self;
//        modifyNameVC.currentName = [userDefaults objectForKey:@"name"];
        modifyNameVC.currentName = realNameLabel.text;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    }else if (indexPath.row == 5){
        self.hidesBottomBarWhenPushed = YES;
        MNNModifyNameViewController *modifyNameVC = [MNNModifyNameViewController new];
        modifyNameVC.navTitle = @"修改身份证";
        modifyNameVC.xiugaitype = @"3";
        seltype = 3;
        modifyNameVC.delegate = self;
//        modifyNameVC.currentName = [userDefaults objectForKey:KUSERDEFAULT_IDCARD_SHENFEN];
        NSString *sfzstr = self.inforesult[@"idcard"];
        modifyNameVC.currentName = sfzstr;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    }else if(indexPath.row == 8){
        NSLog(@"点击了地址");
        _blackView.hidden = _pickerRootView.hidden = NO;
//        [self.tableView insertSubview:self.pickerRootView atIndex:0];
        
    }else if(indexPath.row == 9){
        self.hidesBottomBarWhenPushed = YES;
        MNNModifyNameViewController *modifyNameVC = [MNNModifyNameViewController new];
        modifyNameVC.navTitle = @"修改通讯地址";
        modifyNameVC.xiugaitype = @"5";
        seltype = 5;
        modifyNameVC.delegate = self;
//        modifyNameVC.currentName = [userDefaults objectForKey:@"txAddr"];
        modifyNameVC.currentName = addressLabel.text;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    }
    
}

#pragma mark 修改昵称 代理
- (void)MNNModifyNameViewController:(MNNModifyNameViewController *)ViewControlle userName:(NSString *)userName {
    if (seltype == 1) {
        niChengLabel.text = userName;
    }else if (seltype == 2){
        realNameLabel.text = userName;
    }else if (seltype == 3){
        NSString *sfzstr = userName;
        NSMutableString *Mutablestr = [NSMutableString stringWithString:sfzstr];
        [Mutablestr replaceCharactersInRange:NSMakeRange(6, 8)withString:@"********"];
        NSString *newsfzstr = [Mutablestr copy];
        IDcardLabel.text = newsfzstr;
        
    }else {
        addressLabel.text = userName;
    }
//    [self.tableView reloadData];
}
#pragma end mark

#pragma mark 修改图片 昵称
- (void)someButtonClicked {
    UIActionSheet * sheet;
    if (isHeader == YES) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册上传" otherButtonTitles:@"拍照上传", nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    }
    
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击了第几个按钮result = %d", (int)buttonIndex);
    if(buttonIndex == 0){
        if (isHeader == YES) {
            MLChangePhotoViewController *vc = [[MLChangePhotoViewController alloc]init];
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
        }else{
            NSDictionary *params = @{@"type":@"6",@"sex":@"1"};
            [MLHttpManager post:XiuGaiBaseInfo_URLString params:params m:@"member" s:@"admin_member" success:^(id responseObject) {
                NSLog(@"responseObject===%@",responseObject);
                if ([responseObject[@"code"] isEqual:@0]) {
                    sexLabel.text = @"男";
                    int reSex = 0;
                    [userDefaults setObject:[NSNumber numberWithInt:reSex] forKey:@"sex"];
                }else{
                    NSString *msg = responseObject[@"msg"];
                    [MBProgressHUD show:msg view:self.view];
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
            }];
            
        }
    }
    else if (buttonIndex == 1){
        if (isHeader == YES) {
            MLChangePhotoViewController *vc = [[MLChangePhotoViewController alloc]init];
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
        }else{
            
            NSDictionary *params = @{@"type":@"6",@"sex":@"2"};
            [MLHttpManager post:XiuGaiBaseInfo_URLString params:params m:@"member" s:@"admin_member" success:^(id responseObject) {
                NSLog(@"responseObject===%@",responseObject);
                if ([responseObject[@"code"] isEqual:@0]) {
                    sexLabel.text = @"女";
                    int reSex = 1;
                    [userDefaults setObject:[NSNumber numberWithInt:reSex] forKey:@"sex"];
                }else{
                    NSString *msg = responseObject[@"msg"];
                    [MBProgressHUD show:msg view:self.view];
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
            }];
            
        }
        
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
#pragma end mark

#pragma mark- UIPickerViewDataSource and UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    
    switch (component) {
        case 0:
            return self.addressData.count;
            break;
        case 1:
            return province.sub.count;
            break;
        default:
        {
            return city.sub.count;;
        }
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
        {
            MLShippingaddress *add = [self.addressData objectAtIndex:row];
            return add.name;
        }
            break;
        case 1:
        {
            MLShippingaddress *tt = [province.sub objectAtIndex:row];
            return tt.name;
        }
            
            break;
        default:
        {
            MLShippingaddress *tt = [city.sub objectAtIndex:row];
            return tt.name;
        }
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            province = [self.addressData objectAtIndex:row];
            [self.addressPickerView reloadComponent:1];
            if (province.sub.count>0) {
                city = [province.sub firstObject];
                [_addressPickerView selectRow:0 inComponent:1 animated:YES];
                if (city.sub.count>0) {
                    [self.addressPickerView reloadComponent:2];
                    area = [city.sub firstObject];
                    [_addressPickerView selectRow:0 inComponent:2 animated:YES];
                }
            }
            [_addressPickerView reloadComponent:2];
            break;
        case 1:
            city = [province.sub objectAtIndex:row];
            [self.addressPickerView reloadComponent:2];
            if (city.sub.count>0) {
                area = [city.sub firstObject];
                [_addressPickerView selectRow:0 inComponent:2 animated:YES];
            }
            
            break;
        case 2:
            area = [city.sub objectAtIndex:row];
            break;
        default:
            
            break;
    }
}

- (NSMutableArray *)addressData{
    if (!_addressData) {
        _addressData = [NSMutableArray array];
    }
    return _addressData;
}

- (NSDictionary *)inforesult{
    if (!_inforesult) {
        _inforesult = [NSDictionary dictionary];
    }
    return _inforesult;
}

//获取行政区
- (void)getAllarea
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_orderadder&do=dis",MATROJP_BASE_URL];
    [MLHttpManager get:urlStr params:nil m:@"member" s:@"admin_orderadder" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([[result objectForKey:@"code"] isEqual:@0]) {
            
            NSDictionary *data = result[@"data"];
            NSArray *district_info = [MLShippingaddress mj_objectArrayWithKeyValuesArray:data[@"district_info"]];
            NSArray *tmp = [MLShippingaddress mj_keyValuesArrayWithObjectArray:district_info];
            NSLog(@"%@",tmp);
            
            SBJSON *sbjson = [SBJSON new];
            NSError *error;
            NSString *jsonstr = [sbjson stringWithObject:tmp error:&error];
            if (jsonstr) {
                [jsonstr writeToFile:[self getDocumentpath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }
            
            [self.addressData addObjectsFromArray:district_info];
            province = [self.addressData firstObject];
            if (province.sub.count>0) {
                city = [province.sub firstObject];
                if (city.sub.count>0) {
                    area  = [city.sub firstObject];
                }
            }
            [self.addressPickerView reloadAllComponents];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}

- (NSString*)getDocumentpath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Area.json"]];
    return filePath;
}

- (IBAction)cancelButtonAction:(id)sender {
    _blackView.hidden = _pickerRootView.hidden = YES;
}
- (IBAction)addressSureButtonAction:(id)sender {
    _blackView.hidden = _pickerRootView.hidden = YES;
    NSString *newaddress = [NSString stringWithFormat:@"%@ %@ %@",province?province.name:@"",city?city.name:@"",area?area.name:@""];
    if (newaddress.length >0) {
        NSDictionary *params = @{@"type":@"4",@"area_str":newaddress};
        [MLHttpManager post:XiuGaiBaseInfo_URLString params:params m:@"member" s:@"admin_member" success:^(id responseObject) {
            NSLog(@"responseObject===%@",responseObject);
            if ([responseObject[@"code"] isEqual:@0]) {
                [userDefaults setObject:newaddress forKey:@"userAddr"];
                areaLabel.text = newaddress;
//                [self.tableView reloadData];
                [MBProgressHUD show:@"修改地址成功" view:self.view];
            }else{
                NSString *msg = responseObject[@"msg"];
               [MBProgressHUD show:msg view:self.view];
            }
        } failure:^(NSError *error) {
            
            [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
        }];
    }
    
}


#pragma mark 获取会员  会员卡信息
- (void)loadData {
    NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
    NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":phone}];
    NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                            @"phone":phone,
                            @"sign":signDic[@"sign"],
                            @"accessToken":accessToken
                            };
    
    NSData *data2 = [HFSUtility RSADicToData:dic2];
    NSString *ret2 = base64_encode_data(data2);
    
    [self yuanShengHuiYuanKaWithRet2:ret2];
 
}
#pragma mark 原生会员卡信息
- (void) yuanShengHuiYuanKaWithRet2:(NSString *)ret2{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSString *urlStr = [NSString stringWithFormat:@"%@",VIPInfo_URLString];
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
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              //JSON解析
                                              // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              
                                              NSLog(@"获取会员卡信息%@",result);
//                                              Inforesult = result;
                                              if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                         
                                                  NSDictionary * userDataDic = result[@"data"];
                                                  self.inforesult = userDataDic;
                                                  NSLog(@"self.inforesult===%@",self.inforesult);
                                                  NSDictionary *address = userDataDic[@"address"];
                                                  NSLog(@"address===%@",address);
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.tableView reloadData];
                                                  });
                                                  
             /*
                                                  if (userDataDic[@"img"] && ![@"" isEqualToString:userDataDic[@"img"]]) {
                                                      [userDefaults setObject:userDataDic[@"img"] forKey:kUSERDEFAULT_USERAVATOR ];
                                                      avatorurl = userDataDic[@"img"];
                                                      
                                                  }
                                                  
                                                  [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERPHONE];
                                                  //昵称
                                                  if ([userDataDic[@"nickName"] isEqualToString:@""] || !userDataDic[@"nickName"]) {
                                                      [userDefaults setObject:userDataDic[@"phone"] forKey:kUSERDEFAULT_USERNAME ];
                                                      NSString *nickName = userDataDic[@"phone"];
                                                      niChengLabel.text = nickName;
                                                  }
                                                  else{
                                                      [userDefaults setObject:userDataDic[@"nickName"] forKey:kUSERDEFAULT_USERNAME ];
                                                      NSString *nickName = userDataDic[@"nickName"];
                                                      niChengLabel.text = nickName;
                                                  }
                             
                                                  //身份证
                                                  if (userDataDic[@"idcard"]) {
                                                      [userDefaults setObject:userDataDic[@"idcard"] forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                                                      IDcardLabel.text = userDataDic[@"idcard"];
                                                  }
                                                  else{
                                                      [userDefaults setObject:@"" forKey:KUSERDEFAULT_IDCARD_SHENFEN];
                                                  }
                                                  //所在地区
                                                  if (address) {
                                                      NSString *province = address[@"province"];
                                                      NSString *city = address[@"city"];
                                                      NSString *county = address[@"county"];
                                                      NSString *txAddr = address[@"address"];
                                                      NSString *userAddr = [NSString stringWithFormat:@"%@ %@ %@",province,city,county];
                                                      if (txAddr && txAddr.length > 0 ) {
                                                          [userDefaults setObject:txAddr forKey:@"txAddr"];
                                                      }else{
                                                          [userDefaults setObject:@"" forKey:@"txAddr"];
                                                      }
                                                      if (userAddr && userAddr.length > 0 ) {
                                                          [userDefaults setObject:userAddr forKey:@"userAddr"];
                                                      }else{
                                                          [userDefaults setObject:@"" forKey:@"userAddr"];
                                                      }
                                                      areaLabel.text = userAddr;
                                                      addressLabel.text = txAddr;
                                                      
                                                      
                                                  }else{
                                                      [userDefaults setObject:@"" forKey:@"txAddr"];
                                                      [userDefaults setObject:@"" forKey:@"userAddr"];
                                                      areaLabel.text = @"";
                                                      addressLabel.text = @"";
                                                  }
                                                  //性别，真实姓名，邮箱
                                                  NSString *sex = userDataDic[@"sex"]?:@"";
                                                  NSString *name = userDataDic[@"name"]?:@"";
                                                  if (userDataDic[@"email"] && ![userDataDic[@"email"] isEqualToString:@""]) {
                                                      [userDefaults setObject: userDataDic[@"email"] forKey:@"email"];
                                                      
                                                      
                                                  }else{
                                                      NSString *pjemail = [NSString stringWithFormat:@"%@@matrojp.com",userDataDic[@"phone"]];
                                                      [userDefaults setObject:pjemail forKey:@"email"];
                                                  }
                                                  NSLog(@"sex===%@--name===%@",sex,name);
                                                  [userDefaults setObject:sex forKey:@"sex"];
                                                  [userDefaults setObject:name forKey:@"name"];
                                                  
                                                  if ([sex isEqual:@0]) {
                                                      sexLabel.text = @"男";
                                                  }else if([sex isEqual:@1]){
                                                      sexLabel.text = @"女";
                                                  }
                                                  realNameLabel.text = name;
                                                 
                                                */  
                                              }else{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = result[@"errMsg"];
                                                      _hud.labelFont = [UIFont systemFontOfSize:13];
                                                      [_hud hide:YES afterDelay:1];
                                                  });
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

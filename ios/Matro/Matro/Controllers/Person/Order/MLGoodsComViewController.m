//
//  MLGoodsComViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsComViewController.h"
#import "MLGoodsComHeadView.h"
#import "MLGoodsComFootView.h"
#import "MLGoodsComPhotoCell.h"

#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"
#import "GTMNSString+URLArguments.h"
#import "MBProgressHUD+Add.h"


@interface MLGoodsComViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *imgsArray;
@property (nonatomic,assign)NSInteger comScore;
@property (nonatomic,strong)MLGoodsComHeadView *headView;

@end

@implementation MLGoodsComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - self.navigationController.navigationBar.bounds.size.height - 10)];
        [tableView registerNib:[UINib nibWithNibName:@"MLGoodsComPhotoCell" bundle:nil] forCellReuseIdentifier:kMLGoodsComPhotoCell];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    
    __weak typeof(self) weakself = self;
    
    MLGoodsComHeadView *headView = [MLGoodsComHeadView goodsComHeadView];
    headView.comScore = ^(NSInteger score){
        weakself.comScore = score;
    };
    headView.titleLabel.text = self.product.SPNAME;
    [headView.imageView sd_setImageWithURL:[NSURL URLWithString:self.product.IMGURL] placeholderImage:PLACEHOLDER_IMAGE];
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    
    
    MLGoodsComFootView *footView = [MLGoodsComFootView goodsComFootView];
    [footView.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [footView.sendComBtn addTarget:self action:@selector(sendComDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = footView;
    
}


/**
 *  发送商品评价
 *
 */
- (void)sendComDetail:(id)sender{
    if (self.comScore == 0) {
        NSLog(@"请选择评分");
        [MBProgressHUD showMessag:@"请选择评分" toView:self.view];
    }
    if (self.headView.textView.text.length == 0) {
        NSLog(@"请输入评价内容");
        [MBProgressHUD showMessag:@"请输入评价内容" toView:self.view];
    }
    
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    NSString *nikeName = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERNAME];
    
    NSDictionary *parm = @{@"orderId":self.orderid,@"userId":userId,@"productId":self.product.XSMSP_ID,@"productScore":[NSNumber numberWithInteger:_comScore],@"nickname":nikeName,@"content":self.headView.textView.text,@"imageList":self.imgsArray.description};
    NSLog(@"%@",parm);
    
    
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"order/ProductScore" parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"status"];
        
        if ([result isEqualToString:@"0"]) {
            [MBProgressHUD showMessag:@"评价成功" toView:self.view];
        }
        else{
             [MBProgressHUD showMessag:responseObject[@"msg"] toView:self.view];
        }
        
        [self performSelector:@selector(goBack) withObject:nil afterDelay:2];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       [MBProgressHUD showMessag:@"请求失败" toView:self.view];
        
    }];

}

- (void)goBack{
     [self.navigationController popViewControllerAnimated:YES];
}




/**
 *  添加图片
 *
 */
-(void)addImage:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *otherAction01 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showImagePickerView:UIImagePickerControllerSourceTypeCamera];
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"该设备不支持相机拍照";
            [_hud hide:YES afterDelay:2];
        }
        
    }];
    UIAlertAction *otherAction02 = [UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self showImagePickerView:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    
    [alert addAction:otherAction01];
    [alert addAction:otherAction02];
    [alert addAction:cancel];
    [self  presentViewController:alert animated:YES completion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLGoodsComPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLGoodsComPhotoCell forIndexPath:indexPath];
    __weak typeof(self) weakself = self;
    NSString *url = [self.imgsArray objectAtIndex:indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:PLACEHOLDER_IMAGE];
    cell.goodsComDelImageBlock = ^(){
        [weakself.imgsArray removeObjectAtIndex:indexPath.row];
        [weakself.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}


- (NSMutableArray *)imgsArray{
    if (!_imgsArray) {
        _imgsArray = [NSMutableArray array];
    }
    return _imgsArray;
}


-(void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        
        NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
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
                            [self.imgsArray addObject:imgrurl];
                            [self.tableView reloadData];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end

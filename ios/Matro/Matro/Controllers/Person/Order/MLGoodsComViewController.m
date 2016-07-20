//
//  MLGoodsComViewController.m
//  Matro
//
//  Created by MR.Huang on 16/5/12.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsComViewController.h"
#import "MLGoodsComHeadView.h"
#import "MLGoodsComFootView.h"
#import "MLGoodsComPhotoCell.h"
#import "KZPhotoManager.h"

#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"
#import "GTMNSString+URLArguments.h"
#import "MBProgressHUD+Add.h"
#import "MLHttpManager.h"
#import "UMMobClick/MobClick.h"

@interface MLGoodsComViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *imgsArray;
@property (nonatomic,strong)NSMutableArray *imgUrlArray;
@property (nonatomic,assign)NSInteger comScore;
@property (nonatomic,strong)MLGoodsComHeadView *headView;

@end

@implementation MLGoodsComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    self.comScore = 5;
    self.title = @"商品评价";
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
    headView.titleLabel.text = self.product.name;
    [headView bringSubviewToFront:headView.countLabel];
    [headView.imageView sd_setImageWithURL:[NSURL URLWithString:self.product.pic] placeholderImage:PLACEHOLDER_IMAGE];
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    MLGoodsComFootView *footView = [MLGoodsComFootView goodsComFootView];
    [footView.addImgBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [footView.sendComBtn addTarget:self action:@selector(sendComDetail:) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.tableFooterView = footView;
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}


/**
 *  发送商品评价
 *
 */
- (void)sendComDetail:(id)sender{
    if (self.comScore == 0) {
        [MBProgressHUD showMessag:@"请选择评分" toView:self.view];
        return;
    }
    if (self.headView.textView.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入评价内容" toView:self.view];
        return;
    }
    if (self.headView.textView.text.length> 1000) {
        [MBProgressHUD showMessag:@"评价内容过长，请不要超过1000字" toView:self.view];
        return;
    }
    if (self.imgsArray.count > 0) {
        __block  NSInteger already = 0;
        __block  NSInteger uploadCount = self.imgsArray.count;
        [self.imgsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *img = (UIImage *)obj;
            NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
            NSDictionary *params = @{@"method":@"comment"};
            NSString *url =[NSString stringWithFormat:@"%@/api.php?m=uploadimg&s=index",MATROJP_BASE_URL];
            [MLHttpManager post:url params:params m:@"uploadimg" s:@"index" sconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imgData name:@"picture" fileName:@"uploadimg.jpg" mimeType:@"image/jpg"];
            } success:^(id responseObject) {
                NSDictionary *result = (NSDictionary *)responseObject;
                if ([result[@"code"] isEqual:@0]) { //上传成功
                    NSDictionary *data = result[@"data"];
                    NSString *url = data[@"pic_url"];
                    [self.imgUrlArray addObject:url];
                    already++;
                    if (already == uploadCount) { //图片上传完成  请求退货操作
                        [self uploadCommentInfoWithUpImage:YES];
                    }
                }else{//上传失败就跳过 少传一张
                    uploadCount -- ;
                }

            } failure:^(NSError *error) {
                
            }];
        }];
    }else{
        [self uploadCommentInfoWithUpImage:NO];
    }
    

}

- (void)uploadCommentInfoWithUpImage:(BOOL)isUpImage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"pid":self.pid,@"comment_text":self.headView.textView.text,@"stars":[NSNumber numberWithInteger:self.comScore],@"pic":isUpImage?[self.imgUrlArray componentsJoinedByString:@","]:@"",@"order_id":self.order_id?:@""};
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment_submit&method=product_submit",MATROJP_BASE_URL];
    [MLHttpManager post:url params:params m:@"product" s:@"comment_submit" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            if (self.goodsComSuccess) {
                self.goodsComSuccess();
            }
            [MBProgressHUD showMessag:@"评价成功" toView:self.view];
            [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


- (void)goBack{
     [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
}

/**
 *  添加图片
 *
 */
-(void)addImage:(id)sender{
    [KZPhotoManager getImage:^(UIImage *image) {
        [self.imgsArray addObject:image];
        [self.tableView reloadData];
    } showIn:self AndActionTitle:@"请选择图片"];
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLGoodsComPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLGoodsComPhotoCell forIndexPath:indexPath];
    __weak typeof(self) weakself = self;
    UIImage *img = [self.imgsArray objectAtIndex:indexPath.row];
    cell.myImageView.image = img;
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

- (NSMutableArray *)imgUrlArray{
    if (!_imgUrlArray) {
        _imgUrlArray = [NSMutableArray array];
    }
    return _imgUrlArray;
}




@end

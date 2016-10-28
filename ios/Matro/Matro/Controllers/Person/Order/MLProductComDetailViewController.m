//
//  MLProductComDetailViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLProductComDetailViewController.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "MLCommentProductModel.h"
#import "HFSServiceClient.h"
#import "MLGoodsComPhotoCell.h"
#import "MLProductComDetailHeadCell.h"
#import "MLCommentDetailUserTableViewCell.h"
#import "MLCommentDetailTextTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"
#import "MBProgressHUD+Add.h"
#import "MLHttpManager.h"
#import "MJPhotoBrowser.h"
#import "MLLoginViewController.h"

@interface MLProductComDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLProductCommentDetailModel *commentDetail;


@end

@implementation MLProductComDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品评价";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLGoodsComPhotoCell" bundle:nil] forCellReuseIdentifier:kMLGoodsComPhotoCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLProductComDetailHeadCell" bundle:nil] forCellReuseIdentifier:kProductComDetailHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLCommentDetailUserTableViewCell" bundle:nil] forCellReuseIdentifier:kCommentDetailUserTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLCommentDetailTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    
    [self getComment];
}

- (void)getComment{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment&method=detail&id=%@",MATROJP_BASE_URL,self.comment_id];
    [MLHttpManager get:url params:nil m:@"product" s:@"comment" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            self.commentDetail = [MLProductCommentDetailModel mj_objectWithKeyValues:data];
            [self.tableView reloadData];
            
        }else if ([result[@"code"]isEqual:@1002]){
            
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
        }else{
            NSString *msg = result[@"msg"];
             [MBProgressHUD show:msg view:self.view];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentDetail.comment_detail.photos.count + 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MLProductComDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductComDetailHeadCell forIndexPath:indexPath];
        cell.productModel = self.commentDetail.product;
        return cell;
    }else if (indexPath.row == 1){
        MLCommentDetailUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentDetailUserTableViewCell forIndexPath:indexPath];
        cell.buyUser = self.commentDetail.byuser;
        return cell;
    }
    else if (indexPath.row == 2){
        MLCommentDetailTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
        cell.contentLabel.text = self.commentDetail.comment_detail.con;
        return cell;
    }
    else{
        MLGoodsComPhotoCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLGoodsComPhotoCell forIndexPath:indexPath];
        cell.delBtn.hidden = YES;
        
        MLProductCommentImage *imageModel = [self.commentDetail.comment_detail.photos objectAtIndex:indexPath.row - 3];
        
        
        if ([imageModel.data_src hasSuffix:@"webp"]) {
            [cell.myImageView setZLWebPImageWithURLStr:imageModel.data_src withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:imageModel.data_src] placeholderImage:PLACEHOLDER_IMAGE];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }else if (indexPath.row ==1){
        return 50;
    }
    else if (indexPath.row == 2){
        return self.commentDetail.comment_detail.cellHeight;
    }
    else{
        return (MAIN_SCREEN_WIDTH - 32)+16;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //查看图片
    if (indexPath.row > 2) {
        MJPhotoBrowser *_photoBrow = [[MJPhotoBrowser alloc]init];
        NSMutableArray *tmp = [NSMutableArray array];
        
        for (MLProductCommentImage *imageModel  in self.commentDetail.comment_detail.photos) {
            MJPhoto *photo = [[MJPhoto alloc]init];
            photo.url = [NSURL URLWithString:imageModel.data_src];
            [tmp addObject:photo];
        }
        _photoBrow.photos = [tmp copy];
        _photoBrow.currentPhotoIndex = indexPath.row - 3;
        [_photoBrow show];

    }
}




@end

//
//  MLReturnRequestViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnRequestViewController.h"
#import "MLReturnRequestFootView.h"
#import "Masonry.h"
#import "MLReturnRequestTableViewCell.h"

#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLZTextTableViewCell.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLTuiHuoFooterView.h"
#import "MLTuiHuoMiaoshuTableViewCell.h"
#import "MLTuiHuoFukuanTableViewCell.h"
#import "MLXuanZeTuPianTableViewCell.h"
#import "MBProgressHUD+Add.h"
#import "MJExtension.h"

#import "NSString+GONMarkup.h"
#import "MLWenTiBiaoQianTableViewCell.h"

#import "MLMoreTableViewCell.h"
#import "KZPhotoManager.h"
#import "HFSServiceClient.h"

#import "MLTuiHuoChengGongViewController.h"
#import "MLReturnsDetailModel.h"


@interface MLReturnRequestViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isOpen;
    PlaceholderTextView *messageText;
    UITextField *usernameField;
    UITextField *userphoneField;
    MLReturnsQuestiontype *selQuestion;
    NSArray *tagsArray;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLTuiHuoFooterView *footerView;
@property (nonatomic,assign)BOOL fapiao;
@property (nonatomic,strong)NSMutableArray *imgsUrlArray;

@property (nonatomic,strong)MLReturnsDetailModel *returnsDetail;


@end


@implementation MLReturnRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"申请退货";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLZTextTableViewCell" bundle:nil] forCellReuseIdentifier:kZTextTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLTuiHuoFukuanTableViewCell" bundle:nil] forCellReuseIdentifier:kTuiHuoFukuanTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLTuiHuoMiaoshuTableViewCell" bundle:nil] forCellReuseIdentifier:kTuiHuoMiaoshuTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLXuanZeTuPianTableViewCell" bundle:nil] forCellReuseIdentifier:kXuanZeTuPianTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLWenTiBiaoQianTableViewCell" bundle:nil] forCellReuseIdentifier:kWenTiBiaoQianTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MLTuiHuoFooterView *footView = [MLTuiHuoFooterView footView];
        [footView.submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        footView.frame = CGRectMake(0, 0, SCREENWIDTH, 250);
        tableView.tableFooterView = footView;
        userphoneField = footView.phoneField;
        usernameField = footView.nameField;
        self.footerView = footView;
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];
    
    [self getOrderDetail];

}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.returnsDetail.isMore ) { //有更多
            if (self.returnsDetail.isOpen) { //如果已经在展开
               return  self.returnsDetail.products.count+2;
            }
            return 5; //有更多 未展开
        }
        return self.returnsDetail.products.count+2;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakself = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //订单号
            MLZTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZTextTableViewCell forIndexPath:indexPath];
            NSString *attStr = [NSString stringWithFormat:@"订单单号：<color value=\"#999999\">%@</>",self.returnsDetail.order_id];
            cell.titleLabel.attributedText =[attStr createAttributedString];
            cell.subLabel.text = [NSString stringWithFormat:@"￥%.2f",self.returnsDetail.product_price];
            cell.subLabel.textColor = RGBA(255, 78, 37, 1);
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
            line.backgroundColor = RGBA(245, 245, 245, 1);
            [cell addSubview:line];
            return cell;
            
        }else if (indexPath.row == 1){//商铺头
            MLOrderInfoHeaderTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.shopName.text = self.returnsDetail.company;
            cell.statusLabel.hidden = YES;
            return cell;
        }else { //
            if (self.returnsDetail.isMore && !self.returnsDetail.isOpen && indexPath.row==4) {//有更多
                MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
                [cell.moreButton addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
                [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",self.returnsDetail.products.count-2] forState:UIControlStateNormal];
                return cell;
            }
            MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tuiHuoProduct = [self.returnsDetail.products objectAtIndex:indexPath.row-2];
            return cell;
            
        }
    }else if (indexPath.section == 1){
        MLWenTiBiaoQianTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:kWenTiBiaoQianTableViewCell forIndexPath:indexPath];
        cell.clickStr = self.returnsDetail.returnInfo.question_type.content;
        cell.tags = tagsArray;
        cell.wenTiBiaoQianSelBlock = ^(NSArray *tagsIndex){
            NSString *indexStr = [tagsIndex firstObject];
            NSInteger index = [indexStr integerValue];
            selQuestion = [weakself.returnsDetail.question_type objectAtIndex:index];
        };
        return cell;
    }else if (indexPath.section == 2){
        MLTuiHuoMiaoshuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTuiHuoMiaoshuTableViewCell forIndexPath:indexPath];
        messageText = cell.textView;
        
        return cell;
    }else if(indexPath.section == 3){
        MLXuanZeTuPianTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:kXuanZeTuPianTableViewCell forIndexPath:indexPath];
        cell.xuanZeTuPianBlock = ^(){//选择图片
            [KZPhotoManager getImage:^(UIImage *image) {
                MLXuanZeTuPianTableViewCell *cell  =[weakself.tableView cellForRowAtIndexPath:indexPath];
                [cell.imgsArray insertObject:image atIndex:0];
                [cell.collectionView reloadData];
            } showIn:weakself AndActionTitle:@"请选择照片"];
        };
        return cell;
    }else if(indexPath.section == 4){
        MLTuiHuoFukuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTuiHuoFukuanTableViewCell forIndexPath:indexPath];
        cell.tuiHuoFukuanFaPiaoBlock = ^(BOOL fapiao){
            weakself.fapiao = fapiao;
        };
        return cell;
    }
    else{
        return nil;
    }

}



- (void)showMore:(id)sender{
    isOpen = YES;
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row < 2 ||(self.returnsDetail.isMore && !self.returnsDetail.isOpen && indexPath.row==4) ) {
            return 44;
        }
        return 134;
    }
    else if (indexPath.section == 1){
        IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
        frame.tagsMinPadding = 4;
        frame.tagsMargin = 10;
        frame.tagsLineSpacing = 10;
        frame.tagsArray = tagsArray;
        return frame.tagsHeight + 35;
    }
    else if (indexPath.section == 2){
        return 200;
    }else if (indexPath.section ==3){
        return 180;
    }
    return 88;
}


#pragma mark 提交操作

- (void)submitAction:(id)seder{
    
    if (![self checkFormat]) {
        return;
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:3];
    MLXuanZeTuPianTableViewCell *cell  =[self.tableView cellForRowAtIndexPath:index];
    if (cell.imgsArray.count > 0) {
        
        
        __block  NSInteger already = 0;
        __block  NSInteger uploadCount = cell.imgsArray.count - 1;
        
        [cell.imgsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx<cell.imgsArray.count-1) {
                UIImage *img = (UIImage *)obj;
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
                NSDictionary *params = @{@"method":@"refund_img",@"order_id":self.returnsDetail.order_id};
                [manager POST:@"http://bbctest.matrojp.com/api.php?m=uploadimg&s=index" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:imgData name:@"picture" fileName:@"uploadimg.jpg" mimeType:@"image/jpg"];
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *result = (NSDictionary *)responseObject;
                    if ([result[@"code"] isEqual:@0]) { //上传成功
                        NSDictionary *data = result[@"data"];
                        NSString *url = data[@"pic_url"];
                        [self.imgsUrlArray addObject:url];
                        already++;
                        if (already == uploadCount) { //图片上传完成  请求退货操作
                            [self submitTuihuoAction];
                            
                        }
                    }else{//上传失败就跳过 少传一张
                        uploadCount -- ;
                    }
                    NSLog(@"%@",responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                }];
                
            }
        }];
    }else{
        [MBProgressHUD showMessag:@"请选择图片" toView:self.view];
    }

}

- (void)submitTuihuoAction{

    NSString *url = [NSString stringWithFormat:@"http://bbctest.matrojp.com/api.php?m=return&s=save_return&test_phone=%@",@"13771961207"];
    NSDictionary *params = @{@"order_id":self.self.returnsDetail.order_id,@"question_type":selQuestion.ID,@"message":messageText.text.length?messageText.text:@"",@"invoice":_fapiao?@"1":@"0",@"username":usernameField.text.length>0?usernameField.text:@"",@"userphone":userphoneField.text.length>0?userphoneField.text:@"",@"pic":self.imgsUrlArray.description};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            MLTuiHuoChengGongViewController *vc = [[MLTuiHuoChengGongViewController alloc]init];
            vc.order_id = self.order_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (NSMutableArray *)imgsUrlArray{
    if (!_imgsUrlArray) {
        _imgsUrlArray = [NSMutableArray array];
    }
    return _imgsUrlArray;
}


- (void)getOrderDetail{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=order_detail&test_phone=13771961207&order_id=%@",@"http://bbctest.matrojp.com",self.order_id];
    NSDictionary *params = @{@"order_id":self.order_id?:@""};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSDictionary *order_detail = data[@"order_detail"];
            self.returnsDetail = [MLReturnsDetailModel mj_objectWithKeyValues:order_detail];
            NSMutableArray *tmp = [NSMutableArray array];
            for (int i = 0; i<self.returnsDetail.question_type.count; i++) {
                MLReturnsQuestiontype *q = self.returnsDetail.question_type[i];
                [tmp addObject:q.content];
            }
            tagsArray = [tmp copy];
            
            [self.tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}



- (BOOL)checkFormat{
    if (!selQuestion) {
        [MBProgressHUD showMessag:@"请选择问题类型" toView:self.view];
        return NO;
    }
    else{
        if (messageText.text.length == 0) {
            [MBProgressHUD showMessag:@"请输入问题描述" toView:self.view];
            return NO;
        }else{
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:3];
            MLXuanZeTuPianTableViewCell *cell  =[self.tableView cellForRowAtIndexPath:index];
            if (cell.imgsArray.count == 1) {//请上传问题图片
                [MBProgressHUD showMessag:@"请上传图片" toView:self.view];
                return NO;
            }
            else{
                if (usernameField.text.length == 0) {
                    [MBProgressHUD showMessag:@"请输入联系人" toView:self.view];
                    return NO;
                }
                else{
                    if (userphoneField.text.length == 0) {
                        [MBProgressHUD showMessag:@"请输入联系电话" toView:self.view];
                        return NO;
                    }
                    else{
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}





@end

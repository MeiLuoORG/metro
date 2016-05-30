//
//  MLHYHTableViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLHYHTableViewController.h"
#import "MLOrderComViewController.h"
#import "MLServiceMainController.h"
#import "MLBindPhoneController.h"
#import "MLGoodsComViewController.h"
#import "MLShareGoodsViewController.h"
#import "MLGoodsSharePhotoViewController.h"
#import "MLChangePhotoViewController.h"
#import "MLSaleServiceViewController.h"
#import "MLReturnRequestViewController.h"
#import "MLFootMarkViewController.h"
#import "MLWishlistViewController.h"
#import "MLYHQViewController.h"
@interface MLHYHTableViewController ()

@end

@implementation MLHYHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 11;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"订单评价";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"产品评价";
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"售后服务";
    }
    else if(indexPath.row ==3){
        cell.textLabel.text = @"手机绑定";
    }
    else if(indexPath.row == 4){
        cell.textLabel.text = @"分享";
    }
    else if(indexPath.row == 5){
        cell.textLabel.text = @"分享详情";
    }
    else if(indexPath.row == 6){
        cell.textLabel.text = @"上传头像";
    }
    else if(indexPath.row == 7){
        cell.textLabel.text = @"退货详情";
    }
    else if(indexPath.row == 8){
        cell.textLabel.text = @"退货申请";
    }
    else if (indexPath.row == 9){
        cell.textLabel.text = @"足迹列表";
    }
    else {
        cell.textLabel.text = @"商品收藏";
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        MLOrderComViewController *vc = [[MLOrderComViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==1){
        MLGoodsComViewController *vc = [[MLGoodsComViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==2){
        MLServiceMainController *vc = [[MLServiceMainController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if(indexPath.row == 3){
        MLBindPhoneController *vc = [[MLBindPhoneController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 4){
        MLShareGoodsViewController *vc = [[MLShareGoodsViewController alloc]init];
        
        vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        [self presentViewController:vc  animated:YES completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             
         }];

    }else if (indexPath.row == 5){
        MLGoodsSharePhotoViewController *vc = [[MLGoodsSharePhotoViewController alloc]init];
        
        vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        [self presentViewController:vc  animated:YES completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             
         }];
    }
    else if(indexPath.row == 6){
        MLChangePhotoViewController *vc = [[MLChangePhotoViewController alloc]init];
        
        vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        [self presentViewController:vc  animated:YES completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             
         }];
    }
    else if(indexPath.row == 7){
        MLSaleServiceViewController *vc = [[MLSaleServiceViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 8){
        MLReturnRequestViewController *vc = [[MLReturnRequestViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 9){
        MLFootMarkViewController *vc = [[MLFootMarkViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        MLWishlistViewController *vc = [[MLWishlistViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}


@end

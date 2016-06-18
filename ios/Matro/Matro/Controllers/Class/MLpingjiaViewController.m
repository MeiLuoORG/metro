//
//  MLpingjiaViewController.m
//  Matro
//
//  Created by Matro on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLpingjiaViewController.h"
#import "MLCommentTableViewCell.h"
#import "MJRefresh.h"

@interface MLpingjiaViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MLpingjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户评价";
    self.imgCollectionView.hidden = YES;
    self.commentTableview.backgroundColor = RGBA(245, 245, 245, 1);
    self.commentTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.commentTableview registerNib:[UINib nibWithNibName:@"MLCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MLCommentTableViewCell"];
    self.commentTableview.delegate = self;
    self.commentTableview.dataSource = self;
    
    self.commentTableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.commentTableview.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 3;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    cell = [self.commentTableview dequeueReusableCellWithIdentifier:@"MLCommentTableViewCell" forIndexPath:indexPath];
        return cell;
 
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 218;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actQuanbu:(id)sender {
}
- (IBAction)actHaoping:(id)sender {
}
- (IBAction)actZhongping:(id)sender {
}
- (IBAction)actChaping:(id)sender {
}
- (IBAction)actShaitu:(id)sender {
}
- (IBAction)addshopCar:(id)sender {
}

- (IBAction)myshopCar:(id)sender {
}
@end

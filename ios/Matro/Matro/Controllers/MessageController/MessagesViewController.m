//
//  MessagesViewController.m
//  Matro
//
//  Created by lang on 16/5/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MessagesViewController.h"

@interface MessagesViewController ()

@end

#define MESSAGECELL_IDENTIFIER @"messagesCellID"

@implementation MessagesViewController{

    JSBadgeView *badgeView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    
    //创建列表视图
    [self loadTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadTableView{

    //创建列表视图
    [self.tableViews registerNib:[UINib nibWithNibName:@"MessagesTableViewCell" bundle:nil] forCellReuseIdentifier:MESSAGECELL_IDENTIFIER];
    self.tableViews.delegate = self;
    self.tableViews.dataSource = self;
    self.tableViews.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableViews.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
        //badgeView.hidden = NO;
        NSLog(@"消息执行了头部刷新");
    }];
}
#pragma mark TableViewDelegate代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (MessagesTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //static NSString * cellID = MESSAGECELL_IDENTIFIER;
    MessagesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MESSAGECELL_IDENTIFIER];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MessagesTableViewCell" owner:nil options:nil][0];
        
        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

#pragma end mark TableView代理结束



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

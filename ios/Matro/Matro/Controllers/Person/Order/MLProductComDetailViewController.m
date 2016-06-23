//
//  MLProductComDetailViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/23.
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


@interface MLProductComDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MLProductCommentDetailModel *commentDetail;


@end

@implementation MLProductComDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLProductComDetailHeadCell" bundle:nil] forCellReuseIdentifier:kProductComDetailHeadCell];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
}

- (void)getComment{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=comment&method=detail&id=%@",@"http://bbctest.matrojp.com",self.comment_id];
    
    [[HFSServiceClient sharedJSONClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            self.commentDetail = [MLProductCommentDetailModel mj_objectWithKeyValues:data];
            [self.tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentDetail.product.photos.count + 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MLProductComDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductComDetailHeadCell forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 1){
        
    }
    return nil;

}

@end

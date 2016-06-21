//
//  MLSaleServiceViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSaleServiceViewController.h"
#import "MLAfterSaleHeadCell.h"
#import "MLSaleServiceProductCell.h"
#import "MLSaleServiceImageCell.h"
#import "Masonry.h"
#import "MLServiceTracksTableViewCell.h"

@interface MLSaleServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;



@end


@implementation MLSaleServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后服务";
    // Do any additional setup after loading the view.
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleHeadCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLSaleServiceProductCell" bundle:nil] forCellReuseIdentifier:kMLSaleServiceProductCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLSaleServiceImageCell" bundle:nil] forCellReuseIdentifier:kMLSaleServiceImageCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLServiceTracksTableViewCell" bundle:nil] forCellReuseIdentifier:kMLServiceTracksTableViewCell];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.view);
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section== 1)
    {
        return 1;
    }
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//退款头部
            MLAfterSaleHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLAfterSaleHeadCell forIndexPath:indexPath];
            cell.arrow.hidden = YES;
//            cell.tuikuanBtn.hidden = NO;
            return cell;
        }
        MLSaleServiceProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLSaleServiceProductCell forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 1){
        MLSaleServiceImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLSaleServiceImageCell forIndexPath:indexPath];
        cell.imgUrlArray = @[@"http://dealer0.autoimg.cn/dl/10982/newsimg/130364690780019046.jpg",@"http://dealer0.autoimg.cn/dl/10982/newsimg/130364690780019046.jpg",@"http://dealer0.autoimg.cn/dl/10982/newsimg/130364690780019046.jpg",@"http://dealer0.autoimg.cn/dl/10982/newsimg/130364690780019046.jpg",@"http://dealer0.autoimg.cn/dl/10982/newsimg/130364690780019046.jpg",@"http://dealer0.autoimg.cn/dl/10982/newsimg/130364690780019046.jpg"];
        cell.serviceImageMoreBlock = ^(){ //箭头按钮点击事件
            NSLog(@"更多");
        };
        cell.serviceImageClickBlock = ^(NSInteger index){ //图片按钮点击事件
            NSLog(@"点击第%li张图",(long)index);
        };
        
        return cell;
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @"售后信息跟踪：";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        MLServiceTracksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLServiceTracksTableViewCell forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.circleImage.image = [UIImage imageNamed:@"spot_tishi_01"];
        }
        else{
            cell.circleImage.image = [UIImage imageNamed:@"spot_tishi_02"];
            cell.circleWidth.constant = 10;
            cell.circleHeight.constant = 10;
            cell.circleLeft.constant = 36;
        }
        
        if (indexPath.row > 1) {
            cell.lineView.hidden = YES;
        }
        return cell;
      
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return indexPath.row == 0? 120:190;
    }
    else if (indexPath.section ==1){
        return 130;
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 44;
        }
        return 110;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


@end

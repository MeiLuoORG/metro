//
//  MLPersonOrderListViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/6/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonOrderListViewController.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLOrderInfoFooterTableViewCell.h"
#import "HFSConstants.h"
#import "MLMoreTableViewCell.h"
#import "masonry.h"
#import "UIView+BlankPage.h"

typedef NS_ENUM(NSInteger,OrderType){
    OrderType_All,
    OrderType_Fukuan,
    OrderType_Shouhuo,
    OrderType_Pingjia,
};

@interface MLPersonOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)OrderType type;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;


@end

@implementation MLPersonOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.title isEqualToString:@"全部"]) {
        self.type = OrderType_All;
    }else if ([self.title isEqualToString:@"待付款"]){
        self.type = OrderType_Fukuan;
    }else if ([self.title isEqualToString:@"待收货"]){
        self.type = OrderType_Shouhuo;
    }else if([self.title isEqualToString:@"待评价"]){
        self.type = OrderType_Pingjia;
    }
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoFooterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoFooterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self getData];
}


- (void)getData{
    [self.tableView reloadData];
    [self.view configBlankPage:EaseBlankPageTypeDingdan hasData:(self.orderList.count>0)];
    self.view.blankPage.clickButtonBlock = ^(EaseBlankPageType type){
        NSLog(@"去逛逛吧");
    };
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = [self.orderList objectAtIndex:section];
    return list.count > 2 ? 5:list.count+2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = [self.orderList objectAtIndex:indexPath.section];
    
    if (list.count>2 && indexPath.row == 3){
        MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
        return cell;
    }
    if (list.count>2 && indexPath.row == 4) {
        MLOrderInfoFooterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoFooterTableViewCell forIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.row == 0) {
        MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row ==list.count+1){//最后一行
        MLOrderInfoFooterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderInfoFooterTableViewCell forIndexPath:indexPath];
        return cell;
    }
    else{
        MLOrderCenterTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list = [self.orderList objectAtIndex:indexPath.section];
    if (indexPath.row == 0 || indexPath.row == (list.count>2?4:list.count+1)|| (list.count>2 && indexPath.row==3)) {
        return 40;
    }
    return 134;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end

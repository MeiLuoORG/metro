//
//  MNNMemberViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNMemberViewController.h"
#import "MNNQRCodeViewController.h"
#import "MNNPurchaseHistoryViewController.h"
#import "MNNBindCardViewController.h"
#import "HFSConstants.h"

@interface MNNMemberViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    UIImageView *_membershipCard;//VIP标志图
    UILabel *_label;
    UIView *_backgroundView;
    UILabel *_preferentialRules;//优惠规则内容
    UIButton *btnTitle;
    UIButton *btnSelect;
    UIScrollView *scrollview;
    UIPageControl *pageControl;
}

@end

@implementation MNNMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的会员卡";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"绑定会员卡" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self createTableView];
    // Do any additional setup after loading the view.
    
}
- (void)buttonAction {
    self.hidesBottomBarWhenPushed = YES;
    MNNBindCardViewController *bindCradVC = [MNNBindCardViewController new];
    [self.navigationController pushViewController:bindCradVC animated:YES];
}
#pragma mark 获取用户信息
- (void)loadDate {
    
}
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-20) style:UITableViewStyleGrouped];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 230)];
    
    //    _membershipCard = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, MAIN_SCREEN_WIDTH-40, 150)];
    //    [_backgroundView addSubview:_membershipCard];
    
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(20, 20, MAIN_SCREEN_WIDTH-40, 150)];
    
    scrollview.backgroundColor=[UIColor blueColor];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.bounces = NO;
    
    for (int i=0; i<4; i++) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0+(MAIN_SCREEN_WIDTH-40)*(i), 0, MAIN_SCREEN_WIDTH-40, 150)];
        
        NSString *str=[NSString stringWithFormat:@"%d.JPG",i];
        
        imageView.image=[UIImage imageNamed:str];
        
        [scrollview addSubview:imageView];
    }
    
    scrollview.pagingEnabled=YES;
    scrollview.delegate=self;
    scrollview.contentSize=CGSizeMake((MAIN_SCREEN_WIDTH-40)*4, 150);
    
    
    
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(80, 140, MAIN_SCREEN_WIDTH-160, 30)];
    
    pageControl.numberOfPages=4;
    
    pageControl.currentPage=0;
    
    pageControl.pageIndicatorTintColor=[UIColor greenColor];
    
    pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    
    
    [_backgroundView addSubview:scrollview];
    [_backgroundView addSubview:pageControl];
    
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(scrollview.frame)+20, MAIN_SCREEN_WIDTH-160, 20)];
    btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(32, CGRectGetMaxY(scrollview.frame)+20, 60, 20)];
    [btnTitle setTitle:@"设为默认" forState:UIControlStateNormal];
    [btnTitle.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(scrollview.frame)+24, 12, 12)];
    btnSelect.selected  = NO;
    [btnSelect setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(actSelect) forControlEvents:UIControlEventTouchUpInside];
    
    _label.text = @"使用时向服务员出示二维码";
    _label.font = [UIFont systemFontOfSize:12];
    _label.textAlignment = NSTextAlignmentCenter;
    
    
    /*
     if (_membershipCard.image == nil) {
     _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame)+20, MAIN_SCREEN_WIDTH, 20)];
     _label.text = @"您还没有会员卡，绑定即可享受线上优惠";
     _label.font = [UIFont systemFontOfSize:12];
     _label.textAlignment = NSTextAlignmentCenter;
     _membershipCard.image = [UIImage imageNamed:@"huiyuanka_weijihuo"];
     
     }
     else {
     _label = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(_membershipCard.frame)+20, MAIN_SCREEN_WIDTH-160, 20)];
     btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(32, CGRectGetMaxY(_membershipCard.frame)+20, 60, 20)];
     [btnTitle setTitle:@"设为默认" forState:UIControlStateNormal];
     [btnTitle.titleLabel setFont:[UIFont systemFontOfSize:12]];
     [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
     btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(_membershipCard.frame)+24, 12, 12)];
     btnSelect.selected  = NO;
     [btnSelect setImage:[UIImage imageNamed:@"r01"] forState:UIControlStateNormal];
     [btnSelect addTarget:self action:@selector(actSelect) forControlEvents:UIControlEventTouchUpInside];
     
     _label.text = @"使用时向服务员出示二维码";
     _label.font = [UIFont systemFontOfSize:12];
     _label.textAlignment = NSTextAlignmentCenter;
     _membershipCard.image = [UIImage imageNamed:@"huiyuanka_jinka"];
     }
     */
    
    [_backgroundView addSubview:_label];
    [_backgroundView addSubview:btnSelect];
    [_backgroundView addSubview:btnTitle];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 200)];
    _preferentialRules = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MAIN_SCREEN_WIDTH-20, 100)];
    _preferentialRules.text = @"此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则，此处显示优惠规则!!!!!!!";
    _preferentialRules.font = [UIFont systemFontOfSize:12];
    _preferentialRules.alpha = 0.5;
    _preferentialRules.numberOfLines = 0;
    CGSize size = [_preferentialRules.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(_preferentialRules.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    view.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, size.height+60);
    _preferentialRules.frame = CGRectMake(10, 5, MAIN_SCREEN_WIDTH-20, size.height);
    [view addSubview:_preferentialRules];
    _tableView.tableHeaderView = _backgroundView;
    _tableView.tableFooterView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x/(MAIN_SCREEN_WIDTH-40);
}

-(void)actSelect{
    
    if (btnSelect.selected) {
        btnSelect.selected = NO;
        [btnSelect setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else{
        btnSelect.selected = YES;
        [btnSelect setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    }
    
}
#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *string = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"会员卡";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-50, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@""];//个人二维码图标
        imageView.backgroundColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:imageView];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"可用积分";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-100, 10,70 , 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"100020";
        label.font = [UIFont systemFontOfSize:12];
        label.alpha = 0.5;
        [cell addSubview:label];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"当前余额";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-100, 10,70 , 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"￥50000";
        label.font = [UIFont systemFontOfSize:12];
        label.alpha = 0.5;
        [cell.contentView addSubview:label];
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"使用记录";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-120, 10,90 , 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"查看消费记录";
        label.font = [UIFont systemFontOfSize:12];
        label.alpha = 0.5;
        [cell.contentView addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"优惠规则";
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        MNNQRCodeViewController *qrCodeVC = [MNNQRCodeViewController new];
        [self.navigationController pushViewController:qrCodeVC animated:YES];
    }
    if (indexPath.row == 3) {
        self.hidesBottomBarWhenPushed = YES;
        MNNPurchaseHistoryViewController *purchasHistoryVC = [MNNPurchaseHistoryViewController new];
        [self.navigationController pushViewController:purchasHistoryVC animated:YES];
    }
}
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

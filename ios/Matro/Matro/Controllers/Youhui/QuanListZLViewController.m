//
//  QuanListZLViewController.m
//  Matro
//
//  Created by lang on 16/6/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "QuanListZLViewController.h"

@interface QuanListZLViewController ()

@end

@implementation QuanListZLViewController{
    
    MBProgressHUD * _hud;
    UIImageView * _wuImageView;
    UILabel * _titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    // Do any additional setup after loading the view from its nib.
    [self createTopView];
    [self loadTableView];
}
- (void)createTopView{
    __weak typeof(self) weakself = self;
    NavTopCommonImage *top = [[NavTopCommonImage alloc]initWithTitle:@"优惠券"];
    [top loadLeftBackButtonwith:0];
    [top backButtonAction:^(BOOL succes) {
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:top];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightBtn setTitleColor:[HFSUtility hexStringToColor:Main_BackgroundColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shiyongShuoMing) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(SIZE_WIDTH-82, 35, 60, 22)];
    
    //[top addSubview:rightBtn];
    
    _wuImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"defoult"]];
    [_wuImageView setFrame:CGRectMake((SIZE_WIDTH-125.0f)/2.0f, 100, 125.0, 125.0)];
    [self.view addSubview:_wuImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SIZE_WIDTH-125.0f)/2.0f, 235.0f, 125.0, 25.0)];
    _titleLabel.text = @"您还没有现金优惠券";
    _titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    /*
    [_wuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-40);
        make.size.width.with.height.mas_equalTo(125.0f);
    }];
    */
}
- (void)shiyongShuoMing{

    NSLog(@"点击了使用说明");
    
}

- (void)loadTableView{
    self.quanListARR = [[NSMutableArray alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(22, 64, SIZE_WIDTH-44, SIZE_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [HFSUtility hexStringToColor:Main_beijingGray_BackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // [self.tableView.header endRefreshing];
        [self.quanListARR removeAllObjects];
        [self loadData];
    }];
 
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    /*
    [super viewWillAppear:animated];
    if (self.quanListARR.count > 0) {
        [self.tableView reloadData];
        _wuImageView.hidden = YES;
        _titleLabel.hidden = YES;
    }
    else{
        _wuImageView.hidden = NO;
        _titleLabel.hidden = NO;
    }
*/
}

- (void)loadData{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [MLHttpManager get:YOUHUIQUANLIST_YiLingQu_URLString params:nil m:@"member" s:@"admin_coupons" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"请求用户已领取的优惠券：%@",responseObject);
        NSDictionary * result = (NSDictionary *)responseObject;
        NSDictionary * dataDic = result[@"data"];
        NSArray * allCouponsARR = dataDic[@"b2c_allcoupons"];
        
        if (allCouponsARR.count > 0) {
            
            for (NSDictionary * dic in allCouponsARR) {
                YouHuiQuanModel * model = [[YouHuiQuanModel alloc]init];
                model.balance = [dic[@"Balance"] intValue];
                model.mingChengStr = dic[@"CouponTypeName"];
                model.endTime = dic[@"ValidDate"];
                model.quanID = dic[@"CouponType"];
                [self.quanListARR addObject:model];
            }
           
            
            _wuImageView.hidden = YES;
            _titleLabel.hidden = YES;
            self.tableView.hidden = NO;
        }
        else{
            
            
            _wuImageView.hidden = NO;
            _titleLabel.hidden = NO;
            self.tableView.hidden = YES;
            /*
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"没有可使用的优惠券";
            [_hud hide:YES afterDelay:1];
        */
        }
         [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        [self.tableView.header endRefreshing];
    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.quanListARR.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.0f;
}
- (LingQuQuanCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LingQuQuanCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = (LingQuQuanCell *)[[NSBundle mainBundle] loadNibNamed:@"LingQuQuanCell" owner:nil options:nil][0];
        
    }
    YouHuiQuanModel * model = [self.quanListARR objectAtIndex:indexPath.row];
    
    cell.jinELabel.text = [NSString stringWithFormat:@"￥%d",model.balance];
    NSString * youXiaoLabel = [NSString stringWithFormat:@"有效期:%@",model.endTime];
    cell.youXiaoQiLabel.text = youXiaoLabel;
    cell.mingChengLabel.text = model.mingChengStr;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    /*
    NSString * rowKey = [NSString stringWithFormat:@"%ld",indexPath.row];
    for (NSString * rowStr in _yilingQuCellDIC.allKeys) {
        if ([rowKey isEqualToString:rowStr]) {
            cell.yiLingQuImageView.hidden = NO;
        }
        
    }
    if ([model.flag isEqualToString:@"0"]) {
        cell.yiLingQuImageView.hidden = NO;
    }
    */
    /*
     NSString * rowKey = [NSString stringWithFormat:@"%ld",indexPath.row];
     [self.selectedBtnDic setObject:cell.selectButton forKey:rowKey];
     
     NSLog(@"执行了cellForRowAtIndexPath：allKeys:%ld",self.selectedBtnDic.allKeys.count);
     if ([rowKey isEqualToString:self.currentSelectIndex]) {
     cell.selectButton.selected  = YES;
     }
     */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;


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

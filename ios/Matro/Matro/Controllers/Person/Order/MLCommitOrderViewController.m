//
//  MLCommitOrderViewController.m
//  Matro
//
//  Created by Matro on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommitOrderViewController.h"
#import "MLInvoiceViewController.h"
#import "MLAddressListViewController.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "MLOrderListViewCell.h"
#import "MLShopCartMoreCell.h"
#import "MLOrderHeader.h"
@interface MLCommitOrderViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (weak, nonatomic) IBOutlet UIImageView *headimage;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *userName;//用户名称
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;//用户电话
@property (weak, nonatomic) IBOutlet UILabel *address;//配送地址
@property (weak, nonatomic) IBOutlet UIButton *editBtn;//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *baocunBtn;//保存按钮
@property (weak, nonatomic) IBOutlet UITextField *idTextFiled;//输入身份证号码
@property (weak, nonatomic) IBOutlet UILabel *idLab;//身份证号码
@property (strong, nonatomic) IBOutlet UITableView *ProTableview;//订单商品
@property (weak, nonatomic) IBOutlet UILabel *suieLab;//税额
@property (weak, nonatomic) IBOutlet UILabel *peisongLab;//配送方式
@property (weak, nonatomic) IBOutlet UILabel *quanqiugouFapiaoLab;//全球购发票问题
@property (weak, nonatomic) IBOutlet UILabel *putongFapiaoLab;//普通发票
@property (weak, nonatomic) IBOutlet UILabel *fapiaoInfoLab;//发票信息
@property (weak, nonatomic) IBOutlet UILabel *yhqnumLab;//优惠券数量
@property (weak, nonatomic) IBOutlet UILabel *yhqstatusLab;//有优惠券时的状态（未使用）
@property (weak, nonatomic) IBOutlet UILabel *keyongLab;//优惠券可用金额
@property (weak, nonatomic) IBOutlet UITextField *shiyongTextfiled;//使用优惠金额
@property (weak, nonatomic) IBOutlet UIButton *shiyongBtn;//使用优惠券按钮
@property (weak, nonatomic) IBOutlet UILabel *shangpinNum;//结算商品数量
@property (weak, nonatomic) IBOutlet UILabel *zongPriceLab;//结算总价格
@property (weak, nonatomic) IBOutlet UILabel *youhuiPriceLab;//优惠价格
@property (weak, nonatomic) IBOutlet UILabel *shuifeiLab;//税费
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLab;//运费
@property (weak, nonatomic) IBOutlet UILabel *priceLab;//实际付款

@property (weak, nonatomic) IBOutlet UIView *peisongfangshiView;//配送方式
@property (weak, nonatomic) IBOutlet UILabel *peisong1;
@property (weak, nonatomic) IBOutlet UILabel *peisongStatus1;


@property (nonatomic,strong)MLInvoiceViewController *invoiceVc;

@property (nonatomic,strong)MLAddressListViewController *addressVc;

@end

@implementation MLCommitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单信息";
    [self.myscrollview  setContentSize:CGSizeMake(MAIN_SCREEN_WIDTH, 1100)];
    self.baocunBtn.layer.borderWidth = 1.f;
    self.baocunBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.baocunBtn.layer.cornerRadius = 4.f;
    self.baocunBtn.layer.masksToBounds = YES;
    
    self.editBtn.layer.borderWidth = 1.f;
    self.editBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.editBtn.layer.cornerRadius = 4.f;
    self.editBtn.layer.masksToBounds = YES;
    
    self.shiyongBtn.layer.borderWidth = 1.f;
    self.shiyongBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
    self.shiyongBtn.layer.cornerRadius = 4.f;
    self.shiyongBtn.layer.masksToBounds = YES;
    _ProTableview = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderListViewCell" bundle:nil] forCellReuseIdentifier:KMLOrderListViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLShopCartMoreCell" bundle:nil ] forCellReuseIdentifier:@"MoreCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderHeader" bundle:nil] forCellReuseIdentifier:@"MLOrderHeader"];
        tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:tableView];
        tableView;
    });
    
    
    [self loadData];
}


//全部订单
-(void)loadData{
    //http://bbctest.matrojp.com/api.php?m=product&s=confirm_order
    
    NSLog(@"paramsdic===%@",_paramsDic);
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=confirm_order",@"http://bbctest.matrojp.com"];
    [MLHttpManager post:urlStr params:_paramsDic m:@"product" s:@"confirm_order" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"result===%@",result);
        
        if ([result[@"code"] isEqual:@0]) {
            
           [MBProgressHUD showSuccess:@"请求成功" toView:self.view];
            
        }else{
            
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
            
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLOrderListViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:KMLOrderListViewCell];
    
    return cell;
    
}

//点击head进入地址
- (IBAction)actDizhi:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.addressVc animated:YES];
}

//点击配送
- (IBAction)actPeisong:(id)sender {
}

//点击发票选择
- (IBAction)actFapiao:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.invoiceVc animated:YES];
    
}

//使用优惠
- (IBAction)actShiyong:(id)sender {
    
}


- (MLAddressListViewController *)addressVc{
    if (!_addressVc) {
        _addressVc = [[MLAddressListViewController alloc]init];
        
        
    }
    return _addressVc;
}

- (MLInvoiceViewController *)invoiceVc{
    if (!_invoiceVc) {
        _invoiceVc = [[MLInvoiceViewController alloc]init];
        _invoiceVc.delegate = self;
        
    }
    return _invoiceVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

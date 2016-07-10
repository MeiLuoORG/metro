//
//  MLCommitOrderViewController.m
//  Matro
//
//  Created by Matro on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCommitOrderViewController.h"
#import "MLInvoiceViewController.h"
#import "MLAddressSelectViewController.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "MLShopCartMoreCell.h"
#import "MLAddressListModel.h"
#import "MLOrderHeadCollectionReusableView.h"
#import "MLOrderFootCollectionReusableView.h"
#import "MLOrderListCollectionViewCell.h"
#import "MLPeisongTableViewCell.h"
#import "MLCommitOrderListModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface MLCommitOrderViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,InvoiceDelegate>
{

     NSDictionary *makeinvoice;//保存是否开发票信息
     long shipcount;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (weak, nonatomic) IBOutlet UIImageView *headimage;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *userName;//用户名称
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;//用户电话
@property (weak, nonatomic) IBOutlet UILabel *address;//配送地址
@property (weak, nonatomic) IBOutlet UIButton *editBtn;//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *baocunBtn;//保存按钮
@property (weak, nonatomic) IBOutlet UITextField *idTextFiled;//输入身份证号码
@property (weak, nonatomic) IBOutlet UILabel *idLab;//身份证号码
@property (strong, nonatomic) IBOutlet UICollectionView *proCollection;//订单商品
@property (weak, nonatomic) IBOutlet UILabel *suieLab;//税额
@property (strong, nonatomic) IBOutlet UITableView *peisongTableview;//配送方式信息
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peisongH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proCollectionH;


@property (nonatomic,strong)MLInvoiceViewController *invoiceVc;
@property (nonatomic,strong)MLAddressSelectViewController *addressVc;
@property(nonatomic,strong)MLCommitOrderListModel *commitOrder;

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
    self.peisongH.constant = 0;
    
   
    self.proCollection.dataSource =self;
    self.proCollection.delegate = self;
    self.proCollection.backgroundColor = RGBA(245, 245, 245, 1);
    [self.proCollection registerNib:[UINib nibWithNibName:@"MLOrderListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:KMLOrderListCollectionViewCell];
    [self.proCollection registerNib:[UINib nibWithNibName:@"MLOrderHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KMLOrderHeadCollectionReusableView];
    [self.proCollection registerNib:[UINib nibWithNibName:@"MLOrderFootCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:KMLOrderFootCollectionReusableView];
    [self.proCollection registerNib:[UINib nibWithNibName:@"MLShopCartMoreCell" bundle:nil] forCellWithReuseIdentifier:@"MoreCell"];
    
    
    self.peisongTableview.backgroundColor = RGBA(245, 245, 245, 1);
    self.peisongTableview.dataSource = self;
    self.peisongTableview.delegate = self;
   // self.peisongTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.peisongTableview  registerNib:[UINib nibWithNibName:@"MLPeisongTableViewCell"  bundle:nil] forCellReuseIdentifier:@"MLPeisongTableViewCell"];
    
    makeinvoice = @{@"invoiceFlag":@"0"};//默认不开发票
    
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
            self.commitOrder = [MLCommitOrderListModel mj_objectWithKeyValues:result[@"data"]];
            NSLog(@"commitOrder===%@",self.commitOrder);
            self.userName.text = self.commitOrder.consignee[@"name"];
            self.phoneNum.text = self.commitOrder.consignee[@"mobile"];
            NSString *addressStr = self.commitOrder.consignee[@"address"];
            NSString *areaStr = self.commitOrder.consignee[@"area"];
            self.address.text = [NSString stringWithFormat:@"%@%@",areaStr,addressStr];
            
            NSLog(@"count===%ld",self.commitOrder.cart.count);
            
            [self.proCollection reloadData];
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


#pragma mark 订单
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.commitOrder.cart.count;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSLog(@"cart===%@====%ld",self.commitOrder.cart,section);
    
    MLOrderCartModel *cart = [self.commitOrder.cart objectAtIndex:section];
    
    if (cart.isMore && !cart.isOpen) {
            return 3;
        }
    
    return 1;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MLOrderCartModel *cart = [self.commitOrder.cart objectAtIndex:indexPath.section];
    if (cart.isMore && !cart.isOpen && indexPath.row == 2) {
        MLShopCartMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreCell" forIndexPath:indexPath];
        [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",cart.prolist.count-2] forState:UIControlStateNormal];
        cell.moreActionBlock = ^(){
            cart.isOpen = YES;
            [self.proCollection reloadData];
        };
            
        return cell;
            
    }
        MLOrderListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMLOrderListCollectionViewCell forIndexPath:indexPath];
    
        MLOrderProlistModel *model = [cart.prolist objectAtIndex:indexPath.row];
       
    if (![model.pic isKindOfClass:[NSNull class]]) {
        [cell.orderImg sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"imageloading"]];
    }
    cell.orderTitle.text = model.pname;
    cell.orderNum.text = [NSString stringWithFormat:@"x%ld",model.num];

    self.proCollectionH.constant = 45*self.commitOrder.cart.count + 125*cart.prolist.count ;
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(MAIN_SCREEN_WIDTH, 120);
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10 , 0, 10);
}

//头部显示的内容

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        MLOrderHeadCollectionReusableView *orderHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KMLOrderHeadCollectionReusableView forIndexPath:indexPath];
        MLOrderCartModel *cart = [self.commitOrder.cart objectAtIndex:indexPath.section];
        if (![cart.logo isKindOfClass:[NSNull class]]) {
            [orderHead.headImg sd_setImageWithURL:[NSURL URLWithString:cart.logo] placeholderImage:[UIImage imageNamed:@"imageloading"]];
        }
        orderHead.headTitle.text = cart.company;
        return orderHead;
    }
    
    
    return nil;
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
   
    CGSize size={MAIN_SCREEN_WIDTH,45};
    return size;
}

#pragma mark 配送方式
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MLOrderCartModel *cart = [self.commitOrder.cart objectAtIndex:section];
    NSLog(@"%ld",cart.shipping.count);
    shipcount = cart.shipping.count;
    //return cart.shipping.count;
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLPeisongTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MLPeisongTableViewCell"];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: @"MLPeisongTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    MLOrderCartModel *cart = [self.commitOrder.cart objectAtIndex:indexPath.section];
    NSDictionary *tempdic = [cart.shipping objectAtIndex:indexPath.section];
//    cell.peisongTitle.text = tempdic[@"company"];
//    cell.peisongStatus.text = tempdic[@"price"];
    cell.peisongTitle.text = @"顺丰";
    cell.peisongStatus.text = @"$12.33";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MLOrderCartModel *cart = [self.commitOrder.cart objectAtIndex:indexPath.section];
    NSDictionary *tempdic = [cart.shipping objectAtIndex:indexPath.section];
     NSLog(@"111111%@",tempdic);
    self.peisongLab.text = [NSString stringWithFormat:@"%@  %@",tempdic[@"price"] ,tempdic[@"mianfei"]];
    self.peisongH.constant = 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    MLOrderCartModel *cart = [self.commitOrder.cart objectAtIndex:indexPath.section];
    
    return 44*cart.shipping.count;
}

//点击head进入地址
- (IBAction)actDizhi:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.addressVc animated:YES];
}

//点击配送
- (IBAction)actPeisong:(id)sender {
    self.peisongfangshiView.hidden = NO;
    shipcount = 1;
    self.peisongH.constant = shipcount*44;
}

//点击发票选择
- (IBAction)actFapiao:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.invoiceVc animated:YES];
    
}

//使用优惠
- (IBAction)actShiyong:(id)sender {
    
}



- (MLAddressSelectViewController *)addressVc{
    
    if (!_addressVc) {
        _addressVc = [[MLAddressSelectViewController alloc]init];
        __weak typeof(self) weakself = self;
        _addressVc.addressSelectBlock = ^(MLAddressListModel *selAddress){
            weakself.userName.text = selAddress.name;
            weakself.phoneNum.text = selAddress.mobile;
            weakself.address.text = [NSString stringWithFormat:@"%@%@",selAddress.area,selAddress.address];
        };
        
    }
    return _addressVc;
}

#pragma mark- InvoiceDelegate 发票回调

- (void)InvoiceDic:(NSDictionary *)dic{
    
    NSLog(@"dic==%@",dic);
    if ([dic[@"invoice"] isEqualToString:@"YES"]) {
        _putongFapiaoLab.text = @"普通发票";
        if ([dic[@"gerenOrgongsi"] isEqualToString:@"YES"]) {
            _fapiaoInfoLab.text = @"明细-个人";
            
        }else{
            
            _fapiaoInfoLab.text = [NSString stringWithFormat:@"明细-%@",dic[@"titleText"]];
        }
        
    }else{
        _putongFapiaoLab.text = @"不开发票";
        _fapiaoInfoLab.hidden = YES;
    }
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

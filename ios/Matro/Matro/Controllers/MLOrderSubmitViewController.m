//
//  MLOrderSubmitViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/7/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderSubmitViewController.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLMoreTableViewCell.h"
#import "Masonry.h"
#import "MLOrderSubTextTableViewCell.h"
#import "MLOrderSubArrowTableViewCell.h"
#import "MLOrderSubFaPiaoTableViewCell.h"
#import "MLInvoiceViewController.h"
#import "MLOrderKuaidiTableViewCell.h"
#import "MLOrderSubHeadView.h"
#import "MLAddressSelectViewController.h"
#import "MLAddressListModel.h"
#import "MLOrderYouHuiTableViewCell.h"
#import "NSString+GONMarkup.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"


@interface MLOrderSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)MLOrderSubHeadView *headView;

@property (nonatomic,strong)UILabel *sumLabel;

@end

@implementation MLOrderSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单信息";
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderSubArrowTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderSubArrowTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderSubTextTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderSubTextTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderSubFaPiaoTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderSubFaPiaoTableViewCell];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 160)];
        MLOrderSubHeadView *headView = [MLOrderSubHeadView headView];
        [headView.addressControl addTarget:self action:@selector(showAddress:) forControlEvents:UIControlEventTouchUpInside];
        self.headView = headView;
        [head addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(head).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        tableView.tableHeaderView = head;
        [self.view addSubview:tableView];
        tableView;
    });

    
    _footView = ({
        UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footView];
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.sumLabel = priceLabel;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [btn setBackgroundColor:RGBA(255, 78, 38, 1)];
        [btn setTitle:@"去支付" forState:UIControlStateNormal];
        [btn setBackgroundColor:RGBA(255, 78, 38, 1)];
        [footView addSubview:priceLabel];
        [footView addSubview:btn];
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectZero];
        [footView addSubview:topLine];
        topLine.backgroundColor = RGBA(245, 245, 245, 1);
        [btn addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footView);
            make.left.mas_equalTo(footView).offset(16);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(footView);
            make.width.mas_equalTo(120);
        }];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.right.top.equalTo(footView);
        }];
        footView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self refreshHeadView];
}

- (void)showAddress:(id)sender{  //重新向服务器拉数据
    MLAddressSelectViewController *vc = [[MLAddressSelectViewController alloc]init];
    vc.addressSelectBlock = ^(MLAddressListModel *address){ //返回后设置当前地址为默认地址 然后重新拉取数据
        
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshHeadView{
    self.headView.nameLabel.text = self.order_info.consignee.name;
    self.headView.phoneLabel.text = self.order_info.consignee.mobile;
    self.headView.addressLabel.text = [NSString stringWithFormat:@"%@%@",self.order_info.consignee.area,self.order_info.consignee.address];
    self.headView.shenfenzhengField.text = self.order_info.identity_card;
    NSString *attrPrice = [NSString stringWithFormat:@"<font size=\"16\"><color value=\"000000\">实付金额：</><color value=\"#FF4E25\">￥%.2f</></>",self.order_info.sumprice];
    self.sumLabel.attributedText = [attrPrice createAttributedString];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3*self.order_info.cart.count) { //最后一行
        return 4;
    }else{
        switch (section%3) {
            case 0:   //商品展示
            {
                NSInteger index = section/2;
                
                MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:index];
                
                if (cart.isMore && !cart.isOpen){
                    return 4;
                }
                return cart.prolist.count+1;
            }
                break;
            case 1: //税费 配送信息
            {
                return 5;
            }
                break;
            case 2: //发票信息
            {
                return 2;
            }
                break;
                
            default:
                break;
        }
        return 0;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3*self.order_info.cart.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 3*self.order_info.cart.count) {
        MLOrderSubTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubTextTableViewCell forIndexPath:indexPath];
        if (indexPath.row == 0) {//商品金额
            cell.titleLabel.text = @"商品金额";
            cell.subLabel.text = @"(共10件商品)";
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.order_info.sumprice];
            cell.subLabel.hidden = NO;
        }else if (indexPath.row == 1){//优惠
            cell.titleLabel.text = @"优惠";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text = @"-￥20";
        }else if (indexPath.row == 2){//税费
            cell.titleLabel.text = @"税费";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",self.order_info.sumtax];
        }else{//运费
            cell.titleLabel.text = @"运费";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text = @"￥0.00";
        }
        cell.titleLabel.hidden = NO;
        cell.priceLabel.hidden = NO;
        return cell;
    }else{
         __block MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:indexPath.section/3];
        switch (indexPath.section%3) {
             
            case 0: //店铺商品信息
            {
                if (indexPath.row == 0) { //店铺头
                    MLOrderInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
                    cell.shopName.text = cart.company;
                    cell.statusLabel.hidden = YES;
                    return cell;
                }
                if (cart.isMore && !cart.isOpen && indexPath.row == 3) { // 有更多
                    MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
                    [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%lu件",cart.prolist.count - 2] forState:UIControlStateNormal];
                    cell.moreActionBlock = ^(){
                        cart.isOpen = YES;
                        [self.tableView reloadData];
                    };
                    return cell;
                }
                MLOrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
                cell.order_submit_product = [cart.prolist objectAtIndex:indexPath.row-1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:{ //发票信息
                if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {//税费
                    MLOrderSubTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubTextTableViewCell forIndexPath:indexPath];
                    if (indexPath.row == 0) {
                        cell.titleLabel.text = @"税费";
                        cell.subLabel.text = @"(含消费税和增值税)";
                        cell.subLabel.hidden = NO;
                        cell.priceLabel.text =[NSString stringWithFormat:@"￥%.2f",cart.sumtax];
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = NO;
                        cell.subLabel.hidden = NO;
                    }else if (indexPath.row == 3){
                        cell.titleLabel.text = @"给卖家留言：";
                        cell.subLabel.hidden = YES;
                        cell.priceLabel.hidden = YES;
                        cell.titleLabel.hidden = NO;
                    }else if (indexPath.row == 4){
                        NSString *attr = [NSString stringWithFormat:@"<font size =\"14\"><color value=\"#000000\">订单小计</><color value=\"#999999\">  (含运费和税费)</><color value=\"#FF4E25\">  ￥%.2f</></>",2.00];
                        cell.priceLabel.attributedText = [attr createAttributedString];
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = YES;
                        cell.subLabel.hidden = YES;
                    }
                    return cell;
                }
                else if (indexPath.row == 1){//配送方式
                    MLOrderKuaidiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    if (!cell) {
                        cell = [[MLOrderKuaidiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                       }
                        cell.titleLabel.text = @"配送方式";
                    if (!cart.canOpenKuaiDi) {
                        cell.subLabel.text = @"免邮";
                    }
                    else{
                        cell.subLabel.text = cart.kuaiDiFangshi.company;
                        
                    }
                    cell.dataSource = cart.shipping;
                    cell.orderKuaiDiSel = ^(NSInteger index){
                        cart.kuaiDiFangshi = [cart.shipping objectAtIndex:index];
                        cart.openKuaiDi = !cart.openKuaiDi;
                        [self.tableView reloadData];
                    };
                    return cell;
                }else{ //优惠券
                    MLOrderYouHuiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YouHuiCell"];
                    if (!cell) {
                        cell = [[MLOrderYouHuiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YouHuiCell"];
                    }
                    cell.titleLabel.text = @"优惠券";
                    cell.subLabel.text = [NSString stringWithFormat:@"%li张可用",cart.yhqdata.count];
                    if (cart.canOpenYouHui) { //有优惠券要使用的情况
                        if (cart.youhuiMoney > 0 ) {
                            cell.rightLabel.text = [NSString stringWithFormat:@"-￥%.1f",cart.youhuiMoney];
                            cell.rightLabel.textColor = RGBA(255, 78, 38, 1);
                        }
                        else{
                            cell.rightLabel.text = @"未使用";
                            cell.rightLabel.textColor = RGBA(153, 153, 153, 1);
                            
                        }
                        cell.rightLabel.hidden = NO;
                    }
                    else{//没有优惠券
                        cell.rightLabel.hidden = YES;
                    }
                    
                   
                    cell.useClick = ^(){
                        [self.tableView reloadData];
                    };
                    cell.dataSource = cart.yhqdata;
                    return cell;
                }
            }
  
                break;
            case 2:{ //发票信息
                if (indexPath.row == 0) {
                    MLOrderSubArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubArrowTableViewCell forIndexPath:indexPath];
                    cell.titleLabel.text = @"发票信息";
                    cell.subLabel.hidden = YES;
                    cell.rightLabel.hidden = YES;
                    cell.titleLabel.hidden = NO;
                    return cell;
                }else{
                    MLOrderSubFaPiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubFaPiaoTableViewCell forIndexPath:indexPath];
                    cell.shifouKai = cart.fapiao;
                    cell.company.text = [NSString stringWithFormat:@"%@-%@",cart.geren?@"个人":@"公司",cart.geren?@"明细":cart.mingxi];
                    return cell;
                    
                }
            }
            default:
                break;
        }
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3*self.order_info.cart.count) {
        return 44;
    }
    else{
        MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:indexPath.section/3];
        switch (indexPath.section%3) {
        case 0:
        {
            if (indexPath.row == 0) {
                return 40;
            }
            return 125;
        }
        break;
        case 1:
        {
            if (indexPath.row == 4) {
                return 60;
            }
            if (indexPath.row == 2 && cart.canOpenYouHui && cart.openYouHui) {
                return 88*cart.yhqdata.count+44;
            }
            if (indexPath.row == 1 && cart.canOpenKuaiDi && cart.openKuaiDi) {
                return (cart.shipping.count+1)* 44;
            }
            return 44;
        }
        break;
        case 2:
        {
            if (indexPath.row == 0) {
                return 44;
            }else{
                if (cart.fapiao) {
                    return 60;
                }
                else{
                    return 35;
                }
            }
        }
            break;
        default:
        break;
        }
        return 0;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3*self.order_info.cart.count) {
        return;
    }
    else{
         __block  MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:indexPath.section/3];
        switch (indexPath.section%3) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                if (indexPath.row == 1 && cart.canOpenKuaiDi) {
                    cart.openKuaiDi = !cart.openKuaiDi;
                    [self.tableView reloadData];
                }else if (indexPath.row == 2 && cart.canOpenYouHui){
                    cart.openYouHui = !cart.openYouHui;
                    [self.tableView reloadData];
                }
            }
                break;
            case 2:
            {
                if (indexPath.row == 0) { //选发票
                    MLInvoiceViewController *vc = [[MLInvoiceViewController alloc]init];
                    vc.invoiceBlock = ^(BOOL xuyao,BOOL geren,NSString *mingxi,NSString *ID){
                        cart.fapiao = xuyao;
                        cart.geren = geren;
                        cart.mingxi = mingxi;
                        cart.fapiao_ID = ID;
                        [self.tableView reloadData];
                    };
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            default:
                break;
        }
    }


}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.f;
}

- (void)gotoPay:(id)sender{
    NSLog(@"去支付");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (MLOrderCartModel *cart in self.order_info.cart) {
        [self confirmOrderParams:cart AndParams:params];
    }
    params[@"s_sumprice"] = [NSNumber numberWithFloat:self.order_info.sumprice];
    params[@"hidden_consignee_id"] = self.order_info.consignee.delivery_address_id;
    params[@"invoice_id"] = @"";
    params[@"yhquse"] = @"";
    
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=confirm_order_submit",MATROJP_BASE_URL];
    [MLHttpManager post:url params:params m:@"product" s:@"confirm_order_submit" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSString *order_id = data[@"order_id"];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


- (void )confirmOrderParams:(MLOrderCartModel *)model AndParams:(NSMutableDictionary *)params{
    NSString *cartKey = [NSString stringWithFormat:@"product_id[]"];
    NSString *msgKey = [NSString stringWithFormat:@"msg_%@",model.ID];
    NSString *logTypeKey = [NSString stringWithFormat:@"logistics_type_%@",model.ID];
    NSString *logPriceKey = [NSString stringWithFormat:@"logistics_price_%@",model.ID];
    NSString *logTaxKey = [NSString stringWithFormat:@"logistics_tax_%@",model.ID];
    NSString *disIDKey = [NSString stringWithFormat:@"discount_id_%@",model.ID];
    NSString *disPriceKey = [NSString stringWithFormat:@"discount_price_%@",model.ID];
    params[logTypeKey] = model.kuaiDiFangshi.company;
    params[logPriceKey] = [NSNumber numberWithFloat: model.kuaiDiFangshi.price];
    params[logTaxKey] = [NSNumber numberWithFloat:model.kuaiDiFangshi.sumtax];
    params[disPriceKey] = [NSNumber numberWithFloat:model.youhuiMoney];
    params[msgKey]=@"留言";
    params[disIDKey]=@"";
    params[cartKey] = model.ID;
}



//msg_39189=快递麻烦快一点哦，我要红色    留言
//
//logistics_type_39189=顺丰物流 物流方式
//
//logistics_price_39189=6 物流价格
//
//logistics_tax_39189=0 税费
//
//discount_id_39189=73 优惠券ID
//
//discount_price_39189=100 优惠券面额


@end

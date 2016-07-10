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
#import "MJExtension.h"
#import "MLPayViewController.h"
#import "MLOrderSubLiuYanTableViewCell.h"


@interface MLOrderSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)MLOrderSubHeadView *headView;
@property (nonatomic,strong)UILabel *sumLabel;

@end

static float allPrice = 0;

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
        [self confirmOrder];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshHeadView{
    if (self.order_info.identity_card.length>0) { //如果有身份证直接显示
        self.headView.shenfenzhengField.text = self.order_info.identity_card;
        [self.headView saveClick:nil];
    }
    self.headView.nameLabel.text = self.order_info.consignee.name;
    self.headView.phoneLabel.text = self.order_info.consignee.mobile;
    self.headView.addressLabel.text = [NSString stringWithFormat:@"%@%@",self.order_info.consignee.area,self.order_info.consignee.address];
    self.headView.shenfenzhengField.text = self.order_info.identity_card;
    CGFloat sumPrice = 0;
    for (MLOrderCartModel *model in self.order_info.cart) {
        sumPrice += model.dingdanXiaoji;
    }
    allPrice = sumPrice;
    NSString *attrPrice = [NSString stringWithFormat:@"<font size=\"16\"><color value=\"000000\">实付金额：</><color value=\"#FF4E25\">￥%.2f</></>",sumPrice];
    self.sumLabel.attributedText = [attrPrice createAttributedString];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2*self.order_info.cart.count+1) { //最后一行
        return 6;
    }else if (section == 2*self.order_info.cart.count){ //发票信息
        return 2;
    }
    else{
        switch (section%2) {
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
                
            default:
                break;
        }
        return 0;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2*self.order_info.cart.count+2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2*self.order_info.cart.count+1) { //最后一行
        MLOrderSubTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubTextTableViewCell forIndexPath:indexPath];
        if (indexPath.row == 0) {//商品金额
            cell.titleLabel.text = @"商品金额";
            NSInteger count = 0;
            for (MLOrderCartModel *model in self.order_info.cart) {
                count+= model.prolist.count;
            }
            cell.subLabel.text = [NSString stringWithFormat:@"(共%li件商品)",count];
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.order_info.sumprice];
            cell.subLabel.hidden = NO;
        }else if (indexPath.row == 1){//优惠
            cell.titleLabel.text = @"优惠";
            cell.subLabel.hidden = YES;
            float youhui = 0;
            for (MLOrderCartModel *model in self.order_info.cart) {
                youhui+=model.youhuiMoney;
            }
            cell.priceLabel.text = [NSString stringWithFormat:@"-￥%.2f",youhui];
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"满减";
            cell.subLabel.hidden = YES;
            float count = 0;
            cell.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",count];
        }else if (indexPath.row == 3){
            cell.titleLabel.text = @"改价";
            cell.subLabel.hidden = YES;
            float count = 0;
            cell.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",count];
        }else if (indexPath.row == 4){//税费
            cell.titleLabel.text = @"税费";
            cell.subLabel.hidden = YES;
            float count = 0;
            for (MLOrderCartModel *cart in self.order_info.cart) {
                count += cart.sumtax;
            }
            cell.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",count];
        }else{//运费
            CGFloat yunfei = 0;
            for (MLOrderCartModel *model in self.order_info.cart) {
                yunfei += model.kuaiDiFangshi.price;
            }
            cell.titleLabel.text = @"运费";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",yunfei];
        }
        cell.titleLabel.hidden = NO;
        cell.priceLabel.hidden = NO;
        return cell;
    }else if (indexPath.section == 2*self.order_info.cart.count){
        if (indexPath.row == 0) {
            MLOrderSubArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubArrowTableViewCell forIndexPath:indexPath];
            cell.titleLabel.text = @"发票信息";
            cell.subLabel.hidden = YES;
            cell.rightLabel.hidden = YES;
            cell.titleLabel.hidden = NO;
            return cell;
        }else{
            MLOrderSubFaPiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubFaPiaoTableViewCell forIndexPath:indexPath];
            cell.shifouKai = self.order_info.fapiao;
            cell.company.text = [NSString stringWithFormat:@"%@-%@",self.order_info.geren?@"个人":@"公司",self.order_info.geren?@"明细":self.order_info.mingxi];
            return cell;
            
        }
    }
    else{
         __block MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:indexPath.section/2];
        switch (indexPath.section%2) {
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
                if (indexPath.row == 0 || indexPath.row == 4) {//税费
                    MLOrderSubTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubTextTableViewCell forIndexPath:indexPath];
                    if (indexPath.row == 0) {
                        cell.titleLabel.text = @"税费";
                        cell.subLabel.text = @"(含消费税和增值税)";
                        cell.subLabel.hidden = NO;
                        cell.priceLabel.text =[NSString stringWithFormat:@"￥%.2f",cart.sumtax];
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = NO;
                        cell.subLabel.hidden = NO;
                    }else if (indexPath.row == 4){
                        NSString *attr = [NSString stringWithFormat:@"<font size =\"14\"><color value=\"#000000\">订单小计</><color value=\"#999999\">  (含运费和税费)</><color value=\"#FF4E25\">  ￥%.2f</></>",cart.dingdanXiaoji];
                        cell.priceLabel.attributedText = [attr createAttributedString];
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = YES;
                        cell.subLabel.hidden = YES;
                    }
                    return cell;
                }else if (indexPath.row == 3){
                     NSString *cellId = [NSString stringWithFormat:@"cell_%@",cart.ID];
                    MLOrderSubLiuYanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (!cell) {
                        cell = [[MLOrderSubLiuYanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }
                    cart.liuYan = cell.liuYanField;
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
                        [self refreshHeadView];
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
                        [self refreshHeadView];
                    };
                    cell.dataSource = cart.yhqdata;
                    return cell;
                }
            }
  
                break;
            default:
                break;
        }
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2*self.order_info.cart.count + 1) {
        return 44;
    }
    else if (indexPath.section == 2*self.order_info.cart.count){

        if (indexPath.row == 0) {
            return 44;
        }else{
            if (self.order_info.fapiao) {
                return 60;
            }
            else{
                return 35;
            }
            }
    }
    else{
        MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:indexPath.section/2];
        switch (indexPath.section%2) {
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
        default:
        break;
        }
        return 0;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2*self.order_info.cart.count+1) {
        return;
    }
    else if (indexPath.section == 2*self.order_info.cart.count){
    if (indexPath.row == 0) { //选发票
        MLInvoiceViewController *vc = [[MLInvoiceViewController alloc]init];
        vc.isNeed = NO;
        vc.invoiceBlock = ^(BOOL xuyao,BOOL geren,NSString *mingxi,NSString *ID){
            self.order_info.fapiao = xuyao;
            self.order_info.geren = geren;
            self.order_info.mingxi = mingxi;
            self.order_info.fapiao_ID = ID;
            [self.tableView reloadData];
            [self refreshHeadView];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    }
    else{
         __block  MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:indexPath.section/2];
        switch (indexPath.section%2) {
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
    [self.order_info.cart enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MLOrderCartModel *cart = (MLOrderCartModel *)obj;
        [self confirmOrderParams:cart AndParams:params AndIndex:idx];
    }];
    for (MLOrderCartModel *cart in self.order_info.cart) { //检查优惠券使用情况
        for (MLYouHuiQuanModel *model in cart.yhqdata) {
            if (model.useSum > 0) { //说明被使用过
                NSString *key = [NSString stringWithFormat:@"yhquse[%@][%@]",cart.sell_userid,model.ID];
                params[key] = [NSNumber numberWithFloat:model.useSum];
            }
        }
    }
    params[@"s_sumprice"] = [NSNumber numberWithFloat:allPrice];
    params[@"hidden_consignee_id"] = self.order_info.consignee.delivery_address_id;
    params[@"invoice_id"] = self.order_info.fapiao?self.order_info.fapiao_ID:@"";
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=confirm_order_submit",MATROJP_BASE_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MLHttpManager post:url params:params m:@"product" s:@"confirm_order_submit" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"提交订单为：%@",result);
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSString *order_id = data[@"order_id"];
            MLPayViewController *vc = [[MLPayViewController alloc]init];
            vc.order_id = order_id;
            vc.order_sum = allPrice;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}


- (void )confirmOrderParams:(MLOrderCartModel *)model AndParams:(NSMutableDictionary *)params AndIndex:(NSInteger)index{
    NSString *cartKey = [NSString stringWithFormat:@"product_id[%li]",index];
    NSString *msgKey = [NSString stringWithFormat:@"msg_%@",model.ID];
    NSString *logTypeKey = [NSString stringWithFormat:@"logistics_type_%@",model.ID];
    NSString *logPriceKey = [NSString stringWithFormat:@"logistics_price_%@",model.ID];
    NSString *logTaxKey = [NSString stringWithFormat:@"logistics_tax_%@",model.ID];
    params[logTypeKey] = model.kuaiDiFangshi.company;
    params[logPriceKey] = [NSNumber numberWithFloat: model.kuaiDiFangshi.price];
    params[logTaxKey] = [NSNumber numberWithFloat:model.kuaiDiFangshi.sumtax];
    params[msgKey]= model.liuYan.text;
    params[cartKey] = model.ID;
    
}


/**
 *  重新获取订单信息
 *
 *  @param products
 */
- (void)confirmOrder{//创建订单
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=confirm_order",MATROJP_BASE_URL];
    [MLHttpManager post:urlStr params:self.params m:@"product" s:@"confirm_order" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            //订单提交成功   后续操作
            NSDictionary *data = result[@"data"];
            MLCommitOrderListModel *model = [MLCommitOrderListModel mj_objectWithKeyValues:data];
            self.order_info = model;
            [self.tableView reloadData];
            [self refreshHeadView];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
}




@end

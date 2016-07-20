//
//  MLOrderSubmitViewController.m
//  Matro
//
//  Created by MR.Huang on 16/7/7.
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
#import "CommonHeader.h"

@interface MLOrderSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)MLOrderSubHeadView *headView;
@property (nonatomic,strong)UILabel *sumLabel;
@property (nonatomic,strong)MLAddressSelectViewController *addVc;
@property (nonatomic,strong)UIView *headBgView;


@end

static BOOL idCardOk = NO;

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
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, self.order_info.isHaveHaiWai?160:98)];
        MLOrderSubHeadView *headView = [MLOrderSubHeadView headView];
        headView.orderSubChangeInfo = ^(NSString *msg){
            [MBProgressHUD showMessag:msg toView:self.view];
        };
        headView.idcardisOk = ^(BOOL ok){
            idCardOk = ok;
        };
        headView.isShowSFZ = self.order_info.isHaveHaiWai;
        [headView.addressControl addTarget:self action:@selector(showAddress:) forControlEvents:UIControlEventTouchUpInside];
        self.headView = headView;
        [head addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        tableView.tableHeaderView = head;
        self.headBgView = head;
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
    
    [self changeHeadView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.footView.mas_top);
    }];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.tableView reloadData];
    
}


- (void)showAddress:(id)sender{  //重新向服务器拉数据
    [self.navigationController pushViewController:self.addVc animated:YES];
}

- (void)changeHeadView{
    if (self.order_info.consignee.name.length == 0 || self.order_info.consignee.address.length == 0) { //如果没有个人信息
        self.headView.isShowWarning = YES;
        CGFloat height = 0;
        if (self.order_info.isHaveHaiWai) { //如果是海外购
            height = 54+8+54+8;
        }else{ //不是海外购
            height = 54+8;
        }
        self.headBgView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, height);
        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:self.headBgView];
        [self.tableView endUpdates];
    }else{ //如果有个人信息
        self.headView.isShowWarning = NO;
        CGFloat height = 0;
        if (self.order_info.isHaveHaiWai) { //如果是海外购
            height = 90+8+54+8;
        }else{ //不是海外购
            height = 90+8;
        }
        self.headBgView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, height);
        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:self.headBgView];
        [self.tableView endUpdates];
    }

}


- (void)refreshHeadView{
    if (self.order_info.identity_card.length>0) { //如果有身份证直接显示
        self.headView.shenfenzhengField.text = self.order_info.identity_card;
        [self.headView haveIdCardSave];
        idCardOk = YES;
    }

    
    self.headView.nameLabel.text = self.order_info.consignee.name;
    self.headView.phoneLabel.text = self.order_info.consignee.mobile;
    self.headView.addressLabel.text = [NSString stringWithFormat:@"%@%@",self.order_info.consignee.area?:@"",self.order_info.consignee.address?:@""];
    self.headView.shenfenzhengField.text = self.order_info.identity_card;
    NSString *attrPrice = [NSString stringWithFormat:@"<font size=\"16\"><color value=\"000000\">实付金额：</><color value=\"#FF4E25\">￥%.2f</></>",self.order_info.realPrice];
    self.sumLabel.attributedText = [attrPrice createAttributedString];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2*self.order_info.cart.count+1) { //最后一行
        return 5;
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
                return 6;
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
            cell.priceLabel.text = [NSString stringWithFormat:@"-￥%.2f",self.order_info.realYouHui];
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"满减";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text =  [NSString stringWithFormat:@"-￥%.2f",self.order_info.realManJian];
        }else if (indexPath.row == 3){//税费
            cell.titleLabel.text = @"税费";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",self.order_info.realTax];

        }else{//运费
            cell.titleLabel.text = @"运费";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.order_info.realYunFei];
        }
        cell.titleLabel.hidden = NO;
        cell.priceLabel.hidden = NO;
        cell.contentView.hidden = NO;
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
                if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 3) {//税费  小计 满减
                    MLOrderSubTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubTextTableViewCell forIndexPath:indexPath];
                    if (indexPath.row == 0) {
                        if (cart.way != 2) {
                            cell.contentView.hidden = YES;
                            //税费
                           
                        }else{
                            cell.contentView.hidden = NO;
                            cell.titleLabel.text = @"税费";
                            cell.subLabel.text = @"(含消费税和增值税)";
                            cell.subLabel.hidden = NO;
                            //税费
                            cell.priceLabel.text =[NSString stringWithFormat:@"￥%.2f",cart.realShuiFei];
                            cell.priceLabel.hidden = NO;
                            cell.titleLabel.hidden = NO;
                            cell.subLabel.hidden = NO;
                        }
                         [self refreshHeadView];
                    }else if (indexPath.row == 5){
                        cell.contentView.hidden = NO;
                        NSString *attr = [NSString stringWithFormat:@"<font size =\"14\"><color value=\"#000000\">订单小计</><color value=\"#999999\">  (含运费和税费)</><color value=\"#FF4E25\">  ￥%.2f</></>",cart.dingdanXiaoji];
                        cell.priceLabel.attributedText = [attr createAttributedString];
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = YES;
                        cell.subLabel.hidden = YES;
                    }else{
                        cell.contentView.hidden = NO;
                        cell.titleLabel.text = @"满减";
                        cell.subLabel.hidden = YES;
                        //税费
                        cell.priceLabel.text =[NSString stringWithFormat:@"-￥%.2f",cart.reduce_price];
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = NO;
                    }
                    return cell;
                }else if (indexPath.row == 4){ //留言cell
                    
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
            if (indexPath.row == 0 && cart.way != 2) { //税费
                return 0;
            }
            if (indexPath.row == 5) {
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
        vc.isNeed = self.order_info.fapiao;
        vc.isGeren = self.order_info.geren;
        vc.mingxi = self.order_info.mingxi;
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
    if (!idCardOk){//身份证是否ok了
        [MBProgressHUD showMessag:@"请输入身份证号码" toView:self.view];
        return;
    }
    
    if (!self.order_info.consignee.isOk) {
        [MBProgressHUD showMessag:@"请选择收货地址" toView:self.view];
        return;
    }
    
    __block NSInteger proIndex = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.order_info.cart enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MLOrderCartModel *cart = (MLOrderCartModel *)obj;
        NSString *msgKey = [NSString stringWithFormat:@"msg_%@",cart.ID];
        NSString *logTypeKey = [NSString stringWithFormat:@"logistics_type_%@",cart.ID];
        NSString *logPriceKey = [NSString stringWithFormat:@"logistics_price_%@",cart.ID];
        NSString *logTaxKey = [NSString stringWithFormat:@"logistics_tax_%@",cart.ID];
        params[logTypeKey] = cart.kuaiDiFangshi.company;
        params[logPriceKey] = [NSNumber numberWithFloat: cart.kuaiDiFangshi.price];
        params[logTaxKey] = [NSNumber numberWithFloat:cart.kuaiDiFangshi.sumtax];
        params[msgKey]= cart.liuYan.text;
        for (MLOrderProlistModel *product in cart.prolist) {
            NSString *proKey = [NSString stringWithFormat:@"product_id[%li]",proIndex];
            params[proKey] = product.ID;
            proIndex ++;
        }
        
    }];
    for (MLOrderCartModel *cart in self.order_info.cart) { //检查优惠券使用情况
        for (MLYouHuiQuanModel *model in cart.yhqdata) {
            if (model.useSum > 0) { //说明被使用过
                NSString *key = [NSString stringWithFormat:@"yhquse[%@][%@]",cart.ID,model.ID];
                params[key] = [NSNumber numberWithFloat:model.useSum];
            }
        }
    }
    params[@"s_sumprice"] = [NSNumber numberWithFloat:self.order_info.realPrice];
    params[@"hidden_consignee_id"] = self.order_info.consignee.delivery_address_id;
    params[@"invoice_id"] = self.order_info.fapiao?self.order_info.fapiao_ID:@"";
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=confirm_order_submit",MATROJP_BASE_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MLHttpManager post:url params:params m:@"product" s:@"confirm_order_submit" success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSString *order_id = data[@"order_id"];
            NSString *orderNum = data[@"order_num"];
            if ([orderNum integerValue]>1) { //如果订单超过两个 跳到订单列表页
                [self.tabBarController setSelectedIndex:3];
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PushToOrderCenter" object:nil];
            }else{//否则跳到收银台
                MLPayViewController *vc = [[MLPayViewController alloc]init];
                vc.order_id = order_id;
                vc.order_sum = self.order_info.realPrice;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
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
            [self changeHeadView];
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



- (MLAddressSelectViewController *)addVc{
    if (!_addVc) {
        _addVc = [[MLAddressSelectViewController alloc]init];
        __weak typeof(self) weakself = self;
        _addVc.addressSelectBlock = ^(MLAddressListModel *address){ //返回后设置当前地址为默认地址 然后重新拉取数据
            [weakself confirmOrder];
        };
    }
    return _addVc;
    
}


@end

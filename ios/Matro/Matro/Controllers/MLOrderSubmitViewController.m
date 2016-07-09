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



@interface MLOrderSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;


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

        [self.view addSubview:tableView];
        tableView;
    });
    
    _footView = ({
        UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footView];
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        priceLabel.text = @"商品价格:138元人民币";
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
            cell.priceLabel.text = @"$210";
            cell.subLabel.hidden = NO;
        }else if (indexPath.row == 1){//优惠
            cell.titleLabel.text = @"优惠";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text = @"-￥20";
        }else if (indexPath.row == 2){//税费
            cell.titleLabel.text = @"税费";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text = @"￥0.00";
        }else{//运费
            cell.titleLabel.text = @"运费";
            cell.subLabel.hidden = YES;
            cell.priceLabel.text = @"￥0.00";
        }
        cell.titleLabel.hidden = NO;
        cell.priceLabel.hidden = NO;
        return cell;
    }else{
         MLOrderCartModel *cart = [self.order_info.cart objectAtIndex:indexPath.section/3];
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
                        cell.priceLabel.text = @"￥12.00";
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = NO;
                        cell.subLabel.hidden = NO;
                    }else if (indexPath.row == 3){
                        cell.titleLabel.text = @"给卖家留言：";
                        cell.subLabel.hidden = YES;
                        cell.priceLabel.hidden = YES;
                        cell.titleLabel.hidden = NO;
                    }else if (indexPath.row == 4){
                        cell.priceLabel.text = @"订单小计(含运费和税费) ￥1212.00";
                        cell.priceLabel.hidden = NO;
                        cell.titleLabel.hidden = YES;
                        cell.subLabel.hidden = YES;
                    }
                    return cell;
                }
                MLOrderSubArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubArrowTableViewCell forIndexPath:indexPath];
                if (indexPath.row == 1) {//配送方式
                    cell.titleLabel.text = @"配送方式";
                    cell.rightLabel.text = @"中通 包邮";
                    cell.subLabel.hidden = YES;
                    cell.rightLabel.textColor = RGBA(174, 142, 93, 1);
                }else{
                    cell.titleLabel.text = @"优惠券";
                    cell.subLabel.text = @"1张可用";
                    cell.rightLabel.text = @"未使用";
                    cell.rightLabel.textColor = RGBA(80, 80, 80, 1);
                    cell.titleLabel.hidden = NO;
                    cell.subLabel.hidden = NO;
                    cell.rightLabel.hidden = NO;
                }

                
                return cell;
            }
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
            }
                break;
            case 2:
            {
                if (indexPath.row == 0) { //选发票
                    MLInvoiceViewController *vc = [[MLInvoiceViewController alloc]init];
                    vc.invoiceBlock = ^(BOOL xuyao,BOOL geren,NSString *mingxi){
                        cart.fapiao = xuyao;
                        cart.geren = geren;
                        cart.mingxi = mingxi;
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
}


@end

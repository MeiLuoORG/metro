//
//  MLPayresultViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPayresultViewController.h"

#import "MLLikeTableViewCell.h"
#import "MLPayerrTableViewCell.h"
#import "HFSOrderListHeaderView.h"
#import "MLPayresultHeader.h"
#import "MLGoodsDetailsViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLLikeModel.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "MJExtension.h"
#import "MLLoginViewController.h"
#import "MLQQGshenfenViewController.h"

#define HEADER_IDENTIFIER @"MLPayresultHeader"
#define HEADER_IDENTIFIER01 @"OrderListHeaderIdentifier"

@interface MLPayresultViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_likeArray;
    NSArray *_likeArr;
    NSArray * _errTitleArray;
    BOOL isShangchuan;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *otherBgView;

@end

@implementation MLPayresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _likeArray = [[NSMutableArray alloc]init];
    if (_isSuccess) {
        self.title = @"支付成功";
        //[self loadDateOrLike];
    }
    
    _otherBgView.hidden = _isSuccess;
    self.XuanZeQiTaButton.layer.cornerRadius = 4.0f;
    self.XuanZeQiTaButton.layer.masksToBounds = YES;
    
    //[_tableView registerNib:[UINib nibWithNibName:@"MLPayresultHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    
    //[_tableView registerNib:[UINib nibWithNibName:@"HFSOrderListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER01];
    /*
    _likeArray = [[NSMutableArray alloc]initWithArray:@[@{
                                                            @"image":@"http://mg.soupingguo.com/bizhi/big/10/266/947/10266947.jpg"
                                                            },@{
                                                            @"image":@"http://pic6.nipic.com/20100330/1295091_132647229343_2.jpg",
                                                            },@{
                                                            @"image":@"http://www.bz55.com/uploads/allimg/150202/139-150202134H6.jpg",                                                                                                                     },@{
                                                            @"image":@"http://pic24.nipic.com/20121020/10653015_165154682160_2.jpg",
                                                            },@{
                                                            @"image":@"http://pic25.nipic.com/20121129/8305779_151443594000_2.jpg",
                                                            } ]];
    
    _errTitleArray = @[@"订单编号：",@"支付金额：",@"支付方式：",@"失败原因："];
     */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = item;
    [self guessYourLike];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self shangchuan];

}

-(void)shangchuan{

    //判断是否需要对身份进行验证
    //    http://bbctest.matrojp.com/api.php?m=product&s=admin_buyorder&action=order_idcard&order_id=201610311432524240     order_id
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=admin_buyorder&action=order_idcard&order_id=%@",MATROJP_BASE_URL,self.order_id];
    [MLHttpManager get:url params:nil m:@"product" s:@"admin_buyorder" success:^(id responseObject) {
        if ([responseObject[@"code"]isEqual:@0]) {
            NSDictionary *result = responseObject[@"data"];
            if ([result[@"flag"] isEqual:@1]) {
                isShangchuan = YES;
            }else{
                isShangchuan = NO;
            }
        }else{
            isShangchuan = NO;
        }
    } failure:^(NSError *error) {

        isShangchuan = NO;
        [MBProgressHUD showMessag:REQUEST_ERROR_ZL toView:self.view];
    }];

}

- (void)goBack{
    /*
    [self.navigationController popViewControllerAnimated:NO];
    [self getAppDelegate].tabBarController.selectedIndex = 0;
     */
     /*
    UIViewController *vc = [self.navigationController.viewControllers firstObject];
    if ([vc isKindOfClass:[MLShopBagViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    */
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 [self getAppDelegate].tabBarController.selectedIndex = 0;
 [self.navigationController popToRootViewControllerAnimated:YES];
 */

#pragma mark 获取猜你喜欢数据

- (void)guessYourLike{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=product&s=guess_like&method=get_guess_like&start=0&limit=10",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"product" s:@"guess_like" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"猜你喜欢数据为：%@",result);
        if ([result[@"code"]isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *product = data[@"product"];
            [MLGuessLikeModel mj_objectArrayWithKeyValuesArray:product];
            [_likeArray addObjectsFromArray:[MLGuessLikeModel mj_objectArrayWithKeyValuesArray:product]];
            [_tableView reloadData];
        }else if ([result[@"code"]isEqual:@1002]){
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
            
        }
        /*
         if ([result[@"code"] isEqual:@0]) {
         [self.likeArray removeAllObjects];
         NSDictionary *data = result[@"data"];
         NSArray *product = data[@"product"];
         [self.likeArray addObjectsFromArray:[MLGuessLikeModel mj_objectArrayWithKeyValuesArray:product]];
         [self.collectionView reloadData];
         }else{
         
         }
         */

    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:REQUEST_ERROR_ZL toView:self.view];
    }];
    /*
    [[HFSServiceClient sharedJSONClientNOT]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

    }];
     */
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

/*
- (void)loadDateOrLike {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=getcnxh&spsl=2",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"猜你喜欢 请求成功");
        NSArray *arr = (NSArray *)responseObject;
        _likeArr = [MTLJSONAdapter modelsOfClass:[MLLikeModel class] fromJSONArray:arr error:nil];
        _likeArray = [[NSMutableArray alloc]initWithArray:_likeArr];
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"猜你喜欢 请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
}
*/


- (void)likeAction:(id)sender{
    UIControl * control = ((UIControl *)sender);
//

    
    NSLog(@"%ld",control.tag);
    MLGuessLikeModel *likeobjl = _likeArray[control.tag];

    NSString * pid  = likeobjl.ID;
    
    NSDictionary *params = @{@"id":pid?:@""};
    [MLGuessLikeModel mj_keyValues];
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    vc.paramDic = params;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (IBAction)otherAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        if(_isSuccess){
            return _likeArray.count%2 == 0 ? _likeArray.count/2 : (_likeArray.count + 1)/2;
        }
    }
    return 0;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSuccess) {
        static NSString *CellIdentifier = @"MLLikeTableViewCell" ;
        MLLikeTableViewCell *cell = (MLLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        NSInteger lnum = indexPath.row * 2;
        NSInteger rnum = indexPath.row * 2 + 1;
        
        MLGuessLikeModel *likeobjl = _likeArray[lnum];
        
        NSURL * url = [NSURL URLWithString:likeobjl.pic];
        
        if ([likeobjl.pic hasSuffix:@"webp"]) {
            [cell.imageView01 setZLWebPImageWithURLStr:likeobjl.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
             [cell.imageView01 sd_setImageWithURL:url placeholderImage:PLACEHOLDER_IMAGE];
        }
        
            cell.lBgView.tag = lnum;
            cell.nameLabel01.text = likeobjl.pname;
        
        
        if (likeobjl.promotion_price == 0.0) {
            cell.rpriceLabel01.hidden = YES;
            cell.priceLabel01.text = [NSString stringWithFormat:@"￥%.2f",likeobjl.price];
        }
        else{
            cell.priceLabel01.text = [NSString stringWithFormat:@"￥%.2f",likeobjl.promotion_price ];
           
            NSString * lP = [NSString stringWithFormat:@"￥%.2f",likeobjl.price];
            NSLog(@"原价为：%@",lP);
            NSAttributedString *attrStr =
            [[NSAttributedString alloc]initWithString:lP
                                           attributes:
             @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
               NSForegroundColorAttributeName:[UIColor grayColor],
               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
               NSStrikethroughColorAttributeName:[UIColor grayColor]}];
            cell.rpriceLabel01.attributedText = attrStr;
        }
        /*
        NSUInteger length = [likeobjl.LSDJ length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:likeobjl.LSDJ];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
         NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName
                      value:cell.rpriceLabel01.textColor range:NSMakeRange(0, length)];
        [cell.rpriceLabel01 setAttributedText:attri];
        */
        
        [cell.lBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (rnum >= _likeArray.count) {
            cell.rBgView.hidden = YES;
        }else{
            MLGuessLikeModel *likeobjr = _likeArray[rnum];
            
            cell.rBgView.hidden = NO;
            NSURL * url = [NSURL URLWithString:likeobjr.pic];
            
            if ([likeobjr.pic hasSuffix:@"webp"]) {
                [cell.imageView02 setZLWebPImageWithURLStr:likeobjr.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [cell.imageView02 sd_setImageWithURL:url placeholderImage:PLACEHOLDER_IMAGE];
            }
            cell.rBgView.tag = rnum;
            cell.nameLabel02.text = likeobjr.pname;
            
            
            if(likeobjr.promotion_price  == 0.0){
                cell.rpriceLabel02.hidden = YES;
                cell.priceLabel02.text = [NSString stringWithFormat:@"￥%.2f",likeobjr.price];
            }
            else{
                cell.priceLabel02.text = [NSString stringWithFormat:@"￥%.2f",likeobjr.promotion_price ];
                NSString * rP = [NSString stringWithFormat:@"￥%.2f",likeobjl.price];
                
                NSAttributedString *attrStr =
                [[NSAttributedString alloc]initWithString:rP
                                               attributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                   NSForegroundColorAttributeName:[UIColor grayColor],
                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                   NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                
                cell.rpriceLabel02.attributedText = attrStr;
            }
            
            /*
            NSUInteger length = [likeobjr.LSDJ length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:likeobjr.LSDJ];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
             NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName
                          value:cell.rpriceLabel02.textColor range:NSMakeRange(0, length)];
            [cell.rpriceLabel02 setAttributedText:attri];
            */
            [cell.rBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"MLPayerrTableViewCell" ;
        MLPayerrTableViewCell *cell = (MLPayerrTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        //cell.peTitleLabel.text = _errTitleArray[indexPath.row];
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        if (_isSuccess) {
            return MAIN_SCREEN_WIDTH * 280/489 + 24;
        }
    }
    return 0;
    
}

//设置头部的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 36.0f;
    }else{
        
            return 290;
            
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1 && !_isSuccess) {
        return 92;
    }
    return 12.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        HFSOrderListHeaderView *headerView = [[HFSOrderListHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER01];
        if (_isSuccess) {
           headerView.nameLabel.text = @"猜你喜欢";
        }else{
            headerView.nameLabel.text = @"您的支付信息";
        }
        
        headerView.orderStatusLabel.hidden = YES;
        return headerView;
    }else{
        MLPayresultHeader *headerView = [[MLPayresultHeader alloc]initWithReuseIdentifier:HEADER_IDENTIFIER];
        headerView.toHome.layer.cornerRadius = 4.0f;
        headerView.toOrder.layer.cornerRadius = 4.0f;
        headerView.toOrder.layer.masksToBounds = YES;
        headerView.toHome.layer.masksToBounds = YES;
        if (_isSuccess) {
            headerView.tisLabel.text = @"支付成功";
            headerView.tisImageView.image = [UIImage imageNamed:@"zhifuchenggong-1"];
            [headerView.toOrder addTarget:self action:@selector(toOrderAction:) forControlEvents:UIControlEventTouchUpInside];
            if (isShangchuan == YES) {
                [headerView.toHome setTitle:@"完善信息" forState:UIControlStateNormal];
            }else{
                [headerView.toHome setTitle:@"继续购物" forState:UIControlStateNormal];

            }
            [headerView.toHome addTarget:self action:@selector(toHomeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else{
            headerView.tisLabel.text = @"支付失败了！";
            headerView.tisImageView.image = [UIImage imageNamed:@"zhifushibai-1"];
            
            headerView.toHome.hidden = YES;
            headerView.toOrder.hidden = YES;
        }
        
        return headerView;
    }
}


- (void)toHomeAction:(UIButton *)sender{
    //[self.navigationController popViewControllerAnimated:NO];
    //self.hidesBottomBarWhenPushed = NO;
    if ([sender.titleLabel.text isEqualToString: @"完善信息"]) {
        MLQQGshenfenViewController *vc = [[MLQQGshenfenViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.tabBarController.tabBar setHidden:NO];
        [self getAppDelegate].tabBarController.selectedIndex = 0;
    }

}

- (void)toOrderAction:(UIButton *)sender{
    MLPersonOrderDetailViewController *vc = [[MLPersonOrderDetailViewController alloc]init];
    vc.order_id = self.order_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end

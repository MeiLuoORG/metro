//
//  MLBagViewController.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBagViewController.h"

#import "MLLoginViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLSureViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MTLJSONAdapter.h"
#import "MLLikeModel.h"

#import "HFSOrderListHeaderView.h"
#import "MLBagHeaderView.h"
#import "MLBagActiveTableViewCell.h"
#import "MLBagGoodsTableViewCell.h"
#import "MLBagZengpinTableViewCell.h"
#import "MLLikeTableViewCell.h"
#import "JSONKit.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLBagFootView.h"
#import <objc/runtime.h>
#import "MLInvoiceViewController.h"
#import "YMNavigationController.h"
#import "MJRefresh.h"
#import "Masonry.h"



#define HEADER_IDENTIFIER @"MLBagHeaderView"
#define HEADER_IDENTIFIER01 @"OrderListHeaderIdentifier"
#define FOOTER_IDENTIFIER @"OrderListFOOTIdentifier"

@interface MLBagViewController ()<UITableViewDelegate,UITableViewDataSource,CPStepperDelegate>{
    UITableView * _tableView;
    NSMutableDictionary * totalArray;
    NSMutableArray *oridinalAry;
    NSMutableArray *globalAry1;
    NSMutableArray *globalAry2;

    NSMutableArray *_likeArray;

    NSMutableArray *globalFrom; //来自哪个仓库
    int sectionkey;
    NSString *userid;
    NSMutableArray *selAry;
    BOOL iseidtStatus;
    BOOL isGlobalOrder;
    float totalGlobalPrice;//全球购商品总价
    float totalSelPrice;//购物车总价
    int globalsection;//是否有不同的全球购仓库
    BOOL hasNormalShop;//是否包含普通商品
    BOOL hasGlobalShop;//生成订单时判断是否包含全球购商品
    int totalSelShop; //一共多少商品 底部菜单显示
    int zzccount;//正正仓多少件
}
//点击登录的按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//提示登录的文字
@property (weak, nonatomic) IBOutlet UILabel *tiShiLabel;

@property (strong, nonatomic) IBOutlet UIView *topBgView;//顶部登录底视图，登录时隐藏，未登录时显示 同时需要修改topH,登录 topH = 0 未登录 topH = 54

@property (strong, nonatomic) IBOutlet UIView *baseTableView;//为了做输入框不遮挡键盘，这个view给购物袋的tableview提供大小的约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopH;

@property (nonatomic,strong)MLBagFootView *footView;

@end

@implementation MLBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//       self.title = @"我的购物袋";
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = editBtn;
    editBtn.tintColor = [HFSUtility hexStringToColor:@"AE8E5D"];
    
    
    sectionkey = 0;
    totalArray = [[NSMutableDictionary alloc] init];
    oridinalAry = [[NSMutableArray alloc] init];
    globalAry1 = [[NSMutableArray alloc] init];
    globalAry2 = [[NSMutableArray alloc] init];
    globalFrom = [[NSMutableArray alloc] init];
    _likeArray = [[NSMutableArray alloc] init];
    selAry = [[NSMutableArray alloc] init];
    //设置按钮的边框和颜色
    [_loginBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [_loginBtn.layer setBorderWidth:1.0f];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:3.0f];
    
    //购物袋主tableview
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tvc.tableView.frame = _baseTableView.frame;
    _tableView = [[UITableView alloc]init];
    _tableView = tvc.tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    [self.view insertSubview:_tableView belowSubview:_hud];
    [self addChildViewController:tvc];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"MLBagHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    [_tableView registerNib:[UINib nibWithNibName:@"HFSOrderListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER01];
    
    //去掉弹簧效果
    //_tableView.bounces = NO;
    //隐藏垂直的滚动条
    _tableView.showsVerticalScrollIndicator = NO;
 
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableView.header endRefreshing];
        [self loadDateOrLike];
        
     }];
    
    [_tableView.header beginRefreshing];
    
    
//    [self setupFootView];
    
    
 
}


//- (void)setupFootView{
//    MLBagFootView *footView = [[MLBagFootView alloc]initWithReuseIdentifier:FOOTER_IDENTIFIER];
//    footView.countToPay.backgroundColor = [HFSUtility hexStringToColor:@"AE8E5D"];
//    [footView.countToPay addTarget:self action:@selector(paymentAction:) forControlEvents:UIControlEventTouchUpInside];
//    [footView.checkBtn addTarget:self action:@selector(selectAllSectionGoods:) forControlEvents:UIControlEventTouchUpInside];
//    self.footView = footView;
//    [self.view addSubview:footView];
//    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.mas_equalTo(40);
//    }];
//    
//}
//
//- (void)refreshFootView{
//    
//    int selcount =0;
//    int totalselcount =0;
//    for (int i=0; i<totalArray.count; i++) {
//        NSDictionary *tempDic = [totalArray objectForKey:[NSString stringWithFormat:@"%d",i]];
//        
//        NSArray *temparry = tempDic[@"CartInfoList"];
//        if (temparry && temparry.count>0) {
//            for (NSDictionary *tempdic in temparry) {
//                NSString *selbj = tempdic[@"SELBJ"];
//                BOOL issel = [selbj boolValue];
//                totalselcount++;
//                if (issel) {
//                    selcount++;
//                }
//            }
//            
//        }
//    }
//    if (selcount == totalselcount) {
//        [self.footView.checkBtn setSelected:YES];
//    }
//    else{
//        [self.footView.checkBtn setSelected:NO];
//        
//    }
//    
//    self.footView.totalPriceLB.text = [NSString stringWithFormat:@"￥%.2f元",totalSelPrice];
//    self.footView.totalShopCount.text = [NSString stringWithFormat:@"共%d件商品",totalSelShop];
//    
//    
//}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [totalArray removeAllObjects];
    [self initParam];
    UIBarButtonItem *btn = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
    [btn setTitle:@"编辑"];
//    iseidtStatus = NO;
    
}

-(void)initParam
{
    [selAry removeAllObjects];
     sectionkey=0;
    totalSelShop = 0;
     iseidtStatus=NO;
     isGlobalOrder=NO;
    zzccount=0;
     totalGlobalPrice=0;//全球购商品总价
     totalSelPrice=0;//购物车总价
     globalsection=0;//是否有不同的全球购仓库
     hasNormalShop=NO;//是否包含普通商品
     hasGlobalShop=NO;//生成订单时判断是否包含全球购商品
}

-(void)viewDidAppear:(BOOL)animated
{
    sectionkey = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    CGRect tframe = _baseTableView.frame;
    
    if (userid) {
        self.topBgView.hidden = YES;
        tframe.origin = CGPointMake(_baseTableView.frame.origin.x, 0);
        tframe.size = CGSizeMake(_baseTableView.frame.size.width, _baseTableView.frame.size.height+50);
        _baseTableView.frame = tframe;
        _tableView.frame = tframe;
    }
    else
    {
        self.topBgView.hidden = NO;
        tframe.origin = CGPointMake(_baseTableView.frame.origin.x, 50);
        tframe.size = CGSizeMake(_baseTableView.frame.size.width, _baseTableView.frame.size.height);
        _baseTableView.frame = tframe;
        _tableView.frame = tframe;
    }
    
    [self loadDateOrLike];
    [super viewDidAppear:YES];
    
}

#pragma mark 获取猜你喜欢数据
- (void)loadDateOrLike {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=getcnxh&spsl=6",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if(responseObject)
        {
            [_likeArray removeAllObjects];
            NSLog(@"%@",responseObject);
            NSArray *arr = (NSArray *)responseObject;
            
            if (arr && arr.count>0) {
                [_likeArray addObjectsFromArray:arr];
            }
        }
        
        [self downLoadOrdinaryBag:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"猜你喜欢 请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
}
#pragma mark 获取普通商品信息
- (void)downLoadOrdinaryBag:(BOOL)isshow {
    [self initParam];
//    if (isshow) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_hud show:YES];
//            _hud.mode = MBProgressHUDModeText;
//            _hud.labelText = @"正在加载...";
//        });
//    }
   
    
    [totalArray removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=shopcartlist&selbj=&ddly=&userid=%@",SERVICE_GETBASE_URL,userid];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dic = (NSArray *)responseObject;
        if (dic && dic.count>0) {
            NSDictionary *dicoriginal = [NSDictionary dictionaryWithObjectsAndKeys:dic,@"CartInfoList", nil];
            [totalArray setObject:dicoriginal forKey:[NSString stringWithFormat:@"%i",sectionkey]];
            sectionkey++;
        }
        if (isshow) {
            [_hud hide:YES];

        
        }
        [self downLoadKJBag];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _hud.labelText = @"请求失败";
        if (isshow) {
            [_hud hide:YES afterDelay:2];

        }
    }];
}
#pragma mark 获取跨境商品信息
- (void)downLoadKJBag {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=shopcarthwglist&selbj=&userid=%@",SERVICE_GETBASE_URL,userid];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dicary = (NSArray *)responseObject;
        if (dicary && dicary.count>0) {
            for (NSDictionary *dic in dicary) {
                NSArray *ary = dic[@"CartInfoList"];
                if (ary && ary.count>0) {
                    [totalArray setObject:dic forKey:[NSString stringWithFormat:@"%i",sectionkey]];
                    sectionkey++;
                }
            }

        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"跨境商品 请求失败";
        [_hud hide:YES afterDelay:2];
       
        [_tableView reloadData];


    }];
}

#pragma mark 删除购物车
- (void)deleteCart:(NSDictionary*)paramdic {
    
//    NSData *data = [HFSUtility RSADicToData:@{@""}] ;
//    NSString *ret = base64_encode_data(data);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=delshopcart&JMSP_ID=%@&userid=%@",SERVICE_GETBASE_URL,paramdic[@"JMSP_ID"],userid];
        NSURL * URL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                          NSLog(@"%@",result);
//                                          NSLog(@"error %@",result);
                                          if (result && [@"true" isEqualToString:result ]) {
                                             
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  UIBarButtonItem *btn = self.navigationItem.rightBarButtonItem;
                                                  
                                                  [self editAction:btn];
                                                                                            });
                                             
                                              [self downLoadOrdinaryBag:NO];
                                          }
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}


#pragma mark- 结算
- (IBAction)paymentAction:(id)sender{
    
    if (totalSelPrice<=0) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"您还没有添加任何商品";
        [_hud hide:YES afterDelay:1];
        return;
    }
    
    UIButton *btn = (UIButton*)sender;
    for (NSDictionary *tempdic in selAry) {
        if (![tempdic[@"HWGCKDM"] isEqualToString:@""]) {
            isGlobalOrder = YES;
        }
        
    }
    NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",btn.tag]];
//    if (![arydic[@"HWGCKDM"] isEqualToString:@""]) {
//        isGlobalOrder = YES;
//    }
//    else{
//        isGlobalOrder = NO;
//    }
    
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    
    if (totalGlobalPrice>2000) {
        _hud.labelText = @"您的全球购商品超过2000元，请分开结算";
        [_hud hide:YES afterDelay:1];
        return;
    }
    if (hasNormalShop && hasGlobalShop) {
        _hud.labelText = @"您的购物袋包含全球购商品，请分开结算";
        [_hud hide:YES afterDelay:1];
        return;
    }
   
    
    if (globalsection>1) {
        _hud.labelText = @"你的购物袋商品分属不同仓，请分开结算";
        [_hud hide:YES afterDelay:1];
        return;
    }
//    if (zzccount>1) { //追加条件
//        _hud.labelText = @"你的购物袋商品分属不同仓，请分开结算";
//        [_hud hide:YES afterDelay:1];
//        return;
//    }
//    _hud.labelText = @"正在生成订单，请稍后...";
    [_hud hide:YES ];
    
    MLSureViewController * vc = [[MLSureViewController alloc]init];
    vc.paramDic = arydic;
    vc.isGlobalShop = isGlobalOrder;
    vc.shopsary = selAry;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
//    [self ordercheck:arydic]; 因为修改了接口，需要去掉确认订单页面调接口
}

#pragma mark- 登录
- (IBAction)loginButtonAction:(id)sender {
//    NSString *typeStr = ((UIButton *)sender).titleLabel.text;
    
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
//    if ([typeStr isEqualToString:@"登录"]) {
//        vc.isLogin = YES;
//    }else{
//        vc.isLogin = NO;
//    }

    YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:^{
        
    }];

}



-(void)orderAccount:(NSDictionary*)dic
{
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/ordersubmit.ashx?op=JieSuanInfo&ddly=0&userid=%@",SERVICE_GETBASE_URL,userid];

    NSURL * URL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          result = [result substringWithRange:NSMakeRange(1, result.length-2)];
//                                        [result stringByReplacingOccurrencesOfString:@"\\\\" withString:@"" options:1 range:NSMakeRange(0, result.length)];
                                          result = [result stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                          NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                                          NSError *err;
                                          NSDictionary *rdic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                              options:NSJSONReadingMutableContainers
                                                                                                error:&err];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [_hud hide:YES];
                                              MLSureViewController * vc = [[MLSureViewController alloc]init];
                                              vc.paramDic = rdic;
                                              vc.isGlobalShop = isGlobalOrder;
                                              vc.shopsary = selAry;
                                              self.hidesBottomBarWhenPushed = YES;
                                              [self.navigationController pushViewController:vc animated:YES];
                                              self.hidesBottomBarWhenPushed = NO;
                                          });
                                      
                                      }
                                      
                                     
                                      
                                  }];
    
    
    [task resume];
}

-(BOOL)ordercheck:(NSDictionary*)paramdic
{
    __block BOOL isok=NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=jiesuan&ddly=0&userid=%@",SERVICE_GETBASE_URL,userid];
    NSURL * URL = [NSURL URLWithString:urlStr];
    
    //    NSData * postData = [params dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"error %@",result);
                                          if (result.length<=2) {
                                              isok = true;
                                              [self orderAccount:paramdic];
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = result;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:2];
                                              });

                                          }
                                      }
                                      
                                  }];
    
    [task resume];
    
    return isok;
    
    
}

#pragma mark- 猜你喜欢点击
- (void)likeAction:(id)sender{
    UIControl * control = ((UIControl *)sender);
    
    NSDictionary *paramdic = _likeArray[control.tag];
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    vc.paramDic = paramdic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_likeArray.count>0) {
        return totalArray.count+1;
    }
    return totalArray.count; //商品的senction + 猜你喜欢的section
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section == totalArray.count) {//猜你喜欢的cell的数量，一个cell同时显示两个商品，所以得除
        if(iseidtStatus){
            return 0;
        }
        return _likeArray.count%2 == 0 ? _likeArray.count/2 : (_likeArray.count + 1)/2;
    }else{//假数据里面的列表的数量
        NSArray *list;
        NSDictionary *dic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",section]];
        if (dic[@"CartInfoList"]) {
            list = (NSArray*)dic[@"CartInfoList"];
        }
        return list.count;
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section != totalArray.count) {
//        NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
//        NSDictionary *tempdic = arydic[@"CartInfoList"][indexPath.row];
//        if (!tempdic[@"tis"] && !tempdic[@"zeng"])
//        {
//            
//            MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
//            vc.paramDic = tempdic;
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//        }
//    }
//}

//猜你喜欢
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == totalArray.count) {//猜你喜欢
        
        static NSString *CellIdentifier = @"MLLikeTableViewCell" ;
        MLLikeTableViewCell *cell = (MLLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        NSInteger lnum = indexPath.row*2;
        NSDictionary *likeobjl = _likeArray[lnum];
        NSDictionary *likeobjr = nil;
        NSInteger rnum = indexPath.row + 1;
        if (rnum<_likeArray.count) {
            likeobjr = _likeArray[rnum];
            
            [cell.imageView02 sd_setImageWithURL:[NSURL URLWithString:likeobjr[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
            cell.rBgView.tag = rnum;
            cell.nameLabel02.text = likeobjr[@"SPNAME"];
            
            float xj = [likeobjr[@"XJ"] floatValue];
            cell.priceLabel02.text =[NSString stringWithFormat:@"￥%.2f",xj] ;
            
            float yj = [likeobjr[@"LSDJ"] floatValue];
            NSLog(@"%f,%f",xj,yj);
            NSString *yjs =[NSString stringWithFormat:@"￥%.2f",yj];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:yjs];
            NSUInteger length = [yjs length];

            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
             NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName
                          value:cell.rpriceLabel02.textColor range:NSMakeRange(0, length)];
            [cell.rpriceLabel02 setAttributedText:attri];
            [cell.rBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
//        else{
        if (rnum >= _likeArray.count) {
            cell.rBgView.hidden = YES;
        }
        
        [cell.imageView01 sd_setImageWithURL:[NSURL URLWithString:likeobjl[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
        cell.lBgView.tag = lnum;
        cell.nameLabel01.text = likeobjl[@"SPNAME"];
        cell.priceLabel01.text = [NSString stringWithFormat:@"￥%@",likeobjl[@"XJ"]] ;
        float yj = [likeobjl[@"LSDJ"] floatValue];
        NSString *yjs =[NSString stringWithFormat:@"￥%.2f",yj];
        NSLog(@"现价%@ 原价%@",likeobjl[@"XJ"],likeobjl[@"LSDJ"]);
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:yjs];
        NSUInteger length = [yjs length];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
         NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName
                      value:cell.rpriceLabel01.textColor range:NSMakeRange(0, length)];
        [cell.rpriceLabel01 setAttributedText:attri];
        [cell.lBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
       
        
       
        
        return cell;
    }
    else{
        NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        
     
        
        NSDictionary *tempdic = arydic[@"CartInfoList"][indexPath.row];
        if (tempdic[@"tis"]) {
            static NSString *CellIdentifier = @"MLBagActiveTableViewCell" ;
            MLBagActiveTableViewCell *cell = (MLBagActiveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            return cell;
        }
        else if (tempdic[@"zeng"])
        {
            static NSString *CellIdentifier = @"MLBagZengpinTableViewCell" ;
            MLBagZengpinTableViewCell *cell = (MLBagZengpinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            return cell;
        }
        else{
            static NSString *CellIdentifier = @"MLBagGoodsTableViewCell" ;
            MLBagGoodsTableViewCell *cell = (MLBagGoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
           
            
            [cell.productImgView sd_setImageWithURL:[NSURL URLWithString:tempdic[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
            cell.productNameLabel.text = tempdic[@"NAME"];
            NSString *sssl =tempdic[@"XSSL"];
            NSInteger spcount =sssl.integerValue;
            if (spcount<0) {
                spcount=0;
            }
            [cell.countLabel setTextValue:(int)spcount]; // TODO

            cell.countLabel.stepperDelegate = self;
            cell.countLabel.paramDic = tempdic;
            float pricef =[tempdic[@"LSDJ"] floatValue];
            cell.cellImageClick = ^(){
                
                if (!tempdic[@"tis"] && !tempdic[@"zeng"])
                {
                    
                    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
                    vc.paramDic = tempdic;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }

            };
            cell.priceLabel.text =[NSString stringWithFormat:@"￥%.2f",pricef] ;
            NSString *selbj = tempdic[@"SELBJ"];
            BOOL issel = [selbj boolValue];
            [cell.selBtn setSelected:issel];
            
            if (cell.selBtn.selected) { //如果是选中的加入到选中数组
                [selAry addObject:tempdic];
                
                NSInteger currentcount = cell.countLabel.value;
                totalSelShop = totalSelShop + (int)currentcount;
                totalSelPrice = totalSelPrice+pricef *currentcount;
                if (arydic[@"HWGCKDM"]) { //是否含有跨境购
                    
                    hasGlobalShop= YES;
//                    globalsection = globalsection+1;
                    totalGlobalPrice = totalGlobalPrice+ pricef*cell.countLabel.value;
//                    if ([arydic[@"HWGCKMC"] isEqualToString:@"正正仓"]) {
//                        zzccount =zzccount+1;
//                    }
                }
                else{
                    hasNormalShop = YES;
                }
            }
            objc_setAssociatedObject(cell.selBtn, "firstObject", tempdic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [cell.selBtn addTarget:self action:@selector(paysel:) forControlEvents:UIControlEventTouchUpInside];
            if (iseidtStatus) {
                cell.delBtn.hidden = NO;
            }
            else{
                cell.delBtn.hidden = YES;
            }
            objc_setAssociatedObject(cell.delBtn, "firstObject", tempdic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [cell.delBtn addTarget:self action:@selector(delShopping:) forControlEvents:UIControlEventTouchUpInside];
            
//            [self refreshFootView];
            return cell;
        }
    }
    

}


- (void)cellClick:(UIButton *)sender{
    NSInteger index = sender.tag;
    
}

#pragma mark 改变商品数量接口
- (void)changeShopCount:(NSDictionary*)paramdic count:(int)count {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=editnum&&ddly=%@&zcsp=%@&jmsp_id=%@&num=%d&userid=%@",SERVICE_GETBASE_URL,paramdic[@"DDLY"],paramdic[@"ZCSP"],paramdic[@"JMSP_ID"],count, userid];
    
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"改变商品数量：%@",result);
                                          [self loadDateOrLike];

//                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              [self downLoadOrdinaryBag:NO];
//                                          });
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    
    
}

#pragma 商品数量添加删除回调

- (void)addButtonClicked:(NSDictionary *)param count:(int)textCount
{
    [self changeShopCount:param count:textCount];
}
- (void)subButtonClicked:(NSDictionary *)param count:(int)textCount
{
    [self changeShopCount:param count:textCount];

}

#pragma 编辑删除购物车
-(void)delShopping:(id)sender
{
    
    UIButton *delbtn = (UIButton*)sender;
    delbtn.selected = !delbtn.selected;
    
    NSDictionary *firstobj = objc_getAssociatedObject(delbtn, "firstObject");
    
    [self deleteCart:firstobj];
    
}

#pragma 底部菜单全选
-(void)selectAllSectionGoods:(id)sender
{
    UIButton *selbtn = (UIButton*)sender;
    selbtn.selected = !selbtn.selected;
    for (int i =0; i<totalArray.count; i++) {
        NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%d",i]];
        if (arydic[@"CartInfoList"]) {
            NSArray *arrys = (NSArray*)arydic[@"CartInfoList"];
            NSMutableString *srty = [NSMutableString string];
            for (NSDictionary *dic in arrys) {
                NSString *jid = dic[@"JMSP_ID"];
                [srty appendString:jid];
                [srty appendString:@","];
            }
            
            if (srty.length>1) {
                NSString *jsids = [srty substringToIndex:srty.length-1];
                [self setShoppingCart:selbtn.selected spid:jsids];
            }
        }

    }
    
}

-(void)paysel:(id)sender
{
    UIButton *selbtn = (UIButton*)sender;
    selbtn.selected = !selbtn.selected;
    
    NSDictionary *firstobj = objc_getAssociatedObject(selbtn, "firstObject");
    if (selbtn.selected) {
        if (selAry.count>0) {
           BOOL isExist = [selAry containsObject:firstobj];
            if (!isExist) {
                [selAry addObject:firstobj];
            }
        }
    }
    else{
        if (selAry.count>0) {
           NSInteger i = [selAry indexOfObject:firstobj];
            if (i !=-1) {
                [selAry removeObjectAtIndex:i];
            }
        }
    }
    [self setShoppingCart:selbtn.selected spid:firstobj[@"JMSP_ID"]];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == totalArray.count) {
        return MAIN_SCREEN_WIDTH * 280/489 + 12;
    }else{
        NSDictionary * dic2 = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        NSArray *arr = dic2[@"CartInfoList"];
        NSDictionary *dic = arr[indexPath.row];
        if ([dic count] == 1) {
            if (dic[@"tis"]) {
                return 30;
            }else{
                return 40;
            }
        }else{
            return 105;
        }
    }
}

//设置头部的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == totalArray.count-1) {
        return 36.0f;
    }
    return 4;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == totalArray.count-1) {

        MLBagFootView *footView = [[MLBagFootView alloc]initWithReuseIdentifier:FOOTER_IDENTIFIER];
        footView.countToPay.backgroundColor = [HFSUtility hexStringToColor:@"AE8E5D"];
        footView.countToPay.tag = section;
        [footView.countToPay addTarget:self action:@selector(paymentAction:) forControlEvents:UIControlEventTouchUpInside];
        [footView.checkBtn addTarget:self action:@selector(selectAllSectionGoods:) forControlEvents:UIControlEventTouchUpInside];
        int selcount =0;
        int totalselcount =0;
        for (int i=0; i<totalArray.count; i++) {
            NSDictionary *tempDic = [totalArray objectForKey:[NSString stringWithFormat:@"%d",i]];

            NSArray *temparry = tempDic[@"CartInfoList"];
            if (temparry && temparry.count>0) {
                for (NSDictionary *tempdic in temparry) {
                    NSString *selbj = tempdic[@"SELBJ"];
                    BOOL issel = [selbj boolValue];
                    totalselcount++;
                    if (issel) {
                        selcount++;
                    }
                }
              
            }
        }
        if (selcount==totalselcount) {
            [footView.checkBtn setSelected:YES];
        }
        else{
            [footView.checkBtn setSelected:NO];
            
        }
        
        footView.totalPriceLB.text = [NSString stringWithFormat:@"￥%.2f元",totalSelPrice];
        footView.totalShopCount.text = [NSString stringWithFormat:@"共%d件商品",totalSelShop];

        return footView;
    }
    else{
        return nil;
 
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == totalArray.count) {
        HFSOrderListHeaderView *headerView = [[HFSOrderListHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER01];
        headerView.nameLabel.text = @"猜你喜欢";
        headerView.orderStatusLabel.hidden = YES;
        headerView.hidden = iseidtStatus;
        return headerView;
    }else{
        if (totalArray.count!=0) {
            MLBagHeaderView *headerView = [[MLBagHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER ];
            NSDictionary * dic2 = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",section]];
            
            headerView.checkBox.tag = section;
            
            if (dic2.allKeys.count>1) {
                [headerView.checkBox setTitle:[NSString stringWithFormat:@"  %@",dic2[@"HWGCKMC"]] forState:UIControlStateNormal];
                [headerView.checkBox setTitle:[NSString stringWithFormat:@"  %@",dic2[@"HWGCKMC"]] forState:UIControlStateSelected];
            }
            
            
            if ([dic2 objectForKey:@"HWGCKMC"]) {
                NSArray *arys = dic2[@"CartInfoList"];
                if (arys && arys.count>0) {
                    for (NSDictionary *tempdic in arys) {
                        NSString *selbj = tempdic[@"SELBJ"];
                        BOOL issel = [selbj boolValue];
                        if (issel) {
                            globalsection++;
                            break;
                        }
                    }
                }
            }
            
            NSArray *arys = dic2[@"CartInfoList"];
            int totalcount =0;
            if (arys && arys.count>0) {
                for (NSDictionary *tempdic in arys) {
                    NSString *selbj = tempdic[@"SELBJ"];
                    BOOL issel = [selbj boolValue];
                    if (issel) {
                        totalcount++;
                    
                    }
                }
                if (totalcount==arys.count) {
                    [headerView.checkBox setSelected:YES];
                }
                else
                {
                    [headerView.checkBox setSelected:NO];

                }
            }
            [headerView.checkBox addTarget:self action:@selector(selAllGoods:) forControlEvents:UIControlEventTouchUpInside];
            return headerView;

        }
        return nil;
    }
    
}

#pragma table头部全选
-(void)selAllGoods:(id)sender
{
    UIButton *selbtn = (UIButton*)sender;
    selbtn.selected = !selbtn.selected;
    NSInteger section = selbtn.tag;
    
    NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",section]];
    if (arydic[@"CartInfoList"]) {
        NSArray *arrys = (NSArray*)arydic[@"CartInfoList"];
        NSMutableString *srty = [NSMutableString string];
        for (NSDictionary *dic in arrys) {
            NSString *jid = dic[@"JMSP_ID"];
            [srty appendString:jid];
            [srty appendString:@","];
        }

        if (srty.length>1) {
            NSString *jsids = [srty substringToIndex:srty.length-1];
            [self setShoppingCart:selbtn.selected spid:jsids];
        }
    }
   
    
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
}

-(void)setShoppingCart:(int)selflag spid:(NSString*)spid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=selproductbath&flag=%i&jmsp_id=%@&ddly=0&ckdm=&userid=%@",SERVICE_GETBASE_URL, selflag,spid,userid];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"result is %@",result);
                                          if (![@"true" isEqualToString:result]) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = @"请求失败";
                                                  [_hud hide:YES afterDelay:2];
                                              });
                                              
                                             
                                          }
                                          else{
                                              sectionkey = 0;
                                              [totalArray removeAllObjects];
                                              
                                              
                                              [self downLoadOrdinaryBag:NO];

                                          }
                                         
                                      }
                                      
                                  }];
    
    [task resume];

    
    
    
}



//编辑的点击方法
- (void)editAction:(id)sender{
    UIBarButtonItem *btn = (UIBarButtonItem*)sender;
    iseidtStatus = !iseidtStatus;
    if (iseidtStatus) {
        [btn setTitle:@"完成"];

    }
    else{
        [btn setTitle:@"编辑"];
    }
    
    [_tableView reloadData];
}


@end

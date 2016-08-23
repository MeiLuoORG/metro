//
//  MLSureViewController.m
//  Matro
//
//  Created by NN on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSureViewController.h"
#import "MLListViewController.h"
#import "MLPayViewController.h"
#import "MLInvoiceViewController.h"
#import "MLAddressSelectViewController.h"
#import "SBJSON.h"
#import "HFSConstants.h"
#import "UIButton+HeinQi.h"
#import "HFSServiceClient.h"
#import <Foundation/NSZone.h>
#import "GTMNSString+URLArguments.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJExtension.h"
#import "MLOrderListModel.h"
#import "MLProductModel.h"


@interface MLSureViewController ()<InvoiceDelegate>
{
    NSString *userid;
    NSDictionary *defaultAddress;
    NSDictionary *makeinvoice;
    NSString *ddly; //是普通商品 还是海外购
    UIControl *_blackView;
    NSDictionary *orderDic;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rootW;

@property (strong, nonatomic) IBOutlet UITextField *shenfenzhengTextField;//身份证输入框
@property (strong, nonatomic) IBOutlet UIButton *shenfenzhengButton;//身份证按钮

@property (strong, nonatomic) IBOutlet UIButton *shangmenButton;//上门
@property (strong, nonatomic) IBOutlet UIButton *kuaidiButtton;//快递

@property (strong, nonatomic) IBOutlet UILabel *zitiLabel;//自提
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;//时间

@property (strong, nonatomic) IBOutlet UILabel *fapiaoLabel;//发票

@property (strong, nonatomic) IBOutlet UILabel *jineLabel;//金额
@property (strong, nonatomic) IBOutlet UILabel *youhuilabel;//优惠
@property (strong, nonatomic) IBOutlet UILabel *shuiLabel;//税
@property (strong, nonatomic) IBOutlet UILabel *yunfeiLabel;//运费

@property (strong, nonatomic) IBOutlet UILabel *fukuanLabel;//付款

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tH01;//是否是全球购 69 ：12
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tH02;//是否是上门 85 ：12

@property (strong, nonatomic) IBOutlet UIView *shenfenzBgView;//是否是全球购 显示隐藏
@property (strong, nonatomic) IBOutlet UIView *shangmenBgView;//是否是上门 显示隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalInvoiceViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *globalInvoiceViewHeight;

//最多显示3个商品图片
@property (strong, nonatomic) IBOutlet UIImageView *listImageView01;
@property (strong, nonatomic) IBOutlet UIImageView *listImageView02;
@property (strong, nonatomic) IBOutlet UIImageView *listImageView03;

@property (strong, nonatomic) IBOutlet UIView *addressInfoBgView;//有地址信息的时候显示这个地址信息的主视图
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong)MLInvoiceViewController *invoiceVc;

@property (nonatomic,strong)MLAddressSelectViewController *addressVc;


@end

@implementation MLSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认订单信息";
    
    [self sureUI];
    
    NSLog(@"%@",_paramDic);
    makeinvoice = @{@"invoiceFlag":@"0"};//默认不开发票
    
    
    //判断是否是全球购商品，如果是 发票信息隐藏
    if (_isGlobalShop) {
        
        _fapiaoLabel.text=@"全球购商品暂不支持开发票";
    }
    else{
        _fapiaoLabel.text = @"不开发票";
        self.shenfenzHeight.constant = 0;
        self.shenfenzBgView.hidden = YES;
        self.shuieHeight.constant = 0;
        self.shuiebgView.hidden = YES;
        
    }
    
    _datePicker.hidden = YES;
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 250)];
    [_blackView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    
    
    NSArray *imgary = @[_listImageView01,_listImageView02,_listImageView03];
    if (self.isfromdetail) {
        self.totalShoppingLabel.text = @"1件商品";
        int i=0;
        for (NSDictionary *tempdic in _shopsary) {
           
            if (i==2) {
                break;
            }
            UIImageView *imgview = imgary[i];
            
            if ([tempdic[@"URL"] hasSuffix:@"webp"]) {
                [imgview setZLWebPImageWithURLStr:tempdic[@"URL"] withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                [imgview sd_setImageWithURL:[NSURL URLWithString:tempdic[@"URL"]] placeholderImage:PLACEHOLDER_IMAGE];
            }
            i++;
        }
    }
    else{
        int i=0;
        int totalshopcount =0;
        for (NSDictionary *dic in _shopsary) {
            NSString *count = dic[@"XSSL"];
            totalshopcount = totalshopcount+count.intValue;
        }
        
        self.totalShoppingLabel.text = [NSString stringWithFormat:@"共%d 件商品",totalshopcount];
        if (totalshopcount>3) {
            self.totalShoppingLabel.text = [NSString stringWithFormat:@"...共%d 件商品",totalshopcount];
            
        }
        for (NSDictionary *tempdic in _shopsary) {
            if (i==2) {
                break;
            }
            UIImageView *imgview = imgary[i];
           
            if ([tempdic[@"IMGURL"] hasSuffix:@"webp"]) {
                [imgview setZLWebPImageWithURLStr:tempdic[@"IMGURL"] withPlaceHolderImage:PLACEHOLDER_IMAGE];
            } else {
                 [imgview sd_setImageWithURL:[NSURL URLWithString:tempdic[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
            }
            NSString *count = tempdic[@"XSSL"];
            if (count.intValue>1 ) {
                for (int m=1; m<count.intValue; m++) {
                   
                    if (m>2) {
                        break;
                    }
                    UIImageView *imgview = imgary[m];
                    
                    
                    if ([tempdic[@"IMGURL"] hasSuffix:@"webp"]) {
                        [imgview setZLWebPImageWithURLStr:tempdic[@"IMGURL"] withPlaceHolderImage:PLACEHOLDER_IMAGE];
                    } else {
                        [imgview sd_setImageWithURL:[NSURL URLWithString:tempdic[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
                    }
                    
                }
            }
            
            
            i++;
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    [self loadDateAddressList];
    ddly = @"0";
    
    _addressVc = [[MLAddressSelectViewController alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _rootW.constant = MAIN_SCREEN_WIDTH;
}

#pragma 选择地址后返回
- (void)AddressDic:(NSDictionary *)dic
{
    self.addressInfoBgView.hidden = NO;

    defaultAddress = dic;
    _nameLabel.text = defaultAddress[@"SHRMC"];
    _phoneLabel.text = defaultAddress[@"SHRMPHONE"];
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",defaultAddress[@"SFNAME"],defaultAddress[@"SHRADDRESS"]];
    
    
    self.fukuanLabel.text = @"";
    self.yunfeiLabel.text = @"";
    self.jineLabel.text = @"";
    
    [self jiesuanOrder];
}
- (IBAction)saveShengfenzheng:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"保存"]) {
        if (self.shenfenzhengTextField.text.length != 18) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请正确输入身份证号码";
            [_hud hide:YES afterDelay:2];
            [self.shenfenzhengTextField becomeFirstResponder];
            return;
        }
        
        [self.view endEditing:YES];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    else{
        [self.shenfenzhengTextField becomeFirstResponder];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
    }
    
    
    
}
#pragma mark 获取收货地址清单
- (void)loadDateAddressList {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=getshdzlist&userid=%@",SERVICE_GETBASE_URL,userid];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(responseObject)
        {
            NSArray *array = (NSArray *)responseObject;
            if (array && array.count>0) {
                BOOL hasDefault = NO;
                for (NSDictionary *tempdic in array) {
                    if ([@"1" isEqualToString:tempdic[@"MRSHRBJ"]] ) { //默认选项
                        defaultAddress = tempdic;
                        _nameLabel.text = tempdic[@"SHRMC"];
                        _phoneLabel.text = tempdic[@"SHRMPHONE"];
                        _addressLabel.text = [NSString stringWithFormat:@"%@%@",tempdic[@"SFNAME"],tempdic[@"SHRADDRESS"]];
                        hasDefault = YES;
                        [self jiesuanOrder];
                        break;
                    }
                }
                if (!hasDefault) {
                    self.addressInfoBgView.hidden = YES;
                }
            }
            else{
                self.addressInfoBgView.hidden = YES;
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

#pragma 结算订单的接口，需要根据地址变化请求
-(void)jiesuanOrder
{
    
    int ddlyparam=0;
    if (_isGlobalShop) {
        ddlyparam = 5; //境外购
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/ordersubmit.ashx?op=JieSuanInfo&ddly=%d&psqy=%@&psgs=1&psfs=0&userid=%@",SERVICE_GETBASE_URL,ddlyparam,defaultAddress[@"SHRSF"]?:@"",userid];
    
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
                                          result = [result substringWithRange:NSMakeRange(1, result.length-2)];
                                          result = [result stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                          NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                                          NSError *err;
                                          orderDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                               options:NSJSONReadingMutableContainers
                                                                                                 error:&err];
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              self.fukuanLabel.text = [NSString stringWithFormat:@"￥%@元",orderDic[@"zje"] ];
                                              float yunfei = [orderDic[@"yunfei"] floatValue];
                                              float jine = [orderDic[@"spje"] floatValue];
                                              self.yunfeiLabel.text = [NSString stringWithFormat:@"￥%.2f元",yunfei];
                                              self.jineLabel.text = [NSString stringWithFormat:@"￥%.2f元",jine];
                                              if (_isGlobalShop) {
                                                  float hwgsj =[orderDic[@"hwgsj"] floatValue];
                                                  self.shuiLabel.text =[NSString stringWithFormat:@"￥%.2f元",hwgsj];
                                              }

                                          });

                                          
                                          self.shuiLabel.text = [NSString stringWithFormat:@"￥%@",orderDic[@"hwgsj"]];
                                      }
                                      
                                  }];
    
    [task resume];
}


#pragma 生成订单 支付接口前一步
-(void)orderCreate:(NSDictionary*)paramdic
{
    
    if (!defaultAddress) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请选择收货地址";
        [_hud hide:YES afterDelay:2];
    }
    
    if (_isGlobalShop) {
        
        if ([@"" isEqualToString:self.shenfenzhengTextField.text]) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"因涉及全球购商品，请填写收货人身份证";
            [_hud hide:YES afterDelay:2];
            return;
        }
        
        if (self.shenfenzhengTextField.text.length != 18) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请正确输入身份证号码";
            [_hud hide:YES afterDelay:2];
            return;
        }
    }

    
    SBJSON *sbjson = [SBJSON new];
    NSString *dhfsstr = @"手机订单";
    //shrxx=地址详情 zfxx={paymentMode}
    NSDictionary *zfxxdic = @{@"paymentMode":@"1"};
    NSError *error;
    NSString *zfxstr = [sbjson stringWithObject:zfxxdic error:&error];
    zfxstr = [zfxstr gtm_stringByEscapingForURLArgument];
    
//    NSLog(@"address %@",defaultAddress);
    
    NSString *invoicestr = [sbjson stringWithObject:makeinvoice error:&error];
    invoicestr = [invoicestr gtm_stringByEscapingForURLArgument];
    
    NSDictionary *addressdic = @{@"consigneeName":defaultAddress[@"SHRMC"]?:@"",@"consigneeRegion":defaultAddress[@"SHRSF"]?:@"",@"consigneeAddress":[NSString stringWithFormat:@"%@%@",defaultAddress[@"SFNAME"]?:@"",defaultAddress[@"SHRADDRESS"]?:@""],@"consigneeMPhone":defaultAddress[@"SHRMPHONE"]?:@"",@"consigneePhone":defaultAddress[@"SHRPHONE"]?:@"",@"consigneeSfzhm":defaultAddress[@"SFZHM"]?:@""};
//
    
    
    NSString *shrxxstr = [sbjson stringWithObject:addressdic error:&error];
    shrxxstr = [shrxxstr gtm_stringByEscapingForURLArgument];
    NSDictionary *psxxdic = @{@"DeliveryMode":@"0"}; //配送方式
    NSString *psxxstr = [sbjson stringWithObject:psxxdic error:&error];
    psxxstr = [psxxstr gtm_stringByEscapingForURLArgument];
    dhfsstr = [dhfsstr gtm_stringByEscapingForURLArgument];
    int ddlyparam=0;
    if (_isGlobalShop) {
        ddlyparam = 5; //境外购
    }
     NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/ordersubmit.ashx?op=submit&dhfs=%@&shrxx=%@&zfxx=%@&psxx=%@&fpxx=%@&bz=&ddly=%d&userid=%@",SERVICE_GETBASE_URL,dhfsstr,shrxxstr,zfxstr,psxxstr,invoicestr,ddlyparam,userid];
    
    NSLog(@"%@",urlStr);
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject) {
                    NSDictionary *reponsestr = (NSDictionary*)responseObject;
                    NSString *isok = (NSString*)reponsestr[@"SuccFlag"];
                    BOOL okl = [isok boolValue];
                    NSLog(@"ok %i",okl);
                    NSLog(@"%@",responseObject);
                    if (okl) {
                        NSString *backobj = reponsestr[@"BackObject"];
                        NSString *odernum =  [backobj componentsSeparatedByString:@"jlbh="][1];
                        // 跳转到支付页面
                            MLPayViewController *vc = [[MLPayViewController alloc]init];
                            vc.isGlobal = _isGlobalShop;
                            vc.paramDic = @{@"totalFee":orderDic[@"zje"],@"order_trade_no":odernum};
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    else{
                        [_hud show:YES];
                        _hud.mode = MBProgressHUDModeText;
                        _hud.labelText = reponsestr[@"ErrorMsg"];
                        [_hud hide:YES afterDelay:2];
                    }
        
                }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}

-(NSMutableDictionary*) describeDictionary: (NSDictionary*)dict
{
    NSArray *keys;
    NSInteger i, count;
    NSString *key, *value;
    
    keys = [dict allKeys];
    count = [keys count];
    NSMutableDictionary *newdic = [[NSMutableDictionary alloc] init];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
        value =  [value gtm_stringByEscapingForURLArgument];
        [newdic setObject:value forKey:key];
        
        
    }
    return newdic;
}


- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    
    return
    outputStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sureUI{
    [_kuaidiButtton peisongButtonType];
    [_shangmenButton peisongButtonType];
    _kuaidiButtton.selected = YES;
    _shangmenButton.selected = NO;
    _tH02.constant = 12;
    _shangmenBgView.hidden = YES;
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark- 配送方式
- (IBAction)peisongButtonAction:(id)sender {
    
    UIButton *button = ((UIButton *)sender);
    
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    
    if ([button isEqual:_shangmenButton]) {
        _kuaidiButtton.selected = NO;
        
        _shangmenBgView.hidden = NO;
        _tH02.constant = 85;
    }else{
        _shangmenButton.selected = NO;
        
        _shangmenBgView.hidden = YES;
        _tH02.constant = 12;
    }
    
}

#pragma mark- 地址
- (IBAction)dizhiAction:(id)sender {
//    MLAddressListViewController *vc = [[MLAddressListViewController alloc]init];
//    vc.delegate = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.addressVc animated:YES];
}

#pragma mark- 去支付
- (IBAction)payButtonAction:(id)sender {
    
    [self orderCreate:nil];
    
    
}

#pragma mark- 去商品清单
- (IBAction)surelistAction:(id)sender {
    MLListViewController *vc = [[MLListViewController alloc]init];
    MLOrderListModel *model = [[MLOrderListModel alloc]init];
    int totalshopcount =0;
    NSLog(@"%@",_shopsary);
    for (NSDictionary *dic in _shopsary) {
        NSString *count = dic[@"XSSL"];
        totalshopcount = totalshopcount+count.intValue;
    }
    model.PRODUCTLIST = [MLProductModel mj_objectArrayWithKeyValuesArray:_shopsary];
    vc.count = totalshopcount;
    vc.orderDetail = model;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)invoiceAction:(id)sender {
    /*
     需要判断是否是全球购
     是否开具发票
     */
    
//    if ([_fapiaoLabel.text isEqualToString:@"全球购商品暂不支持开发票"]) {
//        return;
//    }
    
    
//    MLInvoiceViewController *vc = [[MLInvoiceViewController alloc]init];
//    vc.delegate = self;
//    
//    if ([_fapiaoLabel.text isEqualToString:@"不开发票"]) {
//        vc.isNeed = NO;
//    }else{
//        vc.isNeed = YES;
//    }
//    
//    
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- InvoiceDelegate
- (void)InvoiceDic:(NSDictionary *)dic{

    if ([dic[@"invoice"] isEqualToString:@"YES"]) {
        makeinvoice = @{@"invoiceFlag":@"1",@"invoiceLx":@"0",@"invoiceType":@"0",@"invoiceTitle":dic[@"titleText"],@"invoiceContent":@"明细"};

        _fapiaoLabel.text = [NSString stringWithFormat:@"普通发票     %@     明细",dic[@"titleText"]];
    }else{
        _fapiaoLabel.text = @"不开发票";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editAdressAction:(id)sender {
//    MLAddressListViewController *vc = [[MLAddressListViewController alloc]init];
//    vc.delegate = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.addressVc animated:YES];
}
- (IBAction)selInvoiceAction:(id)sender {
    
    if (!_isGlobalShop) {
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:self.invoiceVc animated:YES];
    }
    
    
}

- (IBAction)cancelButtonAction:(id)sender {
    _blackView.hidden = _datePicker.hidden = YES;
}

- (IBAction)sureButtonAction:(id)sender {
    _datePicker.hidden = YES;
    _blackView.hidden = YES;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM-dd"];
    _timeLabel.text = [df stringFromDate:_datePicker.date];
    
}

- (IBAction)datePickAction:(id)sender {
    _datePicker.hidden = NO;
    _blackView.hidden = NO;
}

- (MLInvoiceViewController *)invoiceVc{
    if (!_invoiceVc) {
        _invoiceVc = [[MLInvoiceViewController alloc]init];
        _invoiceVc.delegate = self;
        
    }
    return _invoiceVc;
}


@end

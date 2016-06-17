//
//  MLAddressInfoViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddressInfoViewController.h"
#import "HFSConstants.h"
#import "UIColor+HeinQi.h"
#import "SBJSON.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MLShippingaddress.h"
#import "MJExtension.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD+Add.h"

@interface MLAddressInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIControl *_blackView;
    
    //省市区的数组，解析的是本地的json
    
    
    NSArray * jsonObj;
    NSString *userid;
    NSString *selcode;
    int isdefault;
}
@property (strong, nonatomic) IBOutlet UIView *sBgView;
@property (strong, nonatomic) IBOutlet UIButton *sOn;
@property (strong, nonatomic) IBOutlet UIButton *sOff;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rH;
@property (strong, nonatomic) IBOutlet UIView *pickerRootView;
@property (strong, nonatomic) IBOutlet UIPickerView *addressPickerView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *selTextField;
@property (strong, nonatomic) IBOutlet UILabel *tisLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic,strong)NSMutableArray *addressData;


@end


static MLShippingaddress *province,*city,*area;


@implementation MLAddressInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    [self notDefault];
    if (_isNewAddress) {
        self.title = @"新增收货地址";
        isdefault = 1;
        
    }else{
        self.title = @"编辑收货地址";
        self.nameTextField.text = self.addressDetail.name;
        
        self.phoneTextField.text = self.addressDetail.mobile;
        
        self.inputTextField.text = self.addressDetail.address;
        
        self.selTextField.text = self.addressDetail.area;
        
    }
    
    
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [save setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:save];
    
    
    
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT -  224)];
    [_blackView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];

    [self getAllarea];
    
    
//    NSString *string = [[NSString alloc]initWithContentsOfFile:[self getDocumentpath] encoding:NSUTF8StringEncoding error:nil];
//    if (!string) {
//        [self getAllarea];
//    }
//    else{
//        SBJSON *sbjson = [SBJSON new];
//        NSArray *ary = [sbjson objectWithString:string error:nil];
//        
//        NSArray *modelArt = [MLShippingaddress mj_objectArrayWithKeyValuesArray:ary];
//        self.addressData = [modelArt mutableCopy];
//        
//        province = [self.addressData firstObject];
//        if (province.sub.count>0) {
//            city = [province.sub firstObject];
//            if (city.sub.count>0) {
//                [city.sub firstObject];
//            }
//        }
//        [self.addressPickerView reloadAllComponents];
//
//    }
    
}
-(NSString*)getDocumentpath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Area.json"]];
    return filePath;
}




-(void)getAllarea
{
    [[HFSServiceClient sharedJSONClientNOT] GET:[NSString stringWithFormat:@"%@/api.php?m=member&s=admin_orderadder&do=dis",@"http://bbctest.matrojp.com"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            NSArray *district_info = [MLShippingaddress mj_objectArrayWithKeyValuesArray:data[@"district_info"]];
//            for (MLShippingaddress *parent in district_info) {
//                if ([parent.pid isEqualToString:@"0"]) {
//                    parent.sub = [self getsub:district_info pid:parent.ID];
//                    [self.addressData addObject:parent];
//                }
//            }
            //缓存本地
//            NSArray *tmp = [MLShippingaddress mj_keyValuesArrayWithObjectArray:district_info];
//            NSLog(@"%@",tmp);
//            SBJSON *sbjson = [SBJSON new];
//            NSError *error;
//            NSString *jsonstr = [sbjson stringWithObject:tmp error:&error];
//            if (jsonstr) {
//                [jsonstr writeToFile:[self getDocumentpath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
//            }
            
            [self.addressData addObjectsFromArray:district_info];
            province = [self.addressData firstObject];
            if (province.sub.count>0) {
                city = [province.sub firstObject];
                if (city.sub.count>0) {
                    [city.sub firstObject];
                }
            }
            [self.addressPickerView reloadAllComponents];
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


//- (NSArray *)getsub:(NSArray *)allAddress pid:(NSString *)pid{
//    NSMutableArray *tmp = [NSMutableArray array];
//    for (MLShippingaddress *address in allAddress) {
//        if ([address.pid isEqualToString:pid]) {
//            address.sub = [self getsub:allAddress pid:address.ID];
//            [tmp addObject:address];
//        }
//    }
//    return [tmp copy];
//}




- (void)viewWillAppear:(BOOL)animated{
    _rH.constant = MAIN_SCREEN_HEIGHT - 64;
    _rW.constant = MAIN_SCREEN_WIDTH;
}


- (IBAction)selAddressButtonAction:(id)sender {
    [self.view endEditing:YES];
    _blackView.hidden = _pickerRootView.hidden = NO;
}

- (IBAction)cancelButtonAction:(id)sender {
    _blackView.hidden = _pickerRootView.hidden = YES;
}

- (IBAction)addressSureButtonAction:(id)sender {
    _pickerRootView.hidden = YES;
    _blackView.hidden = YES;

    
    NSString *address = [NSString stringWithFormat:@"%@%@%@",province?province.name:@"",city?city.name:@"",area?area.name:@""];
    _selTextField.text = address;
    
}

- (IBAction)sButtonAction:(id)sender {
    
    
    if (_sOn.selected) {
        [self notDefault];
    }else{
        [self isonDefault];
    }
    if (_sOn.selected) {
        isdefault = 1;

    }
    else{
        isdefault = 0;

    }
}

-(void)notDefault
{
    _sOn.selected = NO;
    _sOff.selected = YES;
    _sOn.backgroundColor = [UIColor clearColor];
    _sOff.backgroundColor = [UIColor whiteColor];
    _sBgView.backgroundColor = [UIColor grayColor];
    _tisLabel.hidden = YES;
}

-(void)isonDefault
{
    _sOn.selected = YES;
    _sOff.selected = NO;
    _sOn.backgroundColor = [UIColor whiteColor];
    _sOff.backgroundColor = [UIColor clearColor];
    _sBgView.backgroundColor = [UIColor colorWithHexString:@"AE8E5D"];
    
    _tisLabel.hidden = NO;
}



//保存使用新地址
- (IBAction)sureButtonAction:(id)sender {
    self.title = @"编辑收货地址";
    if ([self.nameTextField.text isEqualToString:@""]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"姓名不能为空";
        [_hud hide:YES afterDelay:1];
        return;
    }
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"电话号码不能为空";
        [_hud hide:YES afterDelay:1];
        return;

    }
    if ([self.inputTextField.text isEqualToString:@""]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"详细地址不能为空";
        [_hud hide:YES afterDelay:1];
        return;

    }
//    NSString *loginid = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    
     NSString  *urlStr = [NSString stringWithFormat:@"%@api.php?m=member&s=admin_orderadder&do=%@",@"http://bbctest.matrojp.com/",_isNewAddress?@"add":@"upd"];
    
    NSDictionary *params = @{@"uid":@"21357",@"data[name]":self.nameTextField.text,@"data[areaid]":area.ID,@"data[area]":self.selTextField.text,@"data[address]":self.inputTextField.text,@"data[provinceid]":province.ID,@"data[cityid]":city.ID,@"data[mobile]":self.phoneTextField.text};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) { //添加成功
            if (self.addressSuccess) {
                self.addressSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *msg = result[@"msg"];
            
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD showMessag:@"网络错误!" toView:self.view];
    }];
    
    
    
    
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {

    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    _bH.constant = kbHeight;
    
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    _bH.constant = 0;
}

#pragma mark- UIPickerViewDataSource and UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    
    switch (component) {
        case 0:
            return self.addressData.count;
            break;
        case 1:
            return province.sub.count;
            break;
        default:
        {
            return city.sub.count;;
        }
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
        {
            MLShippingaddress *add = [self.addressData objectAtIndex:row];
            return add.name;
        }
            break;
        case 1:
        {
            MLShippingaddress *tt = [province.sub objectAtIndex:row];
            return tt.name;
        }
           
            break;
        default:
        {
            MLShippingaddress *tt = [city.sub objectAtIndex:row];
            return tt.name;
        }
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            province = [self.addressData objectAtIndex:row];
            [self.addressPickerView reloadComponent:1];
            if (province.sub.count>0) {
                city = [province.sub firstObject];
                [_addressPickerView selectRow:0 inComponent:1 animated:YES];
                if (city.sub.count>0) {
                    [self.addressPickerView reloadComponent:2];
                    area = [city.sub firstObject];
                    [_addressPickerView selectRow:0 inComponent:2 animated:YES];
                }
            }
              [_addressPickerView reloadComponent:2];
            break;
        case 1:
            city = [province.sub objectAtIndex:row];
            [self.addressPickerView reloadComponent:2];
            if (city.sub.count>0) {
                area = [city.sub firstObject];
                [_addressPickerView selectRow:0 inComponent:2 animated:YES];
            }

            break;
        case 2:
            area = [city.sub objectAtIndex:row];
            break;
        default:
            
            break;
    }
}

- (NSMutableArray *)addressData{
    if (!_addressData) {
        _addressData = [NSMutableArray array];
    }
    return _addressData;
}




@end

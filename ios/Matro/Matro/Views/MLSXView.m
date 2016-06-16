//
//  MLSXView.m
//  Matro
//
//  Created by NN on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSXView.h"
#import "UIColor+HeinQi.h"
#import "RADataObject.h"
#import "HFSPriceDataObject.h"
#import <RATreeView/RATreeView.h>
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"


#define PriceCellIdentifier @"PriceCellIdentifier"

@interface MLSXView()<RATreeViewDataSource, RATreeViewDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    
    //品牌分类相关数组，用treeview显示
//    NSMutableArray *_dataArray;
    RADataObject *_selectedItem;
    RADataObject *_selectedPP;
    
    NSMutableArray *ppArray;
    NSMutableArray *spArray;
    NSString *maxprice;
    
    
    
    //价格的数组，用tableview显示
    NSMutableArray *_priceArray;
    NSIndexPath *_selectedIndexPath;
    UITableView * _tableView;
    UITextField *fromPriceTextField;
    UITextField *toPriceTextField;
    NSNumber *_minPrice;
    NSNumber *_maxPrice;
    NSIndexPath *_selectAllIndexPath;
    NSIndexPath *_customIndexPath;
    NSIndexPath *_selectMoreIndexPath;
    NSMutableDictionary *paramfilterDic;
    
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIView *titleButtonBgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cleanButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *subsureButton;

@property (strong, nonatomic) IBOutlet UIView *sxRootView;
@property (strong, nonatomic) IBOutlet UIView *shaixuanNextView;

@property (strong, nonatomic) IBOutlet UIButton *quanqiugouButton;
@property (strong, nonatomic) IBOutlet UIButton *cuxiaoButton;
@property (strong, nonatomic) IBOutlet UIButton *youhuoButton;

@property (strong, nonatomic) IBOutlet UILabel *fenlei;
@property (strong, nonatomic) IBOutlet UILabel *jiage;
@property (strong, nonatomic) IBOutlet UILabel *pinpai;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bh;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet RATreeView *treeView;
@end

static BOOL selectPP = NO;

@implementation MLSXView

- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithUTF8String:object_getClassName(self)] owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //初始化背景视图，添加手势
        self.frame = frame ;
        self.userInteractionEnabled = YES;
        
        _treeView.delegate = self;
        _treeView.dataSource = self;
        _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
        [_treeView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TypeCellIdentifier"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PriceCellIdentifier];
        
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //设置特殊选择项，全部、大于10000、自定义
        _selectAllIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _customIndexPath = [NSIndexPath indexPathForRow:_priceArray.count-1 inSection:0];
        _selectMoreIndexPath = [NSIndexPath indexPathForRow:_priceArray.count-2 inSection:0];
        paramfilterDic = [[NSMutableDictionary alloc] init];
        
        
        fromPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(20.0f, 9.0f, 80.0f, 30.0f)];
        fromPriceTextField.background = [UIImage imageNamed:@"price_input_box"];
        fromPriceTextField.textAlignment = NSTextAlignmentCenter;
        fromPriceTextField.placeholder = @"起始价格";
        fromPriceTextField.keyboardType = UIKeyboardTypeNumberPad;
        fromPriceTextField.delegate = self;
        
        toPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(127.0f, 9.0f, 80.0f, 30.0f)];
        toPriceTextField.background = [UIImage imageNamed:@"price_input_box"];
        toPriceTextField.textAlignment = NSTextAlignmentCenter;
        toPriceTextField.placeholder = @"终止价格";
        toPriceTextField.keyboardType = UIKeyboardTypeNumberPad;
        toPriceTextField.delegate = self;
        
        ppArray = [NSMutableArray array];
        
        RADataObject *ppAll = [RADataObject dataObjectWithId:@0 name:@"不限" children:nil];
        ppAll.level = @0;
        
        [ppArray addObject:ppAll];
        
        
        spArray = [NSMutableArray array];
        
        RADataObject *spAll = [RADataObject dataObjectWithId:@0 name:@"不限" children:nil];
        spAll.level = @0;
        
        [spArray addObject:spAll];
        
    }
    self.quanqiugouButton.layer.cornerRadius = 4.f;
    self.quanqiugouButton.layer.masksToBounds = YES;
    self.quanqiugouButton.layer.borderWidth = 1.f;
    self.quanqiugouButton.layer.borderColor = RGBA(241, 241, 241, 1).CGColor;
    self.cuxiaoButton.layer.cornerRadius = 4.f;
    self.cuxiaoButton.layer.masksToBounds = YES;
    self.cuxiaoButton.layer.borderWidth = 1.f;
    self.cuxiaoButton.layer.borderColor = RGBA(241, 241, 241, 1).CGColor;
    self.youhuoButton.layer.cornerRadius = 4.f;
    self.youhuoButton.layer.masksToBounds = YES;
    self.youhuoButton.layer.borderWidth = 1.f;
    self.youhuoButton.layer.borderColor = RGBA(241, 241, 241, 1).CGColor;
    self.sureButton.layer.cornerRadius = 4.f;
    self.sureButton.layer.masksToBounds = YES;
    self.subsureButton.layer.cornerRadius = 4.f;
    self.subsureButton.layer.masksToBounds = YES;
    
    
    

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    _bh.constant = kbHeight - 100;//底部按钮已经抵掉100
    
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    _bh.constant = 0;
}

#pragma mark 获取筛选条件
//品牌
-(void)loadretBrand{
    //商品筛选（分类，品牌，价格）
    //    http://bbctest.matrojp.com/api.php?m=product&s=filter&key=水&brandid=1853&searchType=1
    //    "key : 产品搜索关键字
    //    brandid: 品牌id (可为空)
    //    searchType:搜索类型  ( 如果有关键字搜索, searchType 是必传参数 , 1  )
    //    { ""code"" : ""0 表示查询成功"",""retbrand"" : 品牌查询结果集,""countbrand"" : ""品牌查询结果集条数"",""retcat"" : 分类查询结果集,""countcat"" : ""分类查询结果条数"",""maxprice"":""商品按条件查询最大价格""}"
    
    NSString *keystr = [self.keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",keystr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=filter&key=%@&brandid=&searchType=1",   @"http://bbctest.matrojp.com",keystr];
    
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject ====%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *result = dataDic[@"retbrand"];
        NSLog(@"result=111=%@",result);
        
        
        if (result) {
            for (NSDictionary *temp in result) {
                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:temp[@"id"] name:temp[@"name"] children:nil];
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:1];
                itemAll.selected = NO;
                [ppArray addObject:itemAll];
            }
            [_treeView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        
    }];
}

/*
- (void)loadBrand:(NSString*)urlStr
{
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *result = (NSArray *)responseObject;
        NSLog(@"%@",result);
        if (result) {
            for (NSDictionary *temp in result) {
                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:temp[@"SBID"] name:temp[@"NAME"] children:nil];
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:1];
                itemAll.selected = NO;
                [ppArray addObject:itemAll];
            }
            [_treeView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"价格筛选 请求失败");
        
    }];
}
*/

//价格
-(void)loadmaxPrice{
    //商品筛选（分类，品牌，价格）
    //    http://bbctest.matrojp.com/api.php?m=product&s=filter&key=水&brandid=1853&searchType=1
    //    "key : 产品搜索关键字
    //    brandid: 品牌id (可为空)
    //    searchType:搜索类型  ( 如果有关键字搜索, searchType 是必传参数 , 1  )
    //    { ""code"" : ""0 表示查询成功"",""retbrand"" : 品牌查询结果集,""countbrand"" : ""品牌查询结果集条数"",""retcat"" : 分类查询结果集,""countcat"" : ""分类查询结果条数"",""maxprice"":""商品按条件查询最大价格""}"
    NSMutableDictionary *priceDic1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *priceDic2 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *priceDic3 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *priceDic4 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *priceDic5 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *priceDic6 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *priceDic7 = [[NSMutableDictionary alloc]init];
    
    [priceDic1 setObject:@"0" forKey:@"jgs"];
    [priceDic1 setObject:@"100" forKey:@"jge"];
    [priceDic2 setObject:@"101" forKey:@"jgs"];
    [priceDic2 setObject:@"500" forKey:@"jge"];
    [priceDic3 setObject:@"501" forKey:@"jgs"];
    [priceDic3 setObject:@"1000" forKey:@"jge"];
    [priceDic4 setObject:@"1001" forKey:@"jgs"];
    [priceDic4 setObject:@"2000" forKey:@"jge"];
    [priceDic5 setObject:@"2001" forKey:@"jgs"];
    [priceDic5 setObject:@"5000" forKey:@"jge"];
    [priceDic6 setObject:@"5001" forKey:@"jgs"];
    [priceDic6 setObject:@"10000" forKey:@"jge"];
    [priceDic7 setObject:@"10001" forKey:@"jgs"];
    [priceDic7 setObject:@"20000" forKey:@"jge"];
    
    
    _priceArray = [[NSMutableArray alloc ] initWithObjects:@"不限", @"自定义", nil];
    NSString *keystr = [self.keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",keystr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=filter&key=%@&brandid=&searchType=1",   @"http://bbctest.matrojp.com",keystr];
    
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject ====%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        maxprice = dataDic[@"maxprice"];
        NSLog(@"maxprice=333=%@",maxprice);
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        if ([maxprice floatValue] <= 100) {            
//            startprice = @"0";
//            endprice = @"100";
//            NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
//            NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
//            HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
//            [_priceArray insertObject:tempPriceDataObject.description atIndex:1];
            [array addObject:priceDic1];
    
        }else if ([maxprice floatValue] > 100 && [maxprice floatValue] <= 500){
//            startprice = @"101";
//            endprice = @"500";
//            NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
//            NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
//            HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
//            [_priceArray insertObject:tempPriceDataObject.description atIndex:2];
            [array addObject:priceDic1];
            [array addObject:priceDic2];

            
        }else if ([maxprice floatValue] > 500 && [maxprice floatValue] <= 1000){
//            startprice = @"501";
//            endprice = @"1000";
//            NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
//            NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
//            HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
//            [_priceArray insertObject:tempPriceDataObject.description atIndex:3];
            [array addObject:priceDic1];
            [array addObject:priceDic2];
            [array addObject:priceDic3];
            
        }else if ([maxprice floatValue] > 1000 && [maxprice floatValue] <= 2000){
//            startprice = @"1001";
//            endprice = @"2000";
//            NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
//            NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
//            HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
//            [_priceArray insertObject:tempPriceDataObject.description atIndex:4];
            [array addObject:priceDic1];
            [array addObject:priceDic2];
            [array addObject:priceDic3];
            [array addObject:priceDic4];
            
        }else if ([maxprice floatValue] > 2000 && [maxprice floatValue] <= 5000){
//            startprice = @"2001";
//            endprice = @"5000";
//            NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
//            NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
//            HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
//            [_priceArray insertObject:tempPriceDataObject.description atIndex:5];
            [array addObject:priceDic1];
            [array addObject:priceDic2];
            [array addObject:priceDic3];
            [array addObject:priceDic4];
            [array addObject:priceDic5];
            
        }else if ([maxprice floatValue] > 5000 && [maxprice floatValue] <= 10000){
//            startprice = @"5001";
//            endprice = @"10000";
//            NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
//            NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
//            HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
//            [_priceArray insertObject:tempPriceDataObject.description atIndex:6];
            [array addObject:priceDic1];
            [array addObject:priceDic2];
            [array addObject:priceDic3];
            [array addObject:priceDic4];
            [array addObject:priceDic5];
            [array addObject:priceDic6];
            
        }else {
//            startprice = @"10001";
//            endprice = @"20000";
//            NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
//            NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
//            HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
//            [_priceArray insertObject:tempPriceDataObject.description atIndex:7];
            [array addObject:priceDic1];
            [array addObject:priceDic2];
            [array addObject:priceDic3];
            [array addObject:priceDic4];
            [array addObject:priceDic5];
            [array addObject:priceDic6];
            [array addObject:priceDic7];
            
        }
        NSLog(@"array === %@",array);
        if (array && array.count>0) {
            int i=1;
            for (NSDictionary *temp in array) {
                NSString *startprice = temp[@"jgs"];
                NSString *endprice = temp[@"jge"];
                NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
                NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
                HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
                [_priceArray insertObject:tempPriceDataObject.description atIndex:i];
                i++;
            }
        [self.tableView reloadData];
        }
        NSLog(@"请求成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"价格筛选 请求失败");
        
    }];
    
}

/*
- (void)loadDatePrice {
    _priceArray = [[NSMutableArray alloc ] initWithObjects:@"全部", @"自定义", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.matrojp.com/Ajax/search/search.ashx?op=jgcount&spflcode=%@&jgcount=5",self.spflCode?:@""];
    
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        if (array && array.count>0) {
            int i=1;
            for (NSDictionary *temp in array) {
                NSString *startprice = temp[@"jgs"];
                NSString *endprice = temp[@"jge"];
                NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
                NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
                HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
                [_priceArray insertObject:tempPriceDataObject.description atIndex:i];
                i++;
            }
            [self.tableView reloadData];

            
//            if (_postMaxPrice && _postMinPrice) {
//                for (NSInteger i = 1; i < _priceArray.count - 1; i ++ ) {
//                    HFSPriceDataObject *tempPriceDataObject = _priceArray[i];
//                    if ([tempPriceDataObject.fromPrice isEqualToNumber:_postMinPrice]&&[tempPriceDataObject.toPrice isEqualToNumber:_postMaxPrice]) {
//                        _selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                        break;
//                    }else{
//                        _selectedIndexPath = _customIndexPath;
//                    }
//                }
//            }else{
//                if (!_selectedIndexPath) {
//                    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                }
//            }

            
        }
        NSLog(@"请求成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
*/
 
//分类
-(void)loadretCat{
    //商品筛选（分类，品牌，价格）
    //    http://bbctest.matrojp.com/api.php?m=product&s=filter&key=水&brandid=1853&searchType=1
    //    "key : 产品搜索关键字
    //    brandid: 品牌id (可为空)
    //    searchType:搜索类型  ( 如果有关键字搜索, searchType 是必传参数 , 1  )
    //    { ""code"" : ""0 表示查询成功"",""retbrand"" : 品牌查询结果集,""countbrand"" : ""品牌查询结果集条数"",""retcat"" : 分类查询结果集,""countcat"" : ""分类查询结果条数"",""maxprice"":""商品按条件查询最大价格""}"
    
    NSString *keystr = [self.keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",keystr);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=filter&key=%@&brandid=&searchType=1",   @"http://bbctest.matrojp.com",keystr];
    
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject ====%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *result = dataDic[@"retcat"];
        
        NSLog(@"result=222=%@",result);

        if (result) {
            int i=0;
            for (NSDictionary *temp in result) {
               
                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:temp[@"catid"] name:temp[@"cat"] children:nil];
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:0];
                itemAll.selected = NO;
                [spArray addObject:itemAll];
                i++;
            }
            [_treeView reloadData];
        }
        
        NSLog(@"请求成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];

}

/*
- (void)loadDateClass {
    NSString *urlStr = nil;
    
    if (self.keywords) {
        NSString *key = [self.keywords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        urlStr = [NSString stringWithFormat:@"http://www.matrojp.com/Ajax/search/search.ashx?op=getspfl&spflcode=&ppcode=&key=%@",key];
    }
    
    if (self.spflCode) {
        urlStr = [NSString stringWithFormat:@"http://www.matrojp.com/Ajax/search/search.ashx?op=getspfl&spflcode=%@&ppcode=&key=",self.spflCode];
    }
    
    
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *result = (NSArray *)responseObject;
        if (result) {
            int i=0;
            for (NSDictionary *temp in result) {
                NSString *spfl = temp[@"SPFL"];
                NSLog(@"spfl %@",spfl);

                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:temp[@"SPFL"] name:temp[@"NAME"] children:nil];
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:0];
                itemAll.selected = NO;
                [spArray addObject:itemAll];
                i++;
            }
            [_treeView reloadData];
        }

        NSLog(@"请求成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
*/


#pragma mark- 确定按钮
/*
 根据标题来决定确定按钮的事件
 */
- (IBAction)sureButtonAction:(id)sender {
    if ([_titleLabel.text isEqualToString:@"筛选"]) {

    }else if ([_titleLabel.text isEqualToString:@"商品分类"]){
        _fenlei.text = _selectedItem.name;
        
    }else if ([_titleLabel.text isEqualToString:@"品牌"]){
        
        _pinpai.text = _selectedPP.name;
        
        [paramfilterDic setObject:_selectedPP.name forKey:@"spsb"];
        
    }else if ([_titleLabel.text isEqualToString:@"价格"]){
        _jiage.text = _selectedItem.name;
        [self confirmAction];
    }
    
    [self backButtonAction:nil];
}

#pragma mark- 返回
/*
 根据标题来决定返回按钮的事件
 */
- (IBAction)backButtonAction:(id)sender {
    
    [self endEditing:YES];
    
    if ([_titleLabel.text isEqualToString:@"筛选"]) {
        [_delegate blackAction:paramfilterDic];
    }else{
        _titleLabel.text = @"筛选";
        _sxRootView.hidden = NO;
        _cleanButton.hidden = NO;
        _shaixuanNextView.hidden = YES;
        [_backButton setImage:[UIImage imageNamed:@"xiayiye_arrow"] forState:UIControlStateNormal];
    }
    
}

#pragma mark- 清除
/*
清除刚刚选的选项_selectedItem
 还原标题、将当前的选择按钮设置成未选中等
 */
- (IBAction)cleanButtonAction:(id)sender {
   _titleLabel.text = @"筛选";
    _sxRootView.hidden = NO;
    _cleanButton.hidden = NO;
    _shaixuanNextView.hidden = YES;
    _youhuoButton.selected = _quanqiugouButton.selected = _cuxiaoButton.selected = NO;
    
    _fenlei.text = @"";
    _pinpai.text = @"";
    _jiage.text  = @"";
    
    for (id view in _titleButtonBgView.subviews) {
        if([view isKindOfClass:[UIButton class]]){
            if (((UIButton *)view).selected) {
                ((UIButton *)view).backgroundColor = RGBA(177, 142, 97, 1);
            }else{
                ((UIButton *)view).backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    _selectedItem.selected = NO;
    
    _selectedPP.selected = NO;
    _selectedItem = nil;
    
    _selectedPP = nil;
    
    [self.treeView reloadData];
    [paramfilterDic removeAllObjects];
//    _selectedIndexPath = nil;
}
#pragma mark- 顶部按钮
//    1. op：操作码
//    2. spflcode：商品分类代码
//    3. tpgg：图片规格
//    4. sort：排序
//    XSSL&false（销量）
//    XJ&true（价格正序）
//    XJ&false（价格倒序）
//            5. spsb：商品商标代码
//    6. pagesize：每页显示记录数，默认为：20
//            7. pageindex：页码
//    8. key：搜索关键字
//    9. jgs：开始价格
//    10. jge：结束价格
//    11. iskc：是否仅显示有货（true表示显示有货，false则表示忽略）
//    12. zcsp：是否跨境购（true表示跨境购，false则表示忽略）
//顶部的三个大分类按钮事件
- (IBAction)sxTitleButtonAction:(id)sender {
    UIButton * button = ((UIButton *)sender);
    
    button.selected = !button.selected;
    
    if ([button isEqual:_quanqiugouButton]) {
        _youhuoButton.selected = _cuxiaoButton.selected = NO;
    }else if ([button isEqual:_youhuoButton]){
        _quanqiugouButton.selected = _cuxiaoButton.selected = NO;
    }else{
        _quanqiugouButton.selected = _youhuoButton.selected = NO;
    }
    
    for (id view in _titleButtonBgView.subviews) {
        if([view isKindOfClass:[UIButton class]]){
            if (((UIButton *)view).selected) {
                ((UIButton *)view).backgroundColor = RGBA(177, 142, 97, 1);
            }else{
                ((UIButton *)view).backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    if (_youhuoButton.selected) {
        [paramfilterDic setObject:@"1" forKey:@"listtype"];
    }
    else if (_cuxiaoButton.selected){
        [paramfilterDic setObject:@"2" forKey:@"listtype"];
        
    }
    else if(_quanqiugouButton.selected){
        [paramfilterDic setObject:@"3" forKey:@"listtype"];
        
    }else{
    
        [paramfilterDic setObject:@"" forKey:@"listtype"];
    }
    
    /*
    if (_youhuoButton.selected) {
        [paramfilterDic setObject:@"true" forKey:@"iskc"];
    }
    else{
        [paramfilterDic setObject:@"false" forKey:@"iskc"];

    }
    if (_quanqiugouButton.selected) {
        [paramfilterDic setObject:@"true" forKey:@"zcsp"];

    }
    else{
        [paramfilterDic setObject:@"false" forKey:@"zcsp"];

    }
     */
}

#pragma mark- 分类，品牌，价格选项
/*
 根据所选的列跳转到下一选项列表
 并加载相应的数据
 分类和品牌用treeview
 价格用tableview
 */
- (IBAction)nextAction:(id)sender {
    UIControl *control = ((UIControl *)sender);
    _sxRootView.hidden = YES;
    _cleanButton.hidden = YES;
    
    [_backButton setImage:[UIImage imageNamed:@"shangyiye_arrow"] forState:UIControlStateNormal];
    
    switch (control.tag) {
#pragma mark- 分类
        case 100:{
            _titleLabel.text = @"商品分类";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = NO;
            _tableView.hidden = YES;
            
            selectPP = NO;
            [self.treeView reloadData];
            if (spArray.count > 1) {
                
                [self.treeView reloadData];
                
            }
            else{
                [self loadretCat];
            }
            
            
            
            /*
            _titleLabel.text = @"商品分类";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = NO;
            _tableView.hidden = YES;
//            _dataArray = [NSMutableArray array];
//            RADataObject *itemAll = [RADataObject dataObjectWithId:@0 name:@"全部" children:nil];
//            itemAll.level = @0;
//            itemAll.selected = YES;
//            _selectedItem = itemAll;
//            [_dataArray addObject:itemAll];
             selectPP = NO;
             [self.treeView reloadData];
            if (spArray.count > 1) {
                
                [self.treeView reloadData];
                
            }
            else{
                [self loadDateClass];
            }
          */
        }
            break;
#pragma mark- 品牌
        case 101:{
            
            
            _titleLabel.text = @"品牌";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = NO;
            _tableView.hidden = YES;
          
            selectPP = YES;
            [self.treeView reloadData];
            if (ppArray.count > 1) {
                [self.treeView reloadData];
            }
            else{
                [self loadretBrand];
            }
            
            
            
            /*
            _titleLabel.text = @"品牌";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = NO;
            _tableView.hidden = YES;
//            _dataArray = [NSMutableArray array];
//            
//            RADataObject *itemAll = [RADataObject dataObjectWithId:@0 name:@"全部" children:nil];
//            itemAll.level = @0;
//            itemAll.selected = YES;
//            [_dataArray addObject:itemAll];
//            _selectedItem = itemAll;
            
    
            NSString *urlStr = nil;
            
            
            if (self.keywords) {
                NSString *key = [self.keywords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                urlStr = [NSString stringWithFormat:@"%@Ajax/search/search.ashx?op=getpp&spflcode=&ppcode=&key=%@",SERVICE_GETBASE_URL,key];
            }
            
            if (self.spflCode) {
                urlStr = [NSString stringWithFormat:@"%@Ajax/search/search.ashx?op=getpp&spflcode=%@&ppcode=&key=",SERVICE_GETBASE_URL,self.spflCode];
            }

//            if (self.keywords) {
////                self.keywords =@"奶粉"; // 以后要删掉
//                NSString *keystr = [self.keywords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,keystr];
//            }
            
//            if (_dataArray.count>0) {
//                [self loadBrand:urlStr];
//            }
            
            selectPP = YES;
            [self.treeView reloadData];
            if (ppArray.count > 1) {
                [self.treeView reloadData];
            }
            else{
                [self loadBrand:urlStr];
            }
             */
            
        }
            break;
#pragma mark- 价格
        default:{
            _titleLabel.text = @"价格";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = YES;
            _tableView.hidden = NO;
            
            [self loadmaxPrice];
            
            //[self loadDatePrice];
            
        }
            break;
    }
}

#pragma mark- 分类、品牌
#pragma mark- RATreeViewDataSource

-(UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    static NSString *cellIdentifier = @"TypeCellIdentifier";
    UITableViewCell *cell = [_treeView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    RADataObject *data = item;
    
    if (data.children.count > 0) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow_yuan2"]];
        cell.tintColor = [UIColor colorWithHexString:@"#323232"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    } else {
        
        if (data.selected) {
            cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
        } else {
            cell.tintColor = [UIColor colorWithHexString:@"#323232"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
            cell.accessoryView = nil;
        }
    }
    
    cell.textLabel.text = data.name;
    
    return cell;
}

-(NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item) {
        RADataObject *data = item;
        return data.children.count;
    }
    return selectPP?ppArray.count:spArray.count;
    
}

-(id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    
    RADataObject *data = item;
    if (data) {
        return data.children[index];
    }
    return selectPP?ppArray[index]:spArray[index];
}

#pragma mark- RATreeViewDelegate

-(void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    RADataObject *data = item;
    if (data.children.count > 0) {
        UITableViewCell *cell = [treeView cellForItem:item];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shangjian"]];
    }
}

-(void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    RADataObject *data = item;
    
    if (data.children.count > 0) {
        UITableViewCell *cell = [treeView cellForItem:item];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiajian.psb"]];
    }
}

-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {

    if(!selectPP){
        if (item == _selectedItem) {
            
            RADataObject *data = item;
            
            UITableViewCell *cell = [treeView cellForItem:item];
            
            if (data.children.count == 0) {
                if (!data.selected) {
                    
                    cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
                    cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check"]];
                    data.selected = YES;
                }
            }
        } else {
            
            RADataObject *data = item;
            if (data.children.count == 0 ) {
                
                UITableViewCell *selectedCell = [treeView cellForItem:_selectedItem];
                selectedCell.tintColor = [UIColor colorWithHexString:@"#323232"];
                selectedCell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
                selectedCell.accessoryView = nil;
//                if (selectPP) {
//                    _selectedPP.selected = NO;
//                }
//                else{
                    _selectedItem.selected = NO;
//                }
                
                UITableViewCell *cell = [treeView cellForItem:item];
                cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
                data.selected = YES;
                if (data.idstr) {
                    NSString *spflcode = data.idstr;
                    NSLog(@"num is %@",spflcode);
                    if (data.dataId.intValue==0) {//商品分类
                        [paramfilterDic setObject:[NSString stringWithFormat:@"%@",spflcode] forKey:@"id"];
                    }
                    
                    if (data.dataId.intValue==1) {//品牌
                        [paramfilterDic setObject:[NSString stringWithFormat:@"%@",spflcode] forKey:@"brandid"];
                    }
                }
//                if (selectPP) {
//                    _selectedPP = item;
//                }
//                else{
                    _selectedItem = item;
//                }
                
            }
        }

    }
    else{
        if (item == _selectedPP) {
            
            RADataObject *data = item;
            
            UITableViewCell *cell = [treeView cellForItem:item];
            
            if (data.children.count == 0) {
                if (!data.selected) {
                    
                    cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
                    cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
                    data.selected = YES;
                }
            }
        } else {
            
            RADataObject *data = item;
            if (data.children.count == 0 ) {
                
                UITableViewCell *selectedCell = [treeView cellForItem:_selectedPP];
                selectedCell.tintColor = [UIColor colorWithHexString:@"#323232"];
                selectedCell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
                selectedCell.accessoryView = nil;
//                if (selectPP) {
                    _selectedPP.selected = NO;
//                }
//                else{
//                    _selectedItem.selected = NO;
//                }
                
                UITableViewCell *cell = [treeView cellForItem:item];
                cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
                data.selected = YES;
                if (data.idstr) {
                    NSString *spflcode = data.idstr;
                    NSLog(@"num is %@",spflcode);
                    if (data.dataId.intValue==0) {//商品分类
                        [paramfilterDic setObject:[NSString stringWithFormat:@"%@",spflcode] forKey:@"id"];
                    }
                    
                    if (data.dataId.intValue==1) {//品牌
                        [paramfilterDic setObject:[NSString stringWithFormat:@"%@",spflcode] forKey:@"brandid"];
                    }
                }
//                if (selectPP) {
                    _selectedPP = item;
//                }
//                else{
//                    _selectedItem = item;
//                }
                
            }
        }

    }

}

-(NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item {
    RADataObject *data = item;
    if (data) {
        if ([data.level isEqualToNumber:@0]) {
            return 0;
        } else {
            return 3;
        }
    }
    return 0;
}

#pragma mark- 价格
- (void)confirmAction {
    
    NSString * string;
    
    if ([_selectedIndexPath isEqual:_selectAllIndexPath]) {
        _minPrice = nil;
        _maxPrice = nil;
        
        string = @"";
    } else if ([_selectedIndexPath isEqual:_customIndexPath]) {
        if (![self priceValidate]) {
            return;
        }
        _minPrice = @(fromPriceTextField.text.integerValue);
        _maxPrice = @(toPriceTextField.text.integerValue);
        
        string = [NSString stringWithFormat:@"%ld~%ld",_minPrice.integerValue,_maxPrice.integerValue];
    }else {
        string = _priceArray[_selectedIndexPath.row];
    }
    
    _jiage.text = string;
    NSArray *strs = [string componentsSeparatedByString:@"~"];
    if (strs.count>1) {
        [paramfilterDic setObject:strs[0] forKey:@"jgs"];
        [paramfilterDic setObject:strs[1] forKey:@"jge"];
    }
   

    
}

-(BOOL)priceValidate {
   
    if (![fromPriceTextField.text isEqualToString:@""] && ![toPriceTextField.text isEqualToString:@""] &&fromPriceTextField.text.integerValue > toPriceTextField.text.integerValue) {
//        [self alert:@"提示信息" msg:@"起始价格不能大于终止价格"];
        return NO;
    }
    return YES;
}

-(void)selectCell:(UITableViewCell *)cell {
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#e60000"];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
}

-(void)unselectCell:(UITableViewCell *)cell {
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    cell.accessoryView = nil;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /*
    if ([maxprice floatValue] <= 100) {
        return 3;
    }else if ([maxprice floatValue] > 100 && [maxprice floatValue] <= 500){
    
        return 4;
    }else if ([maxprice floatValue] > 500 && [maxprice floatValue] <= 1000){
        
        return 5;
    }else if ([maxprice floatValue] > 1000 && [maxprice floatValue] <= 2000){
        
        return 6;
    }else if ([maxprice floatValue] > 2000 && [maxprice floatValue] <= 5000){
        
        return 7;
    }else if ([maxprice floatValue] > 5000 && [maxprice floatValue] <= 10000){
        
        return 8;
    }
    return 9;
    */ 
//    NSLog(@"_priceArray.count===%ld",_priceArray.count);
    return _priceArray.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PriceCellIdentifier];

    id data = _priceArray[indexPath.row];
    
    if ([data isKindOfClass:[HFSPriceDataObject class]]) {
        cell.textLabel.text = ((HFSPriceDataObject *)data).description;
    } else {
        if ([data isEqualToString:@"自定义"]) {
            
           
            [cell.contentView addSubview:fromPriceTextField];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(106.0f, 23.0f, 15.0f, 1.5f)];
            view.backgroundColor = [UIColor colorWithHexString:@"#C8C8C8"];
            [cell.contentView addSubview:view];
            
       
            [cell.contentView addSubview:toPriceTextField];
            
            if (_postMaxPrice&&_postMinPrice&&_selectedIndexPath == _customIndexPath) {
                fromPriceTextField.text = [NSString stringWithFormat:@"%@",_postMinPrice];
                toPriceTextField.text = [NSString stringWithFormat:@"%@",_postMaxPrice];
            }
            
            
        } else {
            cell.textLabel.text = data;
        }
    }
    
    if ([indexPath isEqual:_selectedIndexPath]) {
        [self selectCell:cell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = _priceArray[indexPath.row];
    if ([data isKindOfClass:[NSString class]] && [data isEqualToString:@"自定义"]) {
        return 48.0f;
    } else {
        return 44.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath isEqual:_selectedIndexPath]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell.accessoryView) {
            [self selectCell:cell];
        }
    } else {
        UITableViewCell *orginalCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        [self unselectCell:orginalCell];
        
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectCell:currentCell];
    }
    
    _selectedIndexPath = indexPath;
    
    if (![_selectedIndexPath isEqual:_customIndexPath]) {
        [fromPriceTextField resignFirstResponder];
        [toPriceTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
//    [_tableView selectRowAtIndexPath:_customIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
    UITableViewCell *orginalCell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [self unselectCell:orginalCell];
    
    UITableViewCell *currentCell = [_tableView cellForRowAtIndexPath:_customIndexPath];
    [self selectCell:currentCell];
    
    _selectedIndexPath = _customIndexPath;
    
    return YES;
}



@end

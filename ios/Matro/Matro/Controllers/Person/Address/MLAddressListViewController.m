//
//  MLAddressListViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddressListViewController.h"
#import "MLAddressListTableViewCell.h"
#import "MLAddressInfoViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"


@interface MLAddressListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_addressArray;//地址列表的数组
    NSString *userid;
    NSDictionary *selAddress;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tisBgView;//无地址的时候显示的提示主视图
@property (strong, nonatomic) IBOutlet UIView *listBgView;//有地址显示tableview时候的主视图

@end

static NSInteger selNum = 0;
static NSInteger firstLoad = 0;

@implementation MLAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_delegate) {
        self.title = @"选择收货地址";
    }else{
        self.title = @"收货地址管理";
    }
    userid = [[NSUserDefaults standardUserDefaults] valueForKey:kUSERDEFAULT_USERID];
    _addressArray = [[NSMutableArray alloc] init];
   
  
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}
#pragma mark 获取收货地址清单
- (void)loadDateAddressList {

}


- (void)viewWillAppear:(BOOL)animated{
    if (_addressArray.count == 0) {
        _tisBgView.hidden = NO;
        _listBgView.hidden = YES;
    }else{
        _tisBgView.hidden = YES;
        _listBgView.hidden = NO;
    }
}

- (IBAction)newAddress:(id)sender {
    MLAddressInfoViewController * vc = [[MLAddressInfoViewController alloc]init];
    vc.isNewAddress = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editButtonAction:(id)sender{
    UIButton * button = ((UIButton *)sender);
    NSLog(@"%ld",button.tag);
    MLAddressInfoViewController * vc = [[MLAddressInfoViewController alloc]init];
    NSDictionary *dic = [_addressArray objectAtIndex:button.tag];
//    vc.paramdic = dic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLAddressListTableViewCell" ;
    MLAddressListTableViewCell *cell = (MLAddressListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    NSDictionary *dic = [_addressArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@",dic);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = dic[@"SHRMC"];
    cell.phoneLabel.text = dic[@"SHRMPHONE"];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",dic[@"SFNAME"],dic[@"SHRADDRESS"]];
    
    if ([dic[@"MRSHRBJ"] isEqualToString:@"1"]) {//默认收货地址
        if (firstLoad == 1) {
            
            [cell.selButton setImage:[UIImage imageNamed:@"xuanzeqi_xiao2"] forState:UIControlStateNormal];
        }
        cell.tisLabel.hidden = NO;
        cell.lw.constant = 65;
    }
  
    if (indexPath.row == selNum) {
        [cell.selButton setImage:[UIImage imageNamed:@"xuanzeqi_xiao2"] forState:UIControlStateNormal];
    }
    else{
        [cell.selButton setImage:[UIImage imageNamed:@"xuanzeqi_xiao"] forState:UIControlStateNormal];
    }
    
    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//-(void)setSelAddress:(id)sender
//{
//    UIButton *btn = (UIButton*)sender;
//    btn.selected = !btn.selected;
//    selAddress = [_addressArray objectAtIndex:btn.tag];
//    if (_delegate) {
//        NSDictionary *dic = [_addressArray objectAtIndex:btn.tag];
//        
//        if ([_delegate respondsToSelector:@selector(AddressDic:)]) {
//            [_delegate AddressDic:dic];
//        }
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selNum = indexPath.row;
    [self.tableView reloadData];
    if (_delegate) {
        NSDictionary *dic = [_addressArray objectAtIndex:indexPath.row];

        if ([_delegate respondsToSelector:@selector(AddressDic:)]) {
            [_delegate AddressDic:dic];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 设置默认地址
-(void)setDefaultAddress
{
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=moren&inx=%@&userid=%@",SERVICE_GETBASE_URL,selAddress[@"INX"]?:@"",userid];
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
                                          NSLog(@"error %@",result);
                                          if ([@"true" isEqualToString:result]) {
                                              [self loadDateAddressList];
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
    
}
@end

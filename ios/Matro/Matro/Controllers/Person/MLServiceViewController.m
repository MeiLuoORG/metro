//
//  MLServiceViewController.m
//  Matro
//
//  Created by Matro on 16/6/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLServiceViewController.h"
#import "HFSServiceClient.h"
#import "MLKefuHeader.h"
#import "UIColor+HeinQi.h"
#import "MLHelpCenterDetailController.h"
#import "CommonHeader.h"
#import "MLHttpManager.h"
#define HEADER_IDENTIFIER @"MLKefuHeader"
@interface MLServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSMutableArray *sectionArr;//类别
    NSMutableArray *sectionArr1;
    NSMutableArray *sectionArr3;
    NSMutableArray *sectionArr4;
    NSMutableArray *sectionArr10;
    NSMutableArray *sectionArr11;
    
    NSMutableArray *idarr ;
    NSMutableArray *idArr1;
    NSMutableArray *idArr3;
    NSMutableArray *idArr4;
    NSMutableArray *idArr10;
    NSMutableArray *idArr11;
    
    NSString *selectID;
    
}
@property (weak, nonatomic) IBOutlet UITableView *kefuTableview;


@end

@implementation MLServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户服务";
    sectionArr = [NSMutableArray array];
    idarr = [NSMutableArray array];
    sectionArr1 = [NSMutableArray array];
    sectionArr3 = [NSMutableArray array];
    sectionArr4 = [NSMutableArray array];
    sectionArr10 = [NSMutableArray array];
    sectionArr11 = [NSMutableArray array];
    
    idArr1 = [NSMutableArray array];
    idArr3 = [NSMutableArray array];
    idArr4 = [NSMutableArray array];
    idArr10 = [NSMutableArray array];
    idArr11 = [NSMutableArray array];
    
     [_kefuTableview registerNib:[UINib nibWithNibName:@"MLKefuHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    
    self.kefuTableview.delegate = self;
    self.kefuTableview.dataSource = self;
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 5)];
//    
//    view.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
//    
//    self.kefuTableview.tableHeaderView = view;
    
    [self loadData];
    [self loadsecondData1];
    [self loadsecondData3];
    [self loadsecondData4];
    [self loadsecondData10];
    [self loadsecondData11];
}


-(void)loadData{
   // http://bbctest.matrojp.com/api.php?m=help&s=index 获取类别
   // NSString *url = @"http://bbctest.matrojp.com/api.php?m=help&s=index";
     NSString *url =  [NSString stringWithFormat:@"%@/api.php?m=help&s=index&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
    
    [MLHttpManager get:url params:nil m:@"help" s:@"index" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr addObject:tempDic[@"title"]];
            [idarr addObject:tempDic[@"id"]];
        }
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr addObject:tempDic[@"title"]];
            [idarr addObject:tempDic[@"id"]];
        }
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
     */
}

-(void)loadsecondData1{
    
    // 获取类别下的子类
    
    NSString *url =  [NSString stringWithFormat:@"%@/api.php?m=help&s=index&type=1&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
    [MLHttpManager get:url params:nil m:@"help" s:@"index" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr1 addObject:tempDic[@"title"]];
            [idArr1 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    
    /*
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr1 addObject:tempDic[@"title"]];
            [idArr1 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    */
}

-(void)loadsecondData3{
    
    //  获取类别下的子类
    
     NSString *url =  [NSString stringWithFormat:@"%@/api.php?m=help&s=index&type=3&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
    
    [MLHttpManager get:url params:nil m:@"help" s:@"index" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr3 addObject:tempDic[@"title"]];
            [idArr3 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr3 addObject:tempDic[@"title"]];
            [idArr3 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
     */
}

-(void)loadsecondData4{
    
    //  获取类别下的子类
    
    NSString *url =  [NSString stringWithFormat:@"%@/api.php?m=help&s=index&type=4&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
    
    [MLHttpManager get:url params:nil m:@"help" s:@"index" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr4 addObject:tempDic[@"title"]];
            [idArr4 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
    [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr4 addObject:tempDic[@"title"]];
            [idArr4 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
     */
}

-(void)loadsecondData10{
    
    //  获取类别下的子类
    
    NSString *url =  [NSString stringWithFormat:@"%@/api.php?m=help&s=index&type=10&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
    
    [MLHttpManager get:url params:nil m:@"help" s:@"index" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr10 addObject:tempDic[@"title"]];
            [idArr10 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
     [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"responseObject===%@",responseObject);
     NSArray *temparr = responseObject[@"data"][@"help_info"];
     for (NSDictionary *tempDic in temparr) {
     [sectionArr4 addObject:tempDic[@"title"]];
     [idArr4 addObject:tempDic[@"id"]];
     }
     
     
     [self.kefuTableview reloadData];
     NSLog(@"sectionArr==%@",sectionArr);
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     [_hud show:YES];
     _hud.mode = MBProgressHUDModeText;
     _hud.labelText = @"请求失败";
     [_hud hide:YES afterDelay:2];
     }];
     */
}

-(void)loadsecondData11{
    
    //  获取类别下的子类
    
    NSString *url =  [NSString stringWithFormat:@"%@/api.php?m=help&s=index&type=11&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
    
    [MLHttpManager get:url params:nil m:@"help" s:@"index" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        NSArray *temparr = responseObject[@"data"][@"help_info"];
        for (NSDictionary *tempDic in temparr) {
            [sectionArr11 addObject:tempDic[@"title"]];
            [idArr11 addObject:tempDic[@"id"]];
        }
        
        
        [self.kefuTableview reloadData];
        NSLog(@"sectionArr==%@",sectionArr);
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
     [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"responseObject===%@",responseObject);
     NSArray *temparr = responseObject[@"data"][@"help_info"];
     for (NSDictionary *tempDic in temparr) {
     [sectionArr4 addObject:tempDic[@"title"]];
     [idArr4 addObject:tempDic[@"id"]];
     }
     
     
     [self.kefuTableview reloadData];
     NSLog(@"sectionArr==%@",sectionArr);
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
     [_hud show:YES];
     _hud.mode = MBProgressHUDModeText;
     _hud.labelText = @"请求失败";
     [_hud hide:YES afterDelay:2];
     }];
     */
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return sectionArr1.count;
    }else if(section == 1) {
        return sectionArr3.count;
    }else if (section == 2){
        return sectionArr4.count;
    }else if (section == 3){
        
        return sectionArr10.count;
        
    }
    return sectionArr11.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return sectionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = RGBA(159,159, 159, 1);
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                    cell.textLabel.text = sectionArr1[0];
                
            }else if(indexPath.row == 1){
                
                cell.textLabel.text = sectionArr1[1];
                
            }else if(indexPath.row == 2){
                
                cell.textLabel.text = sectionArr1[2];
                
            }else{
                cell.textLabel.text = sectionArr1[3];
            }
            
        }else if (indexPath.section == 1){
        
            if (indexPath.row == 0) {
                cell.textLabel.text = sectionArr3[0];
                
            }else if(indexPath.row == 1){
                
                cell.textLabel.text = sectionArr3[1];
                
            }else if(indexPath.row == 2){
                
                cell.textLabel.text = sectionArr3[2];
                
            }
        }else if( indexPath.section == 2){
            
            if (indexPath.row == 0) {
                cell.textLabel.text = sectionArr4[0];
                
            }else if(indexPath.row == 1){
                
                cell.textLabel.text = sectionArr4[1];
                
            }else if(indexPath.row == 2){
                
                cell.textLabel.text = sectionArr4[2];
                
            }else if(indexPath.row == 3){
                
                cell.textLabel.text = sectionArr4[3];
                
            }
        }else if( indexPath.section == 3){
            
            if (indexPath.row == 0) {
                cell.textLabel.text = sectionArr10[0];
                
            }else if(indexPath.row == 1){
                
                cell.textLabel.text = sectionArr10[1];
                
            }else if(indexPath.row == 2){
                
                cell.textLabel.text = sectionArr10[2];
                
            }else if(indexPath.row == 3){
                
                cell.textLabel.text = sectionArr10[3];
                
            }
        }else if( indexPath.section == 4){
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text = sectionArr11[0];
                
            }
        }
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            selectID = idArr1[0];
        }else if (indexPath.row == 1){
            selectID = idArr1[1];
        }else if (indexPath.row == 2){
            selectID = idArr1[2];
        }else{
            selectID = idArr1[3];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            selectID = idArr3[0];
        }else if (indexPath.row == 1){
            selectID = idArr3[1];
        }else{
            selectID = idArr3[2];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            selectID = idArr4[0];
        }else if (indexPath.row == 1){
            selectID = idArr4[1];
        }else if (indexPath.row == 2){
            selectID = idArr4[2];
        }else{
            selectID = idArr4[3];
        }
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            selectID = idArr10[0];
        }else if (indexPath.row == 1){
            selectID = idArr10[1];
        }else if (indexPath.row == 2){
            selectID = idArr10[2];
        }else{
            selectID = idArr10[3];
        }
    }else  {
        if (indexPath.row == 0) {
            selectID = idArr11[0];
        }
    }
    
    NSLog(@"selectID==%@",selectID);
    
    MLHelpCenterDetailController *vc = [[MLHelpCenterDetailController alloc]init];
    vc.webCode = selectID;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MLKefuHeader *headerView = [[MLKefuHeader alloc]initWithReuseIdentifier:HEADER_IDENTIFIER];
    headerView.labtext.text = sectionArr[section];
  
    return headerView;
}

 
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

- (IBAction)actDail:(id)sender {
    
    NSLog(@"拨打4008550668");
    NSString *tel = @"400-855-0668";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",tel]];
    [[UIApplication sharedApplication] openURL:url];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

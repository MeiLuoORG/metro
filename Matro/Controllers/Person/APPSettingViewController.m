//
//  APPSettingViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/5/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "APPSettingViewController.h"
#import "APPSettingCell.h"
#import "HFSUtility.h"
#import "MNNAboutUsViewController.h"
#import "SDImageCache.h"

@interface APPSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation APPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用设置";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:kUSERDEFAULT_USERID]) {
        self.logoutBtn.hidden = YES;
    }
    
    self.logoutBtn.backgroundColor = [HFSUtility hexStringToColor:@"AE8E5D"];
    [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout:(id)sender
{
    // 存储用户信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERCARDNO];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERAVATOR];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERID];

    [userDefaults removeObjectForKey:kUSERDEFAULT_USERPHONE];

    [userDefaults removeObjectForKey:kUSERDEFAULT_USERNAME];

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==3) {
        MNNAboutUsViewController *VC = [MNNAboutUsViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (indexPath.row == 1){//点击清除缓存
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定清除缓存?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeIndeterminate;
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                [_hud hide:YES];
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"清除成功";
                [_hud hide:YES afterDelay:2];
                
                [self.settingTable reloadData];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:alertAction];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else if (indexPath.row == 2){//关于我们
        MNNAboutUsViewController *vc = [[MNNAboutUsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;  
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row==1) {
//        return 80;
//    }
//    else{
        return 40;
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"APPSettingCell" ;
    APPSettingCell *cell = (APPSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
        
    }
    switch (indexPath.row) {
        case 0:
            cell.lbname.text = @"版本";
            cell.valueLB.text = @"1.0.0";
            cell.descLB.hidden = YES;
            break;
        case 1:
            cell.lbname.text = @"清除缓存";
            cell.valueLB.text = [NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
            cell.valueLB.hidden = !([[SDImageCache sharedImageCache]getSize]>0);
            cell.descLB.hidden = YES;

            break;
        case 2:
        {
            cell.lbname.text = @"关于我们";
            cell.descLB.hidden = YES;
            cell.valueLB.hidden = YES;
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiayiye_arrow"]];
            imgView.frame = CGRectMake(MAIN_SCREEN_WIDTH-28,15, 7, 15);
            
            [cell addSubview:imgView];
        }

            
            break;
//        case 1:
//            cell.lbname.text = @"接收通知";
//            cell.valueLB.text = @"已开启";
//            cell.valueLB.textColor = [HFSUtility hexStringToColor:@"AE8E5D"];
//            cell.descLB.hidden = NO;

//            break;
        default:
            break;
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

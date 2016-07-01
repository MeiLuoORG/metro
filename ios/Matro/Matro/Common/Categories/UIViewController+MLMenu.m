//
//  UIViewController+MLMenu.m
//  Matro
//
//  Created by 黄裕华 on 16/7/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "UIViewController+MLMenu.h"
#import "UIView+DownMenu.h"
#import "MLMessagesViewController.h"

@implementation UIViewController (MLMenu)


- (void)addMenuButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [button setImage:[UIImage imageNamed:@"gengduozl"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(8, 9, 8, 9);
    [button addTarget:self action:@selector(showDownMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}



- (void)showDownMenu{
    [self.view showDownMenuWithItems:@[@{@"img":@"icon_gengduo_home",@"title":@"首页"},@{@"img":@"icon_gengduo_search",@"title":@"搜索"},@{@"img":@"icon_gengduo_message",@"title":@"消息"},@{@"img":@"icon_gengduo_collect",@"title":@"收藏"}] AndSelBlock:^(NSInteger index) {
        switch (index) {
            case 0: //首页 跳到首页
            {
                 [self.navigationController popToRootViewControllerAnimated:YES];
                [self.tabBarController setSelectedIndex:0];
            }
                break;
            case 1: //搜索 跳到搜索页
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.tabBarController setSelectedIndex:0];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PushToSearchCenter" object:nil];
                
            }
                break;
            case 2: //消息 跳到消息页
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [self.tabBarController setSelectedIndex:3];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PushToMessage" object:nil];
            }
                break;
            case 3: //收藏 跳到收藏页
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.tabBarController setSelectedIndex:3];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PushToStore" object:nil];
            }
                break;
                
            default:
                break;
        }
    }];
}


@end

//
//  MLpingjiaViewController.m
//  Matro
//
//  Created by Matro on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLpingjiaViewController.h"

#import "MJRefresh.h"

@interface MLpingjiaViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MLpingjiaViewController

/*
- (instancetype)init
{
    if (self = [super init])
    {
        self.menuViewStyle                   = WMMenuViewStyleLine;
        self.titleColorSelected              = RGBA(174, 142, 93, 1);
        self.titleColorNormal                = RGBA(14, 14, 14, 1);
        self.progressColor                   = RGBA(174, 142, 93, 1);
        self.titleSizeSelected               = 14;
        self.pageAnimatable                  = NO;
        self.titleSizeNormal                 = 14;
        self.menuHeight                      = 44;
        self.menuItemWidth                   = (MAIN_SCREEN_WIDTH - 5*15)/4;
        self.postNotification                = YES;
        self.itemMargin                      = 15.f;
        self.bounces                         = NO;
        self.menuBGColor                     = [UIColor whiteColor];
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            Class vcClass;
            NSString *title;
            switch (i) {
                case 0:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"全部";
                    break;
                case 1:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"待付款";
                    break;
                case 2:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"待收货";
                    break;
                case 3:
                    vcClass = [MLPersonOrderListViewController class];
                    title = @"待评价";
                    break;
                default:
                    break;
            }
            [viewControllers addObject:vcClass];
            [titles addObject:title];
        }
        self.viewControllerClasses = viewControllers;
        self.titles = titles;
        
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    self.navigationItem.title = @"用户评价";
    self.imgCollectionView.hidden = YES;
    self.commentTableview.backgroundColor = RGBA(245, 245, 245, 1);
    self.commentTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.commentTableview registerNib:[UINib nibWithNibName:@"MLCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MLCommentTableViewCell"];
    self.commentTableview.delegate = self;
    self.commentTableview.dataSource = self;
    
    self.commentTableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.commentTableview.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
    }];
     */
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 3;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    cell = [self.commentTableview dequeueReusableCellWithIdentifier:@"MLCommentTableViewCell" forIndexPath:indexPath];
        return cell;
 
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 218;
}

*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (IBAction)actQuanbu:(id)sender {
}
- (IBAction)actHaoping:(id)sender {
}
- (IBAction)actZhongping:(id)sender {
}
- (IBAction)actChaping:(id)sender {
}
- (IBAction)actShaitu:(id)sender {
}
- (IBAction)addshopCar:(id)sender {
}

- (IBAction)myshopCar:(id)sender {
}
 */
@end

//
//  MLYHQViewController.m
//  Matro
//
//  Created by Matro on 16/5/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLYHQViewController.h"
#import "MLYHQTableViewCell.h"
#import "MLYHQOutdateCell.h"
#import "MLYHQUsedCell.h"
#import "MJRefresh.h"

@interface MLYHQViewController ()<UITableViewDelegate,UITableViewDataSource>{

    BOOL isunUsed;
    BOOL isoutDate;
    BOOL isUsed;
    BOOL isblank;
}

@end

@implementation MLYHQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    isunUsed = YES;
    isoutDate = NO;
    isUsed = NO;
    
    self.blankView.hidden = YES;
    self.outdateTableView.hidden = YES;
    self.usedTableView.hidden = YES;
    
    self.unuseTableView.backgroundColor = RGBA(245, 245, 245, 1);
    self.unuseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.outdateTableView.backgroundColor = RGBA(245, 245, 245, 1);
    self.outdateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.usedTableView.backgroundColor = RGBA(245, 245, 245, 1);
    self.usedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.unuseTableView registerNib:[UINib nibWithNibName:@"MLYHQTableViewCell" bundle:nil] forCellReuseIdentifier:@"MLYHQTableViewCell"];
    [self.outdateTableView registerNib:[UINib nibWithNibName:@"MLYHQOutdateCell" bundle:nil] forCellReuseIdentifier:@"MLYHQOutdateCell"];
    [self.usedTableView registerNib:[UINib nibWithNibName:@"MLYHQUsedCell" bundle:nil] forCellReuseIdentifier:@"MLYHQUsedCell"];
    
 
    self.unuseTableView.delegate = self;
    self.unuseTableView.dataSource = self;
    self.usedTableView.delegate =self;
    self.usedTableView.dataSource =self;
    self.outdateTableView.dataSource =self;
    self.outdateTableView.delegate =self;
    
    self.unuseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.unuseTableView.header endRefreshing];
//        page = 1;
//        [self downLoadList];
    }];
    self.outdateTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.outdateTableView.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
    }];
    self.usedTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.usedTableView.header endRefreshing];
        //        page = 1;
        //        [self downLoadList];
    }];
    isblank = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isblank) {
        self.blankView.hidden = NO;
        self.unuseTableView.hidden = YES;
        self.outdateTableView.hidden = YES;
        self.usedTableView.hidden = YES;
    }
    else if (isunUsed) {
        return 8;
    } else if (isoutDate){
        
        return 2;
    }
    return 3;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (isunUsed) {
        
        cell = [self.unuseTableView dequeueReusableCellWithIdentifier:@"MLYHQTableViewCell" forIndexPath:indexPath];
        return cell;
        
    }else if(isoutDate){
        
        MLYHQOutdateCell *outdateCell = [[MLYHQOutdateCell alloc]init];
        cell = [self.outdateTableView dequeueReusableCellWithIdentifier:@"MLYHQOutdateCell" forIndexPath:indexPath];
        outdateCell.imageState.image = [UIImage imageNamed:@"outdate"];
        
    }else{
        
        MLYHQUsedCell *usedCell = [[MLYHQUsedCell alloc]init];
        cell = [self.usedTableView dequeueReusableCellWithIdentifier:@"MLYHQUsedCell" forIndexPath:indexPath];
        usedCell.imageState.image = [UIImage imageNamed:@"used"];
    }
    
    /*
    cell.checkBoxBtn.hidden = !isEditing;
    
    MLWishlistModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.wishlistModel = model;
    cell.checkBoxBtn.isSelected = model.isSelect;
    __weak typeof(self) weakself = self;
    cell.wishlistCheckBlock = ^(BOOL isSelected){
        model.isSelect = isSelected;
        if (isSelected) {
            [weakself.wishlistArray addObject:model];
        }
        else{
            [weakself.wishlistArray removeObject:model];
        }
    };
    cell.wishlistDeleteBlock = ^(){
        [weakself deleteWishlistWithSPID:model.JMSP_ID];
    };
    cell.wishlistAddCartBlock = ^(){
        [weakself addToCartWithSP_ID:model.JMSP_ID];
    };
     */
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}



- (IBAction)actUnuse:(id)sender {
    isunUsed = YES;
    isoutDate = NO;
    isUsed = NO;
    self.unuseTableView.hidden = NO;
    self.outdateTableView.hidden = YES;
    self.usedTableView.hidden = YES;
    [self.btnUnuse setTitleColor:MS_RGB(166,136,89) forState:UIControlStateNormal];
    self.unuseView.backgroundColor = MS_RGB(166,136,89);
    [self.btnOutdate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.outdateView.backgroundColor = [UIColor whiteColor];
    [self.btnUsed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.usedView.backgroundColor = [UIColor whiteColor];
    [self.unuseTableView reloadData];
    
}
- (IBAction)actOutdate:(id)sender {
    isunUsed = NO;
    isoutDate = YES;
    isUsed = NO;
    self.unuseTableView.hidden = YES;
    self.outdateTableView.hidden = NO;
    self.usedTableView.hidden = YES;
    [self.btnOutdate setTitleColor:MS_RGB(166,136,89) forState:UIControlStateNormal];
    self.outdateView.backgroundColor = MS_RGB(166,136,89);
    [self.btnUnuse setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.unuseView.backgroundColor = [UIColor whiteColor];
    [self.btnUsed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.usedView.backgroundColor = [UIColor whiteColor];
    [self.outdateTableView reloadData];
    
}
- (IBAction)actUsed:(id)sender {
    isunUsed = NO;
    isoutDate = NO;
    isUsed = YES;
    self.unuseTableView.hidden = YES;
    self.outdateTableView.hidden = YES;
    self.usedTableView.hidden = NO;
    [self.btnUsed setTitleColor:MS_RGB(166,136,89) forState:UIControlStateNormal];
    self.usedView.backgroundColor = MS_RGB(166,136,89);
    [self.btnOutdate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.outdateView.backgroundColor = [UIColor whiteColor];
    [self.btnUnuse setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.unuseView.backgroundColor = [UIColor whiteColor];
    [self.usedTableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

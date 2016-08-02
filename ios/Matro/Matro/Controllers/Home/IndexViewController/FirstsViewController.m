//
//  FirstsViewController.m
//  Matro
//
//  Created by lang on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "FirstsViewController.h"

@interface FirstsViewController (){

    CGFloat _index_0_height;
    CGFloat _index_1_height;
    CGFloat _index_2_height;
    CGFloat _index_3_height;
    CGFloat _index_4_height;
    CGFloat _index_5_height;
    CGFloat _index_6_height;
    CGFloat _index_7_height;
    CGFloat _index_8_height;
    
}

@end

@implementation FirstsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _index_0_height = 464.0f/750.0f*SIZE_WIDTH;

    _index_1_height = 80.0f/750.0f*SIZE_WIDTH+5;

    _index_2_height = 40+177.0/750.0f*SIZE_WIDTH;

    _index_3_height = 440.0/750.0f*SIZE_WIDTH;

    _index_4_height = 300.0/750.0f*SIZE_WIDTH+5;

    _index_5_height = 40+1130.0/750.0f*SIZE_WIDTH+5;

    _index_6_height = 40+720.0/750.0f*SIZE_WIDTH+5;

    _index_7_height = 40+720.0/750.0f*SIZE_WIDTH+5;

    _index_8_height = 40.0+(460.0/750.0*SIZE_WIDTH+5)*4;

    [self createTableviewML];
    
}
- (void)createTableviewML{

    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-49.0-60) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];

}

#pragma mark TableViewDelegate代理方法Start
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    switch (indexPath.row) {
        case 0:{
            height = _index_0_height;
            
        }
            break;
        case 1:{
            height = _index_1_height;
            
        }
            break;
        case 2:{
            height = _index_2_height;
            
        }
            break;
        case 3:{
            height = _index_3_height;
            
        }
            break;
        case 4:{
            height = _index_4_height;
            
        }
            break;
        case 5:{
            height = _index_5_height;
            
        }
            break;
        case 6:{
            height = _index_6_height;
            
        }
            break;
        case 7:{
            height = _index_7_height;
            
        }
            break;
        case 8:{
            height = _index_8_height;
            
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"tableviewCellID";
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 464.0f/750.0f*SIZE_WIDTH)];
            view1.backgroundColor = [UIColor redColor];
            [cell addSubview:view1];
            
        }
            break;
        case 1:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 80.0f)];
            view1.backgroundColor = [UIColor orangeColor];
            [cell addSubview:view1];
        }
            
            break;
        case 2:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 217.0f)];
            view1.backgroundColor = [UIColor redColor];
            [cell addSubview:view1];
        }
            
            break;
        case 3:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 440.0/750.0f*SIZE_WIDTH)];
            view1.backgroundColor = [UIColor orangeColor];
            [cell addSubview:view1];
        }
            
            break;
        case 4:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 300.0/750.0f*SIZE_WIDTH)];
            view1.backgroundColor = [UIColor redColor];
            [cell addSubview:view1];
        }
            
            break;
        case 5:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 300.0/750.0f*SIZE_WIDTH)];
            view1.backgroundColor = [UIColor orangeColor];
            [cell addSubview:view1];
        }
            
            break;
        case 6:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40+400.0/750.0f*SIZE_WIDTH+ 370.0/750.0f*SIZE_WIDTH+177.0+5)];
            view1.backgroundColor = [UIColor redColor];
            [cell addSubview:view1];
        }
            
            break;
        case 7:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40+370.0/750.0f*SIZE_WIDTH+177.0+5)];
            view1.backgroundColor = [UIColor orangeColor];
            [cell addSubview:view1];
        }
            
            break;
        case 8:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40+400.0/750.0f*SIZE_WIDTH+177.0+5)];
            view1.backgroundColor = [UIColor redColor];
            [cell addSubview:view1];
        }
            
            break;
        case 9:{
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 40.0+(460.0/750.0*SIZE_WIDTH+5)*4)];
            view1.backgroundColor = [UIColor orangeColor];
            [cell addSubview:view1];
        }
            break;

        default:
            break;
    }

    return cell;;
}

#pragma end mark 代理方法结束



#pragma mark ScrollView代理方法开始
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll6+++");
    
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:withContentOffest:)]) {
        [self.firstDelegate firstViewController:self withContentOffest:scrollView.contentOffset.y];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:withBeginOffest:)]) {
        [self.firstDelegate firstViewController:self withBeginOffest:scrollView.contentOffset.y];
    }
    
}
#pragma end mark 代理方法结束
- (void)pushToType:(NSString *)index withUi:(NSString *)sender{
    
    if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(firstViewController:JavaScriptActionFourButton:withUi:)]) {
        [self.firstDelegate firstViewController:self JavaScriptActionFourButton:index withUi:sender];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

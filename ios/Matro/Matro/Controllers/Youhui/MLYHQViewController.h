//
//  MLYHQViewController.h
//  Matro
//
//  Created by Matro on 16/5/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLYHQViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btnUnuse;
- (IBAction)actUnuse:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *unuseView;
@property (weak, nonatomic) IBOutlet UIButton *btnOutdate;
- (IBAction)actOutdate:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *outdateView;
@property (weak, nonatomic) IBOutlet UIButton *btnUsed;
- (IBAction)actUsed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *usedView;
@property (weak, nonatomic) IBOutlet UITableView *unuseTableView;
@property (weak, nonatomic) IBOutlet UITableView *outdateTableView;
@property (weak, nonatomic) IBOutlet UITableView *usedTableView;
@property (weak, nonatomic) IBOutlet UIView *blankView;

@end

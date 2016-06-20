//
//  MLpingjiaViewController.h
//  Matro
//
//  Created by Matro on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLpingjiaViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *quanbuBtn;
- (IBAction)actQuanbu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *haopingBtn;
- (IBAction)actHaoping:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *zhongpingBtn;
- (IBAction)actZhongping:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chapingBtn;
- (IBAction)actChaping:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shaituBtn;
- (IBAction)actShaitu:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *commentTableview;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;
- (IBAction)addshopCar:(id)sender;
- (IBAction)myshopCar:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *shopCarImageView;

@end

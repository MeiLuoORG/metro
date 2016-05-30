//
//  MLWishlistViewController.h
//  Matro
//
//  Created by 黄裕华 on 16/5/13.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLWishlistViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;
@property (weak, nonatomic) IBOutlet UITableView *storesTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnGoods;
- (IBAction)actGoods:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIButton *btnStores;
- (IBAction)actStores:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *storesView;

@end

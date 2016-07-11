//
//  UIView+DownMenu.h
//  Menu
//
//  Created by MR.Huang on 16/7/1.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownMenuBgView;
typedef void(^DidSelectAtIndex)(NSInteger);

@interface UIView (DownMenu)
@property (nonatomic,strong)DownMenuBgView *downMenu;
- (void)showDownMenuWithItems:(NSArray *)items AndSelBlock:(DidSelectAtIndex)selIndex;
@end



@interface DownMenuBgView : UIControl

@property (nonatomic,strong)NSArray *items;

@property (nonatomic,copy)DidSelectAtIndex didSelBlock;


@end

#define kDownMenuCell   @"downMenuCell"

@interface DownMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

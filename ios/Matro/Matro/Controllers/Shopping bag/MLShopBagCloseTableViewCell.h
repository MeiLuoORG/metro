//
//  MLShopBagCloseTableViewCell.h
//  Matro
//
//  Created by 黄裕华 on 16/7/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^CloseCellActionBlock)();

@interface MLShopBagCloseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,copy)CloseCellActionBlock closeAction;


@end

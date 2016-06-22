//
//  MLReturnsDetailPhototCell.h
//  Matro
//
//  Created by 黄裕华 on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLReturnsDetailPhototCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *imgsArray;

@end

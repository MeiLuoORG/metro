//
//  MLReturnsDetailPhototCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsDetailPhototCell.h"
#import "MLAddImgCollectionViewCell.h"
#import "HFSConstants.h"
#import "UIImageView+WebCache.h"

@implementation MLReturnsDetailPhototCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MLAddImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kAddImgCollectionViewCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgsArray.count;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MLAddImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddImgCollectionViewCell forIndexPath:indexPath];
    NSString *url = [self.imgsArray objectAtIndex:indexPath.row];
    
    if ([url hasSuffix:@"webp"]) {
        [cell.imgView setZLWebPImageWithURLStr:url withPlaceHolderImage:PLACEHOLDER_IMAGE];
    } else {
      [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:PLACEHOLDER_IMAGE];
    }
    cell.delBtn.hidden = YES;
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellW = (MAIN_SCREEN_WIDTH - 3*10-32)/4;
    return CGSizeMake(cellW,cellW);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.returnPhotoClick) {
        self.returnPhotoClick(indexPath.row);
    }
    
}



- (void)setImgsArray:(NSArray *)imgsArray{
    if (_imgsArray != imgsArray) {
        _imgsArray = imgsArray;
        [self.collectionView reloadData];
    }
}


@end

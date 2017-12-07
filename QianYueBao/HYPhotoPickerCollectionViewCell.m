//
//  HYPhotoPickerCollectionViewCell.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerCollectionViewCell.h"

static NSString *const _cellIdentifier = @"cell";

@implementation HYPhotoPickerCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYPhotoPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    if ([[cell.contentView.subviews lastObject] isKindOfClass:[UIImageView class]])
    {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    return cell;
}

@end

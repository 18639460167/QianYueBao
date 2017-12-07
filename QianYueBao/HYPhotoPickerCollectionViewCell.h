//
//  HYPhotoPickerCollectionViewCell.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionView;

@interface HYPhotoPickerCollectionViewCell : UICollectionViewCell

+ (instancetype) cellWithCollectionView : (UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath;

@property (nonatomic, strong) UIImage *cellImage;

@end

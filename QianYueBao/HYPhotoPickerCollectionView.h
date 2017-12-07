//
//  HYPhotoPickerCollectionView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoAssets.h"

// 展示状态
typedef NS_ENUM(NSUInteger, HYPickerCollectionViewShowOrderStatus) {
    HYPickerCollectionViewShowOrderStatusTimeDesc = 0,  // 升序
    HYPickerCollectionViewShowOrderStatusTimeAsc // 降序
};
@class HYPhotoPickerCollectionView;

@protocol HYPhotoPcikerCollectionViewDelegate <NSObject>

// 选择相片就会调用
- (void) pickerCollectionViewDidSelected:(HYPhotoPickerCollectionView *) pickerCollectionView deleteAsset:(HYPhotoAssets *)deleteAssets;

// 点击拍照就会调用
- (void)pickerCollectionViewDidCameraSelect:(HYPhotoPickerCollectionView *) pickerCollectionView;

@end
@interface HYPhotoPickerCollectionView : UICollectionView<UICollectionViewDelegate>

// scrollview滚动的升序降序
@property (nonatomic, assign) HYPickerCollectionViewShowOrderStatus status;

// 保存所有数据
@property (nonatomic, strong) NSArray *dataArray;

// 保存选中图片
@property (nonatomic, strong) NSMutableArray *selectAssets;

// 保存最后一次图片
@property (nonatomic, strong) NSMutableArray *lastDataArray;

// delegate
@property (nonatomic, weak) id <HYPhotoPcikerCollectionViewDelegate>collectionViewDelegate;

// 限制最大数
@property (nonatomic, assign) NSInteger maxCount;

// 置顶展示图片
@property (nonatomic, assign) BOOL topShowPhotoPicker;

// 显示拍照
@property (nonatomic, assign) BOOL isShowCamera;

// 选中的所引值，为了防止重置
@property (nonatomic, strong) NSMutableArray *selectsIndexPath;

// 记录选中的的值
@property (nonatomic, assign) BOOL isRecoderSelectPicker;
@end

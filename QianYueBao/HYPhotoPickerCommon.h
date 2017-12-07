//
//  HYPhotoPickerCommon.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#ifndef HYPhotoPickerCommon_h
#define HYPhotoPickerCommon_h


// 点击销毁block
typedef void (^HYPickerBrowserViewControllerTapDisMissBlock)(NSInteger);

// 点击View执行动画
typedef NS_ENUM(NSUInteger, UIViewAnimationAnimationStatus) {
    UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
    UIViewAnimationAnimationStatusFade , // 淡入淡出
};

// 图片最多显示9张，超过9张取消点击事件
static NSInteger const KPhotoShowMaxCount = 9;

#define iOS7gt ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// scrollview 滑动的间距
static CGFloat const HYPickerCollectionViewPadding = 10;

// scrollview拉伸的比例
static CGFloat const HYPickerScrollViewMaxZoomScale = 3.0;
static CGFloat const HYPickerScrollviewMinZoomScale = 1.0;

//  进度条的宽度／高度
static NSInteger const HYPickerProgressViewW= 50;
static NSInteger const HYPickerProgressViewH = 50;

//  分页控制器的高度
static NSInteger const HYPIckerPageCtrH = 25;

// NSNotification
static NSString *PICKER_TAKE_DONE = @"PICKER_TAKE_DONE";
static NSString *PICKER_TAKE_PHOTO = @"PICKER_TAKE_PHOTO";


static CGFloat const CELL_ROW = 3;
static CGFloat const CELL_MARGIN = 2;
static CGFloat const CELL_LINE_MARGIN = 2;
static CGFloat const TOOLBAR_HEIGHT = 44;


#endif /* HYPhotoPickerCommon_h */

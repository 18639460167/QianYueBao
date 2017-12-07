//
//  HYPhotoPickerBrowserPhotoScrollView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoPickerBrowserPhotoImageView.h"
#import "HYPhotoPickerBrowserPhotoView.h"
#import "HYPhotoPickerBrowerPhoto.h"
#import "HYPhoto.h"

typedef void (^callBackPhotoBlock)(id img);
@class HYPhotoPickerBrowserPhotoScrollView;

@protocol HYPhotoPickerPhotoScrollViewDelegate <NSObject>
@optional
// 单击调用
- (void) pickerPhotoScrollViewDidSingleClick:(HYPhotoPickerBrowserPhotoScrollView *)photoScrollView;
@end
@interface HYPhotoPickerBrowserPhotoScrollView : UIScrollView<UIScrollViewDelegate,HYPhotoPickerBrowserPhotoImageViewDelegate,HYPhotoPickerPhotoScrollViewDelegate>

@property (nonatomic, strong) HYPhotoPickerBrowerPhoto *photo;
@property (nonatomic, strong) HYPhotoPickerBrowserPhotoImageView *photoImageView;
@property (nonatomic, weak)   id<HYPhotoPickerPhotoScrollViewDelegate>photoScrollViewDelegate;

// 长按图片的操作, 可以外面传入
@property (nonatomic, strong) UIActionSheet *sheet;

// 点击销毁Block
@property (nonatomic, copy)  callBackPhotoBlock callBack;

- (void)setMaxMinZoomScalesForCurrentBounds;

@end

//
//  HYPhotoPickerViewController.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYPhotoAssets;
// 回调
typedef void(^callBackBlock)(NSArray<HYPhotoAssets *> *assets);
@class HYPhotoPickerViewController;
// 状态组
typedef NS_ENUM(NSInteger , PickerViewShowStatus) {
    PickerViewShowStatusGroup = 0, // default groups .
    PickerViewShowStatusCameraRoll ,
    PickerViewShowStatusSavePhotos ,
    PickerViewShowStatusPhotoStream
};

typedef NS_ENUM(NSInteger, PickerPhotoStatus) {
    PickerPhotoStatusAllVideoAndPhotos = 0, // default Photos And Videos
    PickerPhotoStatusVideos,
    PickerPhotoStatusPhotos
};

@protocol HYPhotoPickerViewControllerDelegate <NSObject>
/**
 *  返回所有的Asstes对象
 */
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets;
/**
 *  点击拍照
 */
@optional
- (void)pickerCollectionViewSelectCamera:(HYPhotoPickerViewController *)pickerVc withImage:(UIImage *)image;
@end
@interface HYPhotoPickerViewController : UIViewController

// @optional
@property (nonatomic , weak) id<HYPhotoPickerViewControllerDelegate>delegate;
// 决定你是否需要push到内容控制器, 默认显示组
@property (nonatomic , assign) PickerViewShowStatus status;
// 决定显示的是图片，还是视频，还是图片加视频. 默认都显示
@property (nonatomic , assign) PickerPhotoStatus photoStatus;
// 可以用代理来返回值或者用block来返回值
@property (nonatomic , copy) callBackBlock callBack;
// 每次选择图片的最小数, 默认与最大数是9
@property (nonatomic , assign) NSInteger maxCount;
// 记录选中的值
@property (strong,nonatomic) NSArray *selectPickers;
// 置顶展示图片
@property (assign,nonatomic) BOOL topShowPhotoPicker;
// 是否显示Camera
@property (assign,nonatomic) BOOL isShowCamera;
// @function
// 展示控制器
- (void)showPickerVc:(UIViewController *)vc;

@end

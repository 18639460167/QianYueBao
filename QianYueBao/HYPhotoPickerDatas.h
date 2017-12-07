//
//  HYPhotoPickerDatas.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HYPhotoPcikerGroup;

// 回调
typedef void (^callBackPhotoBlock)(id obj);

@interface HYPhotoPickerDatas : NSObject

/**
 *  获取所有值
 */
+ (instancetype) defaultPicker;

/**
 *  获取所有组对应的图片和视频
 */
- (void)getAllGroupWithPhotosAndVideos:(callBackPhotoBlock)callBack;

/**
 *  获取所有组对应的图片
 */
- (void)getAllGroupWithPhotos:(callBackPhotoBlock)callBack;

/**
 * 获取所有组对应的图片
 */
- (void) getAllGroupWithAllPhotos : (callBackPhotoBlock ) callBack;

/**
 *  获取所有组对应的videos
 */
- (void)getAllGroupWithVideos:(callBackPhotoBlock)callBack;

/**
 *  传入一个组获取组里面的Asset
 */
- (void)getGroupPhotosWithGroup:(HYPhotoPcikerGroup *)pickerGroup finished:(callBackPhotoBlock)callBack;

/**
 *  传入一个AssetsURK来获取UIImage
 */
- (void)getAssetsPhotoWithURLS:(NSURL *)url callBack:(callBackPhotoBlock)callBack;

@end

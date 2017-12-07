//
//  HYPhotoPickerBrowerPhoto.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HYPhotoAssets.h"

@interface HYPhotoPickerBrowerPhoto : NSObject

@property (nonatomic, assign) BOOL isVideo;
/**
 *  自动适配是不是以下几种数据
 */
@property (nonatomic, strong) id photoObj;

/**
 *  传入对应的UIImageView，记录坐标
 */
@property (nonatomic, strong) UIImageView *toView;

/**
 *  保存相册模型
 */
@property (nonatomic, strong) HYPhotoAssets *asset;

/**
 *  URL地址
 */
@property (nonatomic, strong) NSURL *photoURL;

/**
 *  原图
 */
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) UIImage *aspectRadioImage;

/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**
 *  传入一个图片对象，可以是URL/UIImage/NSString,返回一个实例
 */
+ (instancetype)photoAnyImageObjWith:(id)imageObj;

@end

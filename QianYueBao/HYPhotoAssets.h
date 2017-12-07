//
//  HYPhotoAssets.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^callBackImage)(UIImage *image);

@interface HYPhotoAssets : NSObject

+ (instancetype)assetWithImage:(UIImage *)image;

// 获取缩略图
- (void)thumbImageCallBack:(callBackImage)callBack;

@property (nonatomic, strong) ALAsset *asset;

/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage *aspectRatioImage;

/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**
 *  索引
 */
@property (nonatomic, assign) NSInteger cuurntIndex;

/**
 *  原图
 */
@property (nonatomic, strong) UIImage *originImage;


/**
 *  获取是否是视频类型 defalut  = false
 */
@property (nonatomic, assign) BOOL isVideoType;
@property (nonatomic, weak)   UIImageView *toView;

/**
 *  获取图片链接
 */
- (NSURL *)assetURL;

@end

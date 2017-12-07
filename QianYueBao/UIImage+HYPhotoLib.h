//
//  UIImage+HYPhotoLib.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYPhotoLib)

+ (instancetype)ml_imageFormBundleNamed:(NSString *)name;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)imageScaleAspectFillFromTop:(CGSize)frameSize;

- (UIImage *)subImageInrect:(CGRect)rect;

- (UIImage *)imageFillSize:(CGSize)viewSize;

@end

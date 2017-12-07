//
//  UIImage+HYPhotoLib.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UIImage+HYPhotoLib.h"

@implementation UIImage (HYPhotoLib)

+ (instancetype)ml_imageFormBundleNamed:(NSString *)name
{
     return [UIImage imageNamed:[@"ZLPhotoLib.bundle" stringByAppendingPathComponent:[NSString stringWithFormat:@"zl_%@",name]]];
}

/**
 *  等比例缩放
 */
- (UIImage *)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if (verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio>horizontalRadio ? horizontalRadio:verticalRadio;
    }
    else
    {
        radio = verticalRadio<horizontalRadio ? verticalRadio:horizontalRadio;
    }
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width-width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)imageFillSize:(CGSize)viewSize
{
    CGSize size = self.size;
    
    CGFloat scaleX = viewSize.width/size.width;
    CGFloat scaley = viewSize.height/size.height;
    CGFloat scale = MAX(scaleX, scaley);
    
    UIGraphicsBeginImageContext(viewSize);
    
    CGFloat width = size.width*scale;
    CGFloat height = size.height*scale;
    
    float dwidth = ((viewSize.width-width)/2.0f);
    float dheight = ((viewSize.height-height)/2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width*scale, size.height*scale);
    [self drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  缩放从顶部开始平铺图片
 */

- (UIImage *)imageScaleAspectFillFromTop:(CGSize)frameSize
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat radio = self.size.height/self.size.width;
    CGFloat height = frameSize.height/radio;
    
    // 缩放
    UIImage *adjustedImage = [self scaleToSize:CGSizeMake(frameSize.width*screenScale, height)];
    
    // 裁剪
    adjustedImage = [adjustedImage subImageInrect:CGRectMake(0, 0, frameSize.width, frameSize.width*screenScale)];
    return adjustedImage;
}

- (UIImage *)subImageInrect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect samllBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(samllBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, samllBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    
    return smallImage;
}

@end

//
//  UIImage+BDImageAction.m
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UIImage+BDImageAction.h"

@implementation UIImage (BDImageAction)

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(targetSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}

+ (UIImage *)getHeardImage
{
    UIImage *image = IMAGE_NAME(@"head");
    if ([[NSUserDefaults standardUserDefaults] valueForKey:READ_MESSAGE(User_ID, @"shopLogo")] != nil)
    {
        image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:READ_MESSAGE(User_ID, @"shopLogo")]];
    }
    return image;
}

@end

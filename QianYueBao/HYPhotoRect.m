//
//  HYPhotoRect.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoRect.h"

@implementation HYPhotoRect

+ (CGRect)setMaxMinZoomScalesForCurrentBoundWithImage:(UIImage *)image
{
    if (!([image isKindOfClass:[UIImage class]]) || image == nil)
    {
        if (!([image isKindOfClass:[UIImage class]]))
        {
            return CGRectZero;
        }
    }
    
    // Sizes
    CGSize boundsSize  =[UIScreen mainScreen].bounds.size;
    CGSize imageSize = image.size;
    if (imageSize.width == 0 && imageSize.height == 0)
    {
        return CGRectZero;
    }
    
    // the scale needed to perfectly fit the image width-wise
    CGFloat xScale = boundsSize.width/imageSize.width;
    // the scale needed to perfectly fit the image height-wise
    CGFloat yScale = boundsSize.height/imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    if (xScale >= 1&& yScale<=1)
    {
        minScale = MIN(xScale, yScale);
    }
    else
    {
        minScale = xScale;
    }
    
    CGRect frameToCenter = CGRectZero;
    frameToCenter = CGRectMake(0, 0, imageSize.width*minScale, imageSize.height*minScale);
    
    // Horizontally
    if (frameToCenter.size.width<boundsSize.width)
    {
        frameToCenter.origin.x = floorf((boundsSize.width-frameToCenter.size.width)/2.0);
    }
    else
    {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height)
    {
        frameToCenter.origin.y = floorf((boundsSize.height-frameToCenter.size.height)/2.0);
    }
    else
    {
        frameToCenter.origin.y = 0;
    }
    
    return frameToCenter;
}

+ (CGRect)setMaxMinzoomScalesForCurrentBoundWithIMageView:(UIImageView *)imageView
{
    return [self setMaxMinZoomScalesForCurrentBoundWithImage:imageView.image];
}

@end

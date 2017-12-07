//
//  HYPhotoRect.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYPhotoRect : NSObject

+ (CGRect)setMaxMinZoomScalesForCurrentBoundWithImage:(UIImage *)image;

+ (CGRect)setMaxMinzoomScalesForCurrentBoundWithIMageView:(UIImageView *)imageView;

@end

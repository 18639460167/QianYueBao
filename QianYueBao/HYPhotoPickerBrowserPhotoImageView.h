//
//  HYPhotoPickerBrowserPhotoImageView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HYPhotoPickerBrowserPhotoImageViewDelegate;

@interface HYPhotoPickerBrowserPhotoImageView : UIImageView


@property (nonatomic, weak) id <HYPhotoPickerBrowserPhotoImageViewDelegate> tapDelegate;
@property (assign,nonatomic) CGFloat progress;

- (void)addScaleBigTap;

- (void)removeScaleBigTap;

@end

@protocol HYPhotoPickerBrowserPhotoImageViewDelegate <NSObject>

@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;

@end

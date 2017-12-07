//
//  HYPhotoPickerBrowserPhotoView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYPhotoPickerBrowserPhotoViewDelegate;

@interface HYPhotoPickerBrowserPhotoView : UIView

@property (nonatomic, weak) id<HYPhotoPickerBrowserPhotoViewDelegate>tapDelegate;

@end

@protocol HYPhotoPickerBrowserPhotoViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;

@end

//
//  HYPhotoPickerImageView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPhotoPickerImageView : UIImageView

/**
 *  是否有蒙板层
 */
@property (nonatomic, assign, getter = isMaskViewFlag) BOOL maskViewFlag;

/**
 *  蒙板层的颜色，默认颜色
 */
@property (nonatomic, strong) UIColor *maskViewColor;

/**
 *  蒙板的透明度,默认0.5
 */
@property (nonatomic, assign) CGFloat maskViewAlpha;

/**
 *  是否有右上角打勾的按钮
 */
@property (nonatomic, assign) BOOL animationRightTick;

/**
 *  是否视频类型
 */
@property (nonatomic, assign) BOOL isVideoType;

/**
 *  点击照片是否有动画
 */
@property (nonatomic, assign) BOOL isClickHaveAnimation;
@end

//
//  HYCameraImageView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYCameraImageView;

@protocol HYCameraImageViewDelegate <NSObject>

@optional
/**
 *  根据index来删除照片
 */
- (void)deleteImageView:(HYCameraImageView *)imageView;

@end

@interface HYCameraImageView : UIImageView

@property (nonatomic, weak) id<HYCameraImageViewDelegate>delegate;
/**
 *  是否是编辑模式，yes代表是
 */
@property (nonatomic, assign, getter=isEdit) BOOL edit;

@end

//
//  HYCameraView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYCameraView;

@protocol HYCameraViewDelegate <NSObject>

@optional

- (void)cameraDidSlected:(HYCameraView *)camera;

@end

@interface HYCameraView : UIView

@property (nonatomic, weak) id<HYCameraViewDelegate>delegate;
@end

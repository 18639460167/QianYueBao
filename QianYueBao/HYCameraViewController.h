//
//  HYCameraViewController.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCamera.h"

typedef void(^HYCameraCallBack)(id object);
@interface HYCameraViewController : UIViewController

// 顶部View
@property (weak, nonatomic) UIView *topView;
// 底部View
@property (weak, nonatomic) UIView *controlView;
// 拍照的个数限制
@property (assign,nonatomic) NSInteger maxCount;
// 完成后回调
@property (copy, nonatomic) HYCameraCallBack callback;

/**
 *  直接调用进行回调
 *
 */
@property (nonatomic, copy) void (^cameraBack)(NSArray<HYCamera *> *assets);

- (void)showPickerVc:(UIViewController *)vc;


@end

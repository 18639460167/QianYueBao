//
//  HYPhotoPickerGroupViewController.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoPickerViewController.h"

@interface HYPhotoPickerGroupViewController : UIViewController

@property (nonatomic , weak) id<HYPhotoPickerViewControllerDelegate> delegate;
@property (nonatomic , assign) PickerViewShowStatus status;
@property (nonatomic , assign) PickerPhotoStatus photoStatus;
@property (nonatomic , assign) NSInteger maxCount;
// 记录选中的值
@property (strong,nonatomic) NSArray *selectAsstes;
// 置顶展示图片
@property (assign,nonatomic) BOOL topShowPhotoPicker;
// 是否显示Camera
@property (assign,nonatomic) BOOL isShowCamera;

@end

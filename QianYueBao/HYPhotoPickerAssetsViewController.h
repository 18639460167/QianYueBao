//
//  HYPhotoPickerAssetsViewController.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoPcikerGroup.h"
#import "HYPhotoPickerCommon.h"
#import "HYPhotoPickerGroupViewController.h"
@interface HYPhotoPickerAssetsViewController : UIViewController

@property (weak , nonatomic) HYPhotoPickerGroupViewController *groupVc;
@property (nonatomic , assign) PickerViewShowStatus status;
@property (nonatomic , strong) HYPhotoPcikerGroup *assetsGroup;
@property (nonatomic , assign) NSInteger maxCount;
// 需要记录选中的值的数据
@property (strong,nonatomic) NSArray *selectPickerAssets;
// 置顶展示图片
@property (assign,nonatomic) BOOL topShowPhotoPicker;
// 是否显示Camera
@property (assign,nonatomic) BOOL isShowCamera;

@end

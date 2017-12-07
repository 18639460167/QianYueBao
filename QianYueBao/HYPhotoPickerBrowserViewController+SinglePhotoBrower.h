//
//  HYPhotoPickerBrowserViewController+SinglePhotoBrower.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerBrowserViewController.h"

@interface HYPhotoPickerBrowserViewController (SinglePhotoBrower)



- (void)showHeadPorTrait:(UIImageView *)toImageView;

- (void)showHeadPorTrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl;

@end

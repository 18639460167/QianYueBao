//
//  HYPhotoPickerBrowserViewController+SinglePhotoBrower.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerBrowserViewController+SinglePhotoBrower.h"

@implementation HYPhotoPickerBrowserViewController (SinglePhotoBrower)

#pragma mark - showHeadPortrait 放大缩小一张图片的情况下（查看头像）
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)showHeadPorTrait:(UIImageView *)toImageView
{
    [self showHeadPorTrait:toImageView originUrl:nil];
}

#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)showHeadPorTrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl
{
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = tempF;
    imageView.image = toImageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [mainView addSubview:imageView];
    mainView.clipsToBounds = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        imageView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        imageView.hidden = YES;
        
        HYPhotoPickerBrowerPhoto *photo = [[HYPhotoPickerBrowerPhoto alloc]init];
        photo.photoURL = [NSURL URLWithString:originUrl];
        photo.photoImage = toImageView.image;
        photo.thumbImage = toImageView.image;
        
        HYPhotoPickerBrowserPhotoScrollView *scrollView = [[HYPhotoPickerBrowserPhotoScrollView alloc]init];
        
        __weak typeof(HYPhotoPickerBrowserPhotoScrollView *)wScollview = scrollView;
        scrollView.callBack = ^(id obj){
            [wScollview removeFromSuperview];
            mainView.backgroundColor = [UIColor clearColor];
            imageView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                imageView.frame = tempF;
            } completion:^(BOOL finished) {
                [mainView removeFromSuperview];
            }];
        };
        scrollView.frame = [UIScreen mainScreen].bounds;
        scrollView.photo = photo;
        [mainView addSubview:scrollView];
    }];
}


@end

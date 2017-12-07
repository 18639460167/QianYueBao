//
//  HYPhotoPickerBrowerPhoto.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerBrowerPhoto.h"
#import "HYCamera.h"

@implementation HYPhotoPickerBrowerPhoto

- (void)setPhotoObj:(id)photoObj
{
    _photoObj = photoObj;
    if ([photoObj isKindOfClass:[HYPhotoAssets class]])
    {
        HYPhotoAssets *asset = (HYPhotoAssets *)photoObj;
        self.asset = asset;
    }else if ([photoObj isKindOfClass:[NSURL class]])
    {
        self.photoURL = photoObj;
    }
    else if ([photoObj isKindOfClass:[UIImage class]])
    {
        self.photoImage = photoObj;
    }
    else if ([photoObj isKindOfClass:[NSString class]])
    {
        self.photoURL = [NSURL URLWithString:photoObj];
    }
    else if ([photoObj isKindOfClass:[HYCamera class]])
    {
        self.photoImage = (UIImage *)[photoObj photoImage];
    }
    else
    {
        NSAssert(true == true, @"您传入的类型有问题");
    }
}

- (UIImage *)photoImage
{
    if (!_photoImage && self.asset)
    {
        if ([self.asset isKindOfClass:[UIImage class]])
        {
            _photoImage = (UIImage *)self.asset;
        }
        else if ([self.asset isKindOfClass:[HYPhotoAssets class]])
        {
            _photoImage = [self.asset originImage];
        }
    }
    return _photoImage;
}

- (UIImage *)aspectRadioImage
{
    if (!_aspectRadioImage)
    {
        return [self.asset aspectRatioImage];
    }
    return _aspectRadioImage;
}

- (UIImage *)thumbImage
{
    if (!_thumbImage)
    {
        if (self.asset)
        {
            _thumbImage  =[self.asset thumbImage];
        }
        else if (_photoImage)
        {
            _thumbImage = _photoImage;
        }
        else if ([_toView isKindOfClass:[UIImageView class]])
        {
            _thumbImage = ((UIImageView *)_toView).image;
        }
    }
    return _thumbImage;
}

#pragma mark -传入一个图片对象，可以是URL/UIImage/NSString,返回一个实例
+ (instancetype)photoAnyImageObjWith:(id)imageObj
{
    HYPhotoPickerBrowerPhoto *photo = [[self alloc] init];
    [photo setPhotoObj:imageObj];
    return photo;
}

@end

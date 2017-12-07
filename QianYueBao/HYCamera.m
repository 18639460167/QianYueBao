//
//  HYCamera.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYCamera.h"

@implementation HYCamera

- (UIImage *)photoImage
{
    return [UIImage imageWithContentsOfFile:self.imagePath];
}

@end

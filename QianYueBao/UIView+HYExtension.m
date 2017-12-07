//
//  UIView+HYExtension.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UIView+HYExtension.h"

@implementation UIView (HYExtension)

- (void)setHy_x:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)hy_x
{
    return self.frame.origin.x;
}

- (void)setHy_y:(CGFloat)hy_y
{
    CGRect frame = self.frame;
    frame.origin.y = hy_y;
    self.frame = frame;
}
- (CGFloat)hy_y
{
    return self.frame.origin.y;
}

- (void)setHy_centerX:(CGFloat)hy_centerX
{
    CGPoint center = self.center;
    center.x = hy_centerX;
    self.center = center;
}
- (CGFloat)hy_centerX
{
    return self.center.x;
}

- (void)setHy_centerY:(CGFloat)hy_centerY
{
    CGPoint center = self.center;
    center.y = hy_centerY;
    self.center = center;
}
- (CGFloat)hy_centerY
{
    return self.center.y;
}

- (void)setHy_width:(CGFloat)hy_width
{
    CGRect frame = self.frame;
    frame.size.width = hy_width;
    self.frame = frame;
}
- (CGFloat)hy_width
{
    return self.frame.size.width;
}

- (void)setHy_height:(CGFloat)hy_height
{
    CGRect frame = self.frame;
    frame.size.height = hy_height;
    self.frame = frame;
}
- (CGFloat)hy_height
{
    return self.frame.size.height;
}

- (void)setHy_size:(CGSize)hy_size
{
    CGRect frame = self.frame;
    frame.size = hy_size;
    self.frame = frame;
}
- (CGSize)hy_size
{
    return self.frame.size;
}
@end

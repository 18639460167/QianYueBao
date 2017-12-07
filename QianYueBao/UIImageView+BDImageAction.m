//
//  UIImageView+BDImageAction.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/30.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UIImageView+BDImageAction.h"

@implementation UIImageView (BDImageAction)

+ (instancetype)createImage:(NSString *)name
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
    if ([name isEqualToString:@""] || name == nil)
    {
        
    }
    else
    {
        image.image = [UIImage imageNamed:name];
    }
    return image;
}

+ (instancetype)createImageWithColor:(UIColor *)color
{
    UIColor *bgColor = WHITE_COLOR;
    if (color)
    {
        bgColor = color;
    }
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
    image.image = [BDStyle imageWithColor:bgColor size:CGSizeMake(1.0, 1.0)];
    return image;
}

@end

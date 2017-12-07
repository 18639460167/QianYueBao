//
//  UIImage+BDImageAction.h
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BDImageAction)

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

/**
 *  获取用户头像
 *
 */
+ (UIImage *)getHeardImage;
@end

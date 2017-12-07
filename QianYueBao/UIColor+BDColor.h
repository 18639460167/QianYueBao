//
//  UIColor+BDColor.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BDColor)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)lineColor;

+ (UIColor *)navigationColor;

/**
 *  969696
 *
 */
+ (UIColor *)nineSixColor;

/**
 *  323232
 *
 */
+ (UIColor *)threeTwoColor;

/**
 *  c8c8c8
 *
 */
+ (UIColor *)cEightColor;

/**
 *  主色调 fc6c72
 
 */
+ (UIColor *)subjectColor;

@end

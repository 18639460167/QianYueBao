//
//  UIColor+BDColor.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UIColor+BDColor.h"

@implementation UIColor (BDColor)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithHexString:@"#e1e1e1"];
}

+ (UIColor *)navigationColor
{
    return [UIColor colorWithHexString:@"#fc6c72"];
}

+ (UIColor *)nineSixColor
{
    return [UIColor colorWithHexString:@"#969696"];
}

+ (UIColor *)threeTwoColor
{
    return [UIColor colorWithHexString:@"#323232"];
}

+ (UIColor *)cEightColor
{
    return [UIColor colorWithHexString:@"#c8c8c8"];
}

+ (UIColor *)subjectColor
{
    return [UIColor colorWithHexString:@"#fc6c72"];
}


@end

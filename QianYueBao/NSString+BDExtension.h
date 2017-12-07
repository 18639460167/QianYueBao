//
//  NSString+BDExtension.h
//  QianYueBao
//
//  Created by Black on 17/4/20.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BDExtension)

+ (NSString *)trimNSNullAsNoValue:(id)aData;

+ (NSString *)trimNSNullAsFloatero:(id)aData;

+ (NSString *)trimNSNullAsIntValue:(id)aData;

+ (NSArray *)trimNsNullAsArray:(id)aData;

+ (NSDictionary *)trimNsNullAsDic:(id)aData;

+ (NSString *)trimNSNullASTimeValue:(id)aData withStyle:(NSString *)style;

+ (NSString *)trimNSNullASDefault:(id)aData andDefault:(NSString *)model;

+ (NSString *)getCurrentTime;


+ (NSMutableAttributedString *)getStr:(NSString *)oldStr textColor:(id)txtColor;

/**
 *  添加冒号
 *
 */
- (NSString *)addColon;

/**
 *  多种字体颜色
 *
 *
 *  @return 
 */
+(NSMutableAttributedString *)getMessage:(NSString *)colorStr defaultMessage:(NSString *)message textColor:(UIColor *)color;

+ (NSString *)getMessageWithArray:(NSArray *)array;

+ (CGFloat)getRowHeight:(NSString *)message titleWidth:(CGFloat)width;



@end

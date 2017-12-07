//
//  UILabel+BDLabelAction.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BDLabelAction)

/**
 *  文本剧中
 */

+ (instancetype)createLbl:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor;

+ (instancetype)createNoramlLbl:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor;

+ (instancetype)createRightLbl:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor;


@end

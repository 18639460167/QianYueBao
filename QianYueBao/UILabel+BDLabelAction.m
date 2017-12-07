//
//  UILabel+BDLabelAction.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UILabel+BDLabelAction.h"

@implementation UILabel (BDLabelAction)

+ (instancetype)createLbl:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONTSIZE(font);
    label.textColor = textColor;
    label.text = title;
    return label;
}

+ (instancetype)createNoramlLbl:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font =FONTSIZE(font);
    label.textColor = textColor;
    label.text = title;
    return label;
}

+ (instancetype)createRightLbl:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentRight;
    label.font = FONTSIZE(font);
    label.textColor = textColor;
    label.text = title;
    return label;
}


@end

//
//  UITextField+BDTextAction.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UITextField+BDTextAction.h"

@implementation UITextField (BDTextAction)

+ (instancetype)createText:(NSString *)place font:(CGFloat)font textColor:(UIColor *)textColor
{
    UITextField *textFiled = [[UITextField alloc]initWithFrame:CGRectZero];
    textFiled.placeholder = place;
    textFiled.font = FONTSIZE(font);
    textFiled.textColor = textColor;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textFiled;
}
@end

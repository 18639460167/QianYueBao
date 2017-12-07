//
//  NSString+BDExtension.m
//  QianYueBao
//
//  Created by Black on 17/4/20.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "NSString+BDExtension.h"

@implementation NSString (BDExtension)

+ (NSString *)trimNSNullAsNoValue:(id)aData
{
    NSString *string;
    if ([aData isEqual:[NSNull null]] || aData==nil)
    {
        string = @"";
    }
    else
    {
        string = aData;
        string = [NSString stringWithFormat:@"%@",string];
    }
    return string;
}

#pragma mark - 数组
+ (NSArray *)trimNsNullAsArray:(id)aData
{
    NSArray *dataArray = [NSArray new];
    if ([aData isEqual:[NSNull null]] || aData==nil)
    {
        
    }
    else
    {
        dataArray = aData;
    }
    return dataArray;
}

#pragma mark -字典
+ (NSDictionary *)trimNsNullAsDic:(id)aData
{
    NSDictionary *dic = [NSDictionary new];
    if ([aData isEqual:[NSNull null]] || aData==nil)
    {
        
    }
    else
    {
        dic = aData;
    }
    return dic;
}

#pragma mark - 整数
+ (NSString *)trimNSNullAsIntValue:(id)aData
{
    NSString *string;
    if ([aData isEqual:[NSNull null]] || aData==nil)
    {
        string = @"0";
    }
    else
    {
        string = aData;
        string = [NSString stringWithFormat:@"%@",string];
    }
    return string;
}

#pragma mark - 时间戳转当地时间
+ (NSString *)trimNSNullASTimeValue:(id)aData withStyle:(NSString *)style
{
    NSString *timeStr;
    if ([aData isEqual:[NSNull null]] || aData==nil)
    {
        if ([style isEqualToString:@"0"])
        {
            timeStr = @"0000-00-00";
        }
        else
        {
            timeStr = @"0000-00-00 00:00:00";
        }
        
    }
    else
    {
        timeStr = aData;
        timeStr = [NSString stringWithFormat:@"%@",timeStr];
        timeStr = [self getTime:timeStr withStyle:style];
    }
    return timeStr;
}

+ (NSString *)getTime:(NSString *)time withStyle:(NSString *)style
{
    NSDate *date = [self timeStampDate:time];
    if (date)
    {
        NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
        [objDateformat setDateStyle:NSDateFormatterMediumStyle];
        [objDateformat setTimeZone:[NSTimeZone systemTimeZone]];
        [objDateformat setTimeStyle:NSDateFormatterShortStyle];
        if ([style isEqualToString:@"0"])
        {
            [objDateformat setDateFormat:@"yyyy-MM-dd"];
        }
        else
        {
            [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        
        return [objDateformat stringFromDate:date];
    }
    else
    {
        if ([style isEqualToString:@"0"])
        {
            return @"0000-00-00";
        }
        else
        {
            return @"0000-00-00 00:00:00";
        }
    }
}

+ (NSDate *)timeStampDate:(NSString *)time
{
    if (time.length == 13)
    {
        NSTimeInterval _interval=([time doubleValue]) / 1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        return date;
    }
    else if (time.length == 10)
    {
        NSTimeInterval _interval=([time doubleValue]);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        return date;
    }
    else
    {
        return nil;
    }
}

#pragma mark - float保留俩位小数
+ (NSString *)trimNSNullAsFloatero:(id)aData
{
    NSString *string;
    if ([aData isEqual:[NSNull null]] || aData==nil)
    {
        string = @"0";
    }
    else
    {
        string = aData;
        string = [NSString stringWithFormat:@"%@",string];
        [self getDoubleValue:string];
    }
    return string;
}

+ (NSString *)getDoubleValue:(NSString *)oldStr
{
    oldStr = [NSString stringWithFormat:@"%@",oldStr];
    if ([oldStr rangeOfString:@"."].location != NSNotFound)
    {
        NSArray *array  = [oldStr componentsSeparatedByString:@"."];
        if (array.count>=1)
        {
            NSString *str = [array lastObject];
            if ([str floatValue] == 0)
            {
                oldStr = [array firstObject];
            }
            else
            {
                if (str.length>2)
                {
                    oldStr = [NSString stringWithFormat:@"%.2f",[oldStr doubleValue]];
                }
                NSString *lastStr = [oldStr substringFromIndex:oldStr.length-1];
                if ([lastStr isEqualToString:@"0"])
                {
                    oldStr = [NSString stringWithFormat:@"%.1f",[oldStr doubleValue]];
                }
            }
        }
    }
    return oldStr;
}

#pragma mark - 默认值
+ (NSString *)trimNSNullASDefault:(id)aData andDefault:(NSString *)model
{
    NSString *string;
    if ([aData isEqual:[NSNull null]] || aData==nil)
    {
        string = model;
    }
    else
    {
        string = aData;
        string = [NSString stringWithFormat:@"%@",string];
    }
    return string;
}

#pragma mark - 加下划线
+ (NSMutableAttributedString *)getStr:(NSString *)oldStr textColor:(id)txtColor
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:oldStr];
    NSRange titleRange = {0,oldStr.length};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [title addAttribute:NSForegroundColorAttributeName value:txtColor range:titleRange];
    return title;
}

- (NSString *)addColon
{
    return [NSString stringWithFormat:@"%@:",self];
}

#pragma mark - 多种字体颜色
+ (NSMutableAttributedString *)getMessage:(NSString *)colorStr defaultMessage:(NSString *)message textColor:(UIColor *)color
{
    NSString *title = [NSString stringWithFormat:@"%@%@",colorStr,message];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName
                value:color
                range:NSMakeRange(0,colorStr.length)];
    return str;
}

+ (NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getMessageWithArray:(NSArray *)array
{
    NSString *str = @"";
    for (int i=0; i<array.count; i++)
    {
        if (i==0)
        {
            str = array[i];
        }
        else
        {
            str = [NSString stringWithFormat:@"%@,%@",str,array[i]];
        }
    }
    return str;
}

#pragma mark - 多行显示
+ (CGFloat)getRowHeight:(NSString *)message titleWidth:(CGFloat)width
{
    CGFloat heitgh = [BDStyle getHeightByWidth:SCREEN_WIDTH-width title:message font:15]+(HScale*50-WScale*17.5);
    if (heitgh<HScale*50)
    {
        heitgh = HScale*50;
    }
    return heitgh;
}
@end

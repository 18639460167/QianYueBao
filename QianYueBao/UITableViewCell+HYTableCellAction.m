//
//  UITableViewCell+HYTableCellAction.m
//  QianYueBao
//
//  Created by Black on 17/4/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UITableViewCell+HYTableCellAction.h"

@implementation UITableViewCell (HYTableCellAction)

+ (instancetype)createTableCell:(UITableView *)tableview
{
    NSString *str = NSStringFromClass(self);
    id cell = [tableview dequeueReusableCellWithIdentifier:str];
    if (!cell)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    return cell;
    
}

@end

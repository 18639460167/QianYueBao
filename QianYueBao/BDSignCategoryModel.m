//
//  BDSignCategoryModel.m
//  QianYueBao
//
//  Created by Black on 17/4/14.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSignCategoryModel.h"

@implementation BDSignCategoryModel

- (instancetype)initWithAarray:(NSArray *)array
{
    if (self = [super init])
    {
        if (array)
        {
            self.titleArray = array;
        }
        if (self.titleArray.count>=1)
        {
            self.category = self.titleArray[0];
        }
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.category_id = [NSString trimNSNullAsIntValue:[dic objectForKey:@"id"]];
        self.title = [NSString trimNSNullAsIntValue:[dic objectForKey:@"title"]];
        self.categoryArray = [NSMutableArray new];
        id object = [dic objectForKey:@"children"];
        if ([object isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dic in object)
            {
                BDSignCategoryModel *model = [[BDSignCategoryModel alloc]initWithDic:dic];
                [self.categoryArray addObject:model];
            }
        }
    }
    return self;
}
@end

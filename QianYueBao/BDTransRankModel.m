//
//  BDTransRankModel.m
//  QianYueBao
//
//  Created by Black on 17/6/6.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTransRankModel.h"

@implementation BDTransRankModel

+ (instancetype)createModelWithDic:(NSDictionary *)dic
{
    BDTransRankModel *model = [[BDTransRankModel alloc]initWithDic:dic];
    return model;
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.mid = [NSString trimNSNullASDefault:[dic objectForKey:@"mid"] andDefault:@"-1"];
        self.title = [NSString trimNSNullAsNoValue:[dic objectForKey:@"title"]];
        self.total = [NSString trimNSNullAsFloatero:[dic objectForKey:@"total"]];
    }
    return self;
}

@end
